-- Fix RLS policies for public user registration
-- This migration allows public registration while maintaining security

-- Drop the existing restrictive insert policy
DROP POLICY IF EXISTS "Admins can insert users" ON users;

-- Create a new policy that allows users to insert their own record during registration
CREATE POLICY "Users can insert own record during registration" 
ON users FOR INSERT 
TO authenticated 
WITH CHECK (
    -- Allow if the user is inserting their own record (id matches auth.uid())
    id = auth.uid()
    -- OR if they are an admin
    OR EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Also allow unauthenticated users to insert (for public registration)
CREATE POLICY "Public can insert users during registration" 
ON users FOR INSERT 
TO anon 
WITH CHECK (
    -- Only allow basic fields for public registration
    agent_type IN ('CONSULTANT', 'CONTROL_AGENT', 'COLLECTOR')
    AND agent_level = 'JUNIOR'
    AND is_active = FALSE
    AND is_verified = FALSE
    AND can_create_articles = FALSE
    AND can_edit_articles = FALSE
    AND can_delete_articles = FALSE
    AND can_view_reports = TRUE
    AND can_export_data = FALSE
    AND can_manage_users = FALSE
);

-- Update the audit trigger to handle public registration
CREATE OR REPLACE FUNCTION set_user_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- For public registration, set created_by to the user's own id
        IF auth.uid() IS NULL THEN
            NEW.created_by = NEW.id;
            NEW.updated_by = NEW.id;
        ELSE
            NEW.created_by = auth.uid();
            NEW.updated_by = auth.uid();
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_by = auth.uid();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a function to activate users (admin only)
CREATE OR REPLACE FUNCTION activate_user(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    -- Check if current user is admin
    IF NOT EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    ) THEN
        RAISE EXCEPTION 'Only administrators can activate users';
    END IF;
    
    -- Activate the user
    UPDATE users 
    SET 
        is_active = TRUE,
        is_verified = TRUE,
        updated_by = auth.uid(),
        updated_at = NOW()
    WHERE id = user_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION activate_user(UUID) TO authenticated;

-- Create a view for pending user activations (admin only)
CREATE VIEW pending_user_activations AS
SELECT 
    id,
    user_code,
    username,
    email,
    first_name,
    last_name,
    agent_type,
    agent_level,
    created_at
FROM users 
WHERE is_active = FALSE OR is_verified = FALSE;

-- Grant access to the view for admins only
GRANT SELECT ON pending_user_activations TO authenticated;

-- Create RLS policy for the view
CREATE POLICY "Admins can view pending activations" 
ON pending_user_activations FOR SELECT 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Add user references and audit fields to ARTICLE table
-- This migration enhances the article table to properly track user actions

-- Add new audit columns to article table
ALTER TABLE article 
ADD COLUMN created_by UUID REFERENCES users(id),
ADD COLUMN updated_by UUID REFERENCES users(id);

-- Update the art_agent field to reference users table
-- First, create a temporary column to store the new UUID reference
ALTER TABLE article 
ADD COLUMN agent_user_id UUID REFERENCES users(id);

-- Create index for better performance on user references
CREATE INDEX idx_article_created_by ON article(created_by);
CREATE INDEX idx_article_updated_by ON article(updated_by);
CREATE INDEX idx_article_agent_user_id ON article(agent_user_id);

-- Create function to automatically set audit fields
CREATE OR REPLACE FUNCTION set_article_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_by = auth.uid();
        NEW.updated_by = auth.uid();
        -- Set agent_user_id to the current user if not specified
        IF NEW.agent_user_id IS NULL THEN
            NEW.agent_user_id = auth.uid();
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_by = auth.uid();
        -- Update agent_user_id if it was changed
        IF NEW.agent_user_id IS DISTINCT FROM OLD.agent_user_id THEN
            NEW.updated_by = auth.uid();
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically set audit fields
CREATE TRIGGER set_article_audit_fields
BEFORE INSERT OR UPDATE ON article
FOR EACH ROW
EXECUTE FUNCTION set_article_audit_fields();

-- Update RLS policies to include user-based access control
-- Users can only view articles they created or are assigned to
DROP POLICY IF EXISTS "Authenticated users can read articles" ON article;
CREATE POLICY "Users can read assigned articles" 
ON article FOR SELECT 
TO authenticated 
USING (
    created_by = auth.uid() 
    OR agent_user_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type IN ('ADMIN', 'SUPERVISOR')
    )
);

-- Users can only insert articles if they have permission
DROP POLICY IF EXISTS "Authenticated users can insert articles" ON article;
CREATE POLICY "Users can insert articles if permitted" 
ON article FOR INSERT 
TO authenticated 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND (u.can_create_articles = TRUE OR u.agent_type IN ('ADMIN', 'SUPERVISOR'))
    )
);

-- Users can only update articles they created or are assigned to
DROP POLICY IF EXISTS "Authenticated users can update articles" ON article;
CREATE POLICY "Users can update assigned articles" 
ON article FOR UPDATE 
TO authenticated 
USING (
    created_by = auth.uid() 
    OR agent_user_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND (u.can_edit_articles = TRUE OR u.agent_type IN ('ADMIN', 'SUPERVISOR'))
    )
);

-- Users can only delete articles they created (with proper permissions)
DROP POLICY IF EXISTS "Authenticated users can delete articles" ON article;
CREATE POLICY "Users can delete own articles if permitted" 
ON article FOR DELETE 
TO authenticated 
USING (
    created_by = auth.uid() 
    AND EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND (u.can_delete_articles = TRUE OR u.agent_type IN ('ADMIN', 'SUPERVISOR'))
    )
);

-- Create view for articles with user information
CREATE VIEW article_with_users AS
SELECT 
    a.*,
    creator.username as creator_username,
    creator.first_name as creator_first_name,
    creator.last_name as creator_last_name,
    updater.username as updater_username,
    updater.first_name as updater_first_name,
    updater.last_name as updater_last_name,
    agent.username as agent_username,
    agent.first_name as agent_first_name,
    agent.last_name as agent_last_name,
    agent.agent_type as agent_type
FROM article a
LEFT JOIN users creator ON a.created_by = creator.id
LEFT JOIN users updater ON a.updated_by = updater.id
LEFT JOIN users agent ON a.agent_user_id = agent.id;

-- Grant access to the view
GRANT SELECT ON article_with_users TO authenticated;

-- Create function to get articles by assigned agent
CREATE OR REPLACE FUNCTION get_articles_by_agent(agent_id UUID)
RETURNS TABLE (
    art_nouv_code VARCHAR(12),
    art_texte_adresse TEXT,
    art_sur_tot DOUBLE PRECISION,
    art_mnt_taxe DOUBLE PRECISION,
    art_etat SMALLINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.art_nouv_code,
        a.art_texte_adresse,
        a.art_sur_tot,
        a.art_mnt_taxe,
        a.art_etat,
        a.created_at,
        a.updated_at
    FROM article a
    WHERE a.agent_user_id = agent_id
    ORDER BY a.updated_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to get articles by arrondissement
CREATE OR REPLACE FUNCTION get_articles_by_arrondissement(arrond_code VARCHAR(2))
RETURNS TABLE (
    art_nouv_code VARCHAR(12),
    art_texte_adresse TEXT,
    art_sur_tot DOUBLE PRECISION,
    art_mnt_taxe DOUBLE PRECISION,
    art_etat SMALLINT,
    art_latitude DOUBLE PRECISION,
    art_longitude DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.art_nouv_code,
        a.art_texte_adresse,
        a.art_sur_tot,
        a.art_mnt_taxe,
        a.art_etat,
        a.art_latitude,
        a.art_longitude
    FROM article a
    WHERE a.art_arrond = arrond_code
    ORDER BY a.art_texte_adresse;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

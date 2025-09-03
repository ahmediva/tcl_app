-- Enhanced USERS table for Municipal Agents in TCL Application
-- This migration enhances the existing users table to support municipal agents

-- Drop the existing users table if it exists
DROP TABLE IF EXISTS USERS CASCADE;

-- Create enhanced USERS table for Municipal Agents
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_code VARCHAR(30) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    
    -- Personal Information
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    
    -- Agent-specific Information
    agent_type VARCHAR(50) NOT NULL CHECK (agent_type IN ('ADMIN', 'CONTROL_AGENT', 'COLLECTOR', 'SUPERVISOR', 'CONSULTANT')),
    agent_level VARCHAR(20) DEFAULT 'JUNIOR' CHECK (agent_level IN ('JUNIOR', 'SENIOR', 'MANAGER', 'DIRECTOR')),
    
    -- Work-related Information
    employee_id VARCHAR(20) UNIQUE,
    department VARCHAR(100),
    position VARCHAR(100),
    hire_date DATE DEFAULT CURRENT_DATE,
    
    -- Geographic Assignment (for agents assigned to specific areas)
    assigned_arrondissement VARCHAR(2) REFERENCES arrondissement(code),
    assigned_commune VARCHAR(10) REFERENCES commune(code_m),
    
    -- Permissions and Access Control
    can_create_articles BOOLEAN DEFAULT FALSE,
    can_edit_articles BOOLEAN DEFAULT FALSE,
    can_delete_articles BOOLEAN DEFAULT FALSE,
    can_view_reports BOOLEAN DEFAULT FALSE,
    can_export_data BOOLEAN DEFAULT FALSE,
    can_manage_users BOOLEAN DEFAULT FALSE,
    
    -- Status and Activity
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP,
    
    -- Audit Fields
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_user_code ON users(user_code);
CREATE INDEX idx_users_agent_type ON users(agent_type);
CREATE INDEX idx_users_assigned_arrondissement ON users(assigned_arrondissement);
CREATE INDEX idx_users_assigned_commune ON users(assigned_commune);
CREATE INDEX idx_users_is_active ON users(is_active);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for different user roles
-- Users can read their own profile
CREATE POLICY "Users can read own profile" 
ON users FOR SELECT 
TO authenticated 
USING (auth.uid() = id);

-- Admins can read all users
CREATE POLICY "Admins can read all users" 
ON users FOR SELECT 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Users can update their own profile (except sensitive fields)
CREATE POLICY "Users can update own profile" 
ON users FOR UPDATE 
TO authenticated 
USING (auth.uid() = id)
WITH CHECK (
    auth.uid() = id 
    AND agent_type = OLD.agent_type 
    AND can_manage_users = OLD.can_manage_users
);

-- Admins can insert new users
CREATE POLICY "Admins can insert users" 
ON users FOR INSERT 
TO authenticated 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Admins can update all users
CREATE POLICY "Admins can update all users" 
ON users FOR UPDATE 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Admins can delete users
CREATE POLICY "Admins can delete users" 
ON users FOR DELETE 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$ 
BEGIN 
    NEW.updated_at = NOW(); 
    RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_users_updated_at 
BEFORE UPDATE ON users 
FOR EACH ROW 
EXECUTE FUNCTION update_users_updated_at();

-- Create function to set created_by and updated_by
CREATE OR REPLACE FUNCTION set_user_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_by = auth.uid();
        NEW.updated_by = auth.uid();
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_by = auth.uid();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically set audit fields
CREATE TRIGGER set_users_audit_fields
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_user_audit_fields();

-- Insert default admin user (password should be changed after first login)
INSERT INTO users (
    user_code, 
    username, 
    email, 
    password_hash, 
    first_name, 
    last_name, 
    agent_type, 
    agent_level,
    employee_id,
    department,
    position,
    can_create_articles,
    can_edit_articles,
    can_delete_articles,
    can_view_reports,
    can_export_data,
    can_manage_users,
    is_verified
) VALUES (
    'ADMIN001',
    'admin',
    'admin@tcl.gov.tn',
    '$2a$10$dummy.hash.for.initial.admin.password.change.required',
    'System',
    'Administrator',
    'ADMIN',
    'DIRECTOR',
    'EMP001',
    'IT Department',
    'System Administrator',
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE
);

-- Create user_sessions table for tracking user activity
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) NOT NULL,
    device_info TEXT,
    ip_address INET,
    login_time TIMESTAMP DEFAULT NOW(),
    logout_time TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS on user_sessions
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;

-- Users can view their own sessions
CREATE POLICY "Users can view own sessions" 
ON user_sessions FOR SELECT 
TO authenticated 
USING (user_id = auth.uid());

-- Create user_activity_log table for audit trail
CREATE TABLE user_activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id VARCHAR(100),
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS on user_activity_log
ALTER TABLE user_activity_log ENABLE ROW LEVEL SECURITY;

-- Users can view their own activity log
CREATE POLICY "Users can view own activity log" 
ON user_activity_log FOR SELECT 
TO authenticated 
USING (user_id = auth.uid());

-- Admins can view all activity logs
CREATE POLICY "Admins can view all activity logs" 
ON user_activity_log FOR SELECT 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() 
        AND u.agent_type = 'ADMIN'
    )
);

-- Create indexes for performance
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_user_activity_log_user_id ON user_activity_log(user_id);
CREATE INDEX idx_user_activity_log_created_at ON user_activity_log(created_at);

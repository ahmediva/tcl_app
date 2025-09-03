-- Sample Users Data for TCL Application
-- This migration inserts sample municipal agents for testing and development

-- Insert sample users with different roles and permissions
INSERT INTO users (
    user_code, 
    username, 
    email, 
    password_hash, 
    first_name, 
    last_name, 
    phone,
    address,
    agent_type, 
    agent_level,
    employee_id,
    department,
    position,
    assigned_arrondissement,
    assigned_commune,
    can_create_articles,
    can_edit_articles,
    can_delete_articles,
    can_view_reports,
    can_export_data,
    can_manage_users,
    is_verified
) VALUES 
-- Supervisors
(
    'SUP001',
    'ahmed.benali',
    'ahmed.benali@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Ahmed',
    'Ben Ali',
    '+216 71 123 456',
    '123 Rue de la République, Tunis',
    'SUPERVISOR',
    'MANAGER',
    'EMP002',
    'Contrôle Fiscal',
    'Superviseur Principal',
    '01',
    'TUN001',
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    FALSE,
    TRUE
),
(
    'SUP002',
    'fatma.trabelsi',
    'fatma.trabelsi@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Fatma',
    'Trabelsi',
    '+216 71 234 567',
    '456 Avenue Habib Bourguiba, Tunis',
    'SUPERVISOR',
    'SENIOR',
    'EMP003',
    'Recouvrement',
    'Superviseur Recouvrement',
    '02',
    'TUN002',
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    FALSE,
    TRUE
),

-- Control Agents
(
    'CTL001',
    'mohamed.hamdi',
    'mohamed.hamdi@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Mohamed',
    'Hamdi',
    '+216 71 345 678',
    '789 Rue du Lac, Tunis',
    'CONTROL_AGENT',
    'SENIOR',
    'EMP004',
    'Contrôle Fiscal',
    'Agent de Contrôle',
    '01',
    'TUN001',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),
(
    'CTL002',
    'nadia.khalil',
    'nadia.khalil@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Nadia',
    'Khalil',
    '+216 71 456 789',
    '321 Boulevard du 7 Novembre, Tunis',
    'CONTROL_AGENT',
    'JUNIOR',
    'EMP005',
    'Contrôle Fiscal',
    'Agent de Contrôle',
    '03',
    'TUN003',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),
(
    'CTL003',
    'karim.mansouri',
    'karim.mansouri@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Karim',
    'Mansouri',
    '+216 71 567 890',
    '654 Rue de Carthage, Tunis',
    'CONTROL_AGENT',
    'SENIOR',
    'EMP006',
    'Contrôle Fiscal',
    'Agent de Contrôle',
    '04',
    'TUN004',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),

-- Collection Agents
(
    'COL001',
    'sami.chaabane',
    'sami.chaabane@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Sami',
    'Chaabane',
    '+216 71 678 901',
    '987 Avenue de la Liberté, Tunis',
    'COLLECTOR',
    'SENIOR',
    'EMP007',
    'Recouvrement',
    'Agent de Recouvrement',
    '01',
    'TUN001',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),
(
    'COL002',
    'leila.bouzid',
    'leila.bouzid@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Leila',
    'Bouzid',
    '+216 71 789 012',
    '147 Rue de la Paix, Tunis',
    'COLLECTOR',
    'JUNIOR',
    'EMP008',
    'Recouvrement',
    'Agent de Recouvrement',
    '02',
    'TUN002',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),
(
    'COL003',
    'youssef.gharbi',
    'youssef.gharbi@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Youssef',
    'Gharbi',
    '+216 71 890 123',
    '258 Boulevard de la République, Tunis',
    'COLLECTOR',
    'SENIOR',
    'EMP009',
    'Recouvrement',
    'Agent de Recouvrement',
    '05',
    'TUN005',
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),

-- Consultants (Read-only access)
(
    'CON001',
    'amira.slim',
    'amira.slim@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Amira',
    'Slim',
    '+216 71 901 234',
    '369 Rue de la Démocratie, Tunis',
    'CONSULTANT',
    'JUNIOR',
    'EMP010',
    'Consultation',
    'Consultant Fiscal',
    NULL,
    NULL,
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
),
(
    'CON002',
    'hassan.mezni',
    'hassan.mezni@tcl.gov.tn',
    '$2a$10$dummy.hash.for.testing.password.change.required',
    'Hassan',
    'Mezni',
    '+216 71 012 345',
    '741 Avenue des Martyrs, Tunis',
    'CONSULTANT',
    'SENIOR',
    'EMP011',
    'Consultation',
    'Consultant Senior',
    NULL,
    NULL,
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE
);

-- Insert sample user sessions for testing
INSERT INTO user_sessions (
    user_id,
    session_token,
    device_info,
    ip_address,
    login_time,
    is_active
) 
SELECT 
    id,
    'sample_token_' || user_code,
    'Test Device - Flutter App',
    '127.0.0.1',
    NOW() - INTERVAL '1 hour',
    TRUE
FROM users 
WHERE agent_type IN ('ADMIN', 'SUPERVISOR')
LIMIT 3;

-- Insert sample activity log entries
INSERT INTO user_activity_log (
    user_id,
    action,
    table_name,
    record_id,
    old_values,
    new_values,
    ip_address,
    user_agent,
    created_at
) VALUES 
(
    (SELECT id FROM users WHERE user_code = 'ADMIN001'),
    'CREATE',
    'users',
    'SUP001',
    NULL,
    '{"user_code": "SUP001", "username": "ahmed.benali", "agent_type": "SUPERVISOR"}',
    '127.0.0.1',
    'TCL Mobile App v1.0',
    NOW() - INTERVAL '2 hours'
),
(
    (SELECT id FROM users WHERE user_code = 'SUP001'),
    'VIEW',
    'article',
    'ART001',
    NULL,
    NULL,
    '192.168.1.100',
    'TCL Mobile App v1.0',
    NOW() - INTERVAL '30 minutes'
),
(
    (SELECT id FROM users WHERE user_code = 'CTL001'),
    'UPDATE',
    'article',
    'ART002',
    '{"art_etat": 0}',
    '{"art_etat": 1}',
    '192.168.1.101',
    'TCL Mobile App v1.0',
    NOW() - INTERVAL '15 minutes'
);

-- Create a view for user summary information
CREATE VIEW user_summary AS
SELECT 
    u.id,
    u.user_code,
    u.username,
    u.email,
    u.first_name,
    u.last_name,
    u.agent_type,
    u.agent_level,
    u.department,
    u.position,
    u.assigned_arrondissement,
    u.assigned_commune,
    u.is_active,
    u.last_login,
    COUNT(s.id) as active_sessions,
    COUNT(a.id) as assigned_articles,
    COUNT(l.id) as total_actions
FROM users u
LEFT JOIN user_sessions s ON u.id = s.user_id AND s.is_active = TRUE
LEFT JOIN article a ON u.id = a.agent_user_id
LEFT JOIN user_activity_log l ON u.id = l.user_id
GROUP BY u.id, u.user_code, u.username, u.email, u.first_name, u.last_name, 
         u.agent_type, u.agent_level, u.department, u.position, 
         u.assigned_arrondissement, u.assigned_commune, u.is_active, u.last_login;

-- Grant access to the view
GRANT SELECT ON user_summary TO authenticated;

-- Create a function to get user statistics
CREATE OR REPLACE FUNCTION get_user_statistics()
RETURNS TABLE (
    total_users INTEGER,
    active_users INTEGER,
    users_by_type JSONB,
    users_by_arrondissement JSONB,
    recent_activity INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_users,
        COUNT(CASE WHEN is_active THEN 1 END)::INTEGER as active_users,
        jsonb_object_agg(agent_type, count) as users_by_type,
        jsonb_object_agg(COALESCE(assigned_arrondissement, 'Unassigned'), count) as users_by_arrondissement,
        COUNT(CASE WHEN last_login > NOW() - INTERVAL '24 hours' THEN 1 END)::INTEGER as recent_activity
    FROM (
        SELECT 
            agent_type,
            assigned_arrondissement,
            COUNT(*) as count
        FROM users 
        GROUP BY agent_type, assigned_arrondissement
    ) t;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION get_user_statistics() TO authenticated;

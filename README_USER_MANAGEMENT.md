# User Management System for TCL Application

## Overview

This document describes the enhanced user management system designed specifically for municipal agents working with the TCL (Taxe sur les établissements à caractère industriel, commercial ou professionnel) application. The system provides role-based access control, geographic assignment capabilities, and comprehensive audit trails.

## Database Schema

### Core Tables

#### 1. `users` - Main User Table
The central table for managing municipal agents with comprehensive role and permission management.

**Key Fields:**
- `id`: Unique UUID identifier
- `user_code`: Human-readable user code (e.g., "AGENT001")
- `username`: Login username
- `email`: User email address
- `password_hash`: Encrypted password
- `first_name`, `last_name`: Personal identification
- `phone`, `address`: Contact information

**Agent Classification:**
- `agent_type`: Role classification
  - `ADMIN`: System administrators with full access
  - `CONTROL_AGENT`: Field agents for inspections
  - `COLLECTOR`: Tax collection agents
  - `SUPERVISOR`: Team supervisors
  - `CONSULTANT`: Read-only access for stakeholders
- `agent_level`: Experience/authority level
  - `JUNIOR`, `SENIOR`, `MANAGER`, `DIRECTOR`

**Work Assignment:**
- `assigned_arrondissement`: Geographic area assignment
- `assigned_commune`: Municipality assignment
- `department`, `position`: Organizational structure
- `hire_date`: Employment start date

**Permissions:**
- `can_create_articles`: Create new establishment records
- `can_edit_articles`: Modify existing records
- `can_delete_articles`: Remove records
- `can_view_reports`: Access analytical reports
- `can_export_data`: Export data to external formats
- `can_manage_users`: User management capabilities

**Security & Status:**
- `is_active`: Account status
- `is_verified`: Email verification status
- `login_attempts`: Failed login counter
- `locked_until`: Account lockout timestamp

#### 2. `user_sessions` - Session Management
Tracks user login sessions for security and audit purposes.

**Fields:**
- `user_id`: Reference to users table
- `session_token`: Authentication token
- `device_info`: Device/browser information
- `ip_address`: Connection IP address
- `login_time`, `logout_time`: Session duration
- `is_active`: Session status

#### 3. `user_activity_log` - Audit Trail
Comprehensive logging of all user actions for compliance and security.

**Fields:**
- `user_id`: User performing the action
- `action`: Type of operation (CREATE, UPDATE, DELETE, VIEW)
- `table_name`: Affected database table
- `record_id`: Specific record identifier
- `old_values`, `new_values`: Data changes (JSON format)
- `ip_address`, `user_agent`: Technical context
- `created_at`: Timestamp of action

### Enhanced Article Table

The `article` table (establishment records) now includes:
- `created_by`: User who created the record
- `updated_by`: User who last modified the record
- `agent_user_id`: Assigned agent for the establishment

## Role-Based Access Control

### Permission Matrix

| Agent Type | Create | Edit | Delete | View Reports | Export | Manage Users |
|------------|--------|------|--------|--------------|---------|--------------|
| ADMIN | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| SUPERVISOR | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| CONTROL_AGENT | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| COLLECTOR | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| CONSULTANT | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

### Geographic Access Control

Users can only access records within their assigned geographic areas:
- **Arrondissement Level**: Access to establishments in specific districts
- **Commune Level**: Access to establishments in specific municipalities
- **Cross-Area Access**: Supervisors and admins can access all areas

## Security Features

### Row Level Security (RLS)
- **User Isolation**: Users can only see their own data and assigned records
- **Role-Based Access**: Different permissions based on agent type
- **Geographic Restrictions**: Access limited to assigned areas

### Authentication & Authorization
- **Password Security**: Bcrypt hashing with salt
- **Session Management**: Secure token-based sessions
- **Account Lockout**: Protection against brute force attacks
- **Multi-Factor Support**: Ready for future MFA implementation

### Audit & Compliance
- **Complete Audit Trail**: All actions logged with context
- **Data Change Tracking**: Before/after values for modifications
- **User Activity Monitoring**: Session tracking and analysis
- **Compliance Ready**: Meets government security requirements

## API Functions

### User Management
```sql
-- Get articles assigned to specific agent
SELECT * FROM get_articles_by_agent('user-uuid-here');

-- Get articles by geographic area
SELECT * FROM get_articles_by_arrondissement('01');

-- View articles with user information
SELECT * FROM article_with_users;
```

### Security Functions
```sql
-- Check user permissions
SELECT can_create_articles, can_edit_articles 
FROM users 
WHERE id = auth.uid();

-- Get user's assigned areas
SELECT assigned_arrondissement, assigned_commune 
FROM users 
WHERE id = auth.uid();
```

## Implementation Guide

### 1. Database Setup
Run the migration files in order:
```bash
# Apply migrations
supabase db reset
# or
supabase migration up
```

### 2. Initial Configuration
1. **Default Admin User**: System creates initial admin account
   - Username: `admin`
   - Email: `admin@tcl.gov.tn`
   - **IMPORTANT**: Change password after first login

2. **Create Agent Accounts**: Use admin account to create other users
3. **Assign Geographic Areas**: Set arrondissement and commune assignments
4. **Configure Permissions**: Set appropriate permission flags

### 3. Flutter Integration

#### User Model
```dart
class User {
  final String id;
  final String userCode;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String agentType;
  final String agentLevel;
  final String? assignedArrondissement;
  final String? assignedCommune;
  final UserPermissions permissions;
  final bool isActive;
  
  // ... constructor and methods
}

class UserPermissions {
  final bool canCreateArticles;
  final bool canEditArticles;
  final bool canDeleteArticles;
  final bool canViewReports;
  final bool canExportData;
  final bool canManageUsers;
  
  // ... constructor and methods
}
```

#### Authentication Service
```dart
class AuthService {
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<bool> hasPermission(String permission);
  Future<List<Article>> getAssignedArticles();
}
```

#### Permission Checks
```dart
// Check if user can create articles
if (await authService.hasPermission('can_create_articles')) {
  // Show create article button
}

// Check geographic access
if (user.assignedArrondissement == article.artArrond) {
  // Allow access to article
}
```

## Best Practices

### 1. Security
- **Regular Password Updates**: Enforce password change policies
- **Session Timeout**: Implement automatic logout after inactivity
- **Permission Reviews**: Regularly audit user permissions
- **Access Logging**: Monitor unusual access patterns

### 2. User Management
- **Principle of Least Privilege**: Grant minimum necessary permissions
- **Geographic Assignment**: Ensure agents are assigned to appropriate areas
- **Regular Reviews**: Update user assignments and permissions as needed
- **Training**: Ensure users understand their role and limitations

### 3. Data Integrity
- **Audit Trail**: Never disable logging
- **Backup Procedures**: Regular database backups
- **Change Management**: Document all permission changes
- **Testing**: Test permission changes in development environment

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**
   - Check user's agent type and permission flags
   - Verify geographic assignments
   - Ensure user account is active

2. **Session Issues**
   - Check user_sessions table for active sessions
   - Verify authentication tokens
   - Check account lockout status

3. **Geographic Access Problems**
   - Verify arrondissement and commune assignments
   - Check article location data
   - Ensure proper foreign key relationships

### Debug Queries
```sql
-- Check user permissions
SELECT * FROM users WHERE id = 'user-uuid-here';

-- View user's assigned articles
SELECT * FROM article WHERE agent_user_id = 'user-uuid-here';

-- Check RLS policies
SELECT * FROM pg_policies WHERE tablename = 'users';
```

## Future Enhancements

1. **Multi-Factor Authentication**: SMS/email verification codes
2. **Advanced Role Management**: Custom permission sets
3. **Geographic Hierarchy**: Nested area assignments
4. **Integration APIs**: Connect with external municipal systems
5. **Mobile-Specific Features**: Offline capability, push notifications

## Support

For technical support or questions about the user management system:
- **Database Issues**: Check migration logs and error messages
- **Permission Problems**: Verify user configuration and RLS policies
- **Security Concerns**: Review audit logs and access patterns
- **Feature Requests**: Document requirements for future development

---

**Version**: 1.0  
**Last Updated**: December 2024  
**Compatibility**: Supabase, PostgreSQL 12+  
**Security Level**: Government Grade

# Quick Setup Guide - User Management System

## Overview
This guide will help you set up the enhanced user management system for your TCL application. The system includes role-based access control, geographic assignments, and comprehensive audit trails.

## Prerequisites
- Supabase project configured
- Flutter development environment ready
- Basic understanding of PostgreSQL

## Step 1: Apply Database Migrations

### Option A: Using Supabase CLI (Recommended)
```bash
# Navigate to your project directory
cd /path/to/your/tcl_app

# Apply all migrations
supabase db reset

# Or apply migrations incrementally
supabase migration up
```

### Option B: Manual SQL Execution
If you prefer to run migrations manually:
1. Open your Supabase dashboard
2. Go to SQL Editor
3. Run each migration file in order:
   - `008_enhance_users_table_for_municipal_agents.sql`
   - `009_add_user_references_to_article_table.sql`
   - `010_sample_users_data.sql`

## Step 2: Verify Database Setup

### Check Tables
```sql
-- Verify users table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users';

-- Check if sample data was inserted
SELECT user_code, username, agent_type, is_active 
FROM users 
ORDER BY agent_type, user_code;
```

### Check Permissions
```sql
-- Verify RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'users';

-- Test user access
SELECT * FROM user_summary LIMIT 5;
```

## Step 3: Initial Configuration

### 1. Change Default Admin Password
**IMPORTANT**: The default admin account uses a dummy password hash. You must change it immediately.

```sql
-- Update admin password (replace 'your_secure_password' with actual password)
UPDATE users 
SET password_hash = crypt('your_secure_password', gen_salt('bf'))
WHERE user_code = 'ADMIN001';
```

### 2. Configure Geographic Assignments
```sql
-- Assign agents to specific areas (example)
UPDATE users 
SET assigned_arrondissement = '01', assigned_commune = 'TUN001'
WHERE user_code = 'CTL001';

-- Check assignments
SELECT user_code, username, assigned_arrondissement, assigned_commune
FROM users 
WHERE assigned_arrondissement IS NOT NULL;
```

### 3. Set User Permissions
```sql
-- Grant specific permissions to agents
UPDATE users 
SET can_create_articles = TRUE, can_edit_articles = TRUE
WHERE agent_type = 'CONTROL_AGENT';

-- Verify permissions
SELECT user_code, agent_type, can_create_articles, can_edit_articles
FROM users 
ORDER BY agent_type, user_code;
```

## Step 4: Test the System

### Test User Login
```sql
-- Simulate user authentication
SELECT 
    user_code, 
    username, 
    agent_type,
    can_create_articles,
    assigned_arrondissement
FROM users 
WHERE username = 'ahmed.benali' 
AND is_active = TRUE;
```

### Test Geographic Access
```sql
-- Test if agent can see articles in their area
SELECT 
    a.art_nouv_code,
    a.art_texte_adresse,
    a.art_arrond
FROM article a
JOIN users u ON a.agent_user_id = u.id
WHERE u.user_code = 'CTL001'
AND a.art_arrond = u.assigned_arrondissement;
```

## Step 5: Flutter Integration

### 1. Add Dependencies
Add these to your `pubspec.yaml`:
```yaml
dependencies:
  supabase_flutter: ^1.10.0
  crypto: ^3.0.3
```

### 2. Create User Models
```dart
// lib/models/user.dart
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
  
  // ... constructor and fromJson methods
}

class UserPermissions {
  final bool canCreateArticles;
  final bool canEditArticles;
  final bool canDeleteArticles;
  final bool canViewReports;
  final bool canExportData;
  final bool canManageUsers;
  
  // ... constructor and fromJson methods
}
```

### 3. Create Authentication Service
```dart
// lib/services/auth_service.dart
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return await _getUserProfile(response.user!.id);
      }
      return null;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  Future<User?> _getUserProfile(String userId) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    
    return User.fromJson(response);
  }
  
  Future<bool> hasPermission(String permission) async {
    final user = await getCurrentUser();
    if (user == null) return false;
    
    switch (permission) {
      case 'can_create_articles':
        return user.permissions.canCreateArticles;
      case 'can_edit_articles':
        return user.permissions.canEditArticles;
      // ... other permissions
      default:
        return false;
    }
  }
}
```

## Step 6: Security Checklist

- [ ] Default admin password changed
- [ ] RLS policies verified
- [ ] User permissions configured
- [ ] Geographic assignments set
- [ ] Audit logging enabled
- [ ] Session management working
- [ ] Permission checks implemented in Flutter

## Troubleshooting

### Common Issues

1. **"Permission denied" errors**
   - Check RLS policies are enabled
   - Verify user has correct permissions
   - Check geographic assignments

2. **Users can't see articles**
   - Verify `agent_user_id` is set in article table
   - Check arrondissement assignments match
   - Ensure RLS policies allow access

3. **Authentication fails**
   - Verify password hash format
   - Check if user account is active
   - Verify email verification status

### Debug Commands
```sql
-- Check user status
SELECT user_code, username, is_active, is_verified 
FROM users 
WHERE username = 'your_username';

-- Check RLS policies
SELECT * FROM pg_policies WHERE tablename = 'users';

-- Test user permissions
SELECT can_create_articles, can_edit_articles 
FROM users 
WHERE id = 'user-uuid-here';
```

## Next Steps

1. **Customize User Roles**: Modify agent types and permissions as needed
2. **Add More Users**: Create additional municipal agents
3. **Implement UI**: Build Flutter screens for user management
4. **Add Features**: Implement password reset, user profile editing
5. **Security Audit**: Regular review of permissions and access logs

## Support

If you encounter issues:
1. Check the migration logs in Supabase
2. Verify all SQL commands executed successfully
3. Test with sample data first
4. Review RLS policies and permissions

---

**Note**: This system is designed for government-grade security. Always test thoroughly in development before deploying to production.

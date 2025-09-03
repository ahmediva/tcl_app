class TCLUser {
  final String id;
  final String userCode;
  final String username;
  final String email;
  final String passwordHash;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? address;
  final String agentType;
  final String agentLevel;
  final String? employeeId;
  final String? department;
  final String? position;
  final DateTime? hireDate;
  final String? assignedArrondissement;
  final String? assignedCommune;
  final UserPermissions permissions;
  final bool isActive;
  final bool isVerified;
  final DateTime? lastLogin;
  final int loginAttempts;
  final DateTime? lockedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;

  TCLUser({
    required this.id,
    required this.userCode,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.address,
    required this.agentType,
    required this.agentLevel,
    this.employeeId,
    this.department,
    this.position,
    this.hireDate,
    this.assignedArrondissement,
    this.assignedCommune,
    required this.permissions,
    required this.isActive,
    required this.isVerified,
    this.lastLogin,
    required this.loginAttempts,
    this.lockedUntil,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory TCLUser.fromJson(Map<String, dynamic> json) {
    return TCLUser(
      id: json['id'] ?? '',
      userCode: json['user_code'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      address: json['address'],
      agentType: json['agent_type'] ?? '',
      agentLevel: json['agent_level'] ?? 'JUNIOR',
      employeeId: json['employee_id'],
      department: json['department'],
      position: json['position'],
      hireDate: json['hire_date'] != null ? DateTime.parse(json['hire_date']) : null,
      assignedArrondissement: json['assigned_arrondissement'],
      assignedCommune: json['assigned_commune'],
      permissions: UserPermissions.fromJson(json),
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      loginAttempts: json['login_attempts'] ?? 0,
      lockedUntil: json['locked_until'] != null ? DateTime.parse(json['locked_until']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_code': userCode,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
      'agent_type': agentType,
      'agent_level': agentLevel,
      'employee_id': employeeId,
      'department': department,
      'position': position,
      'hire_date': hireDate?.toIso8601String(),
      'assigned_arrondissement': assignedArrondissement,
      'assigned_commune': assignedCommune,
      'can_create_articles': permissions.canCreateArticles,
      'can_edit_articles': permissions.canEditArticles,
      'can_delete_articles': permissions.canDeleteArticles,
      'can_view_reports': permissions.canViewReports,
      'can_export_data': permissions.canExportData,
      'can_manage_users': permissions.canManageUsers,
      'is_active': isActive,
      'is_verified': isVerified,
      'last_login': lastLogin?.toIso8601String(),
      'login_attempts': loginAttempts,
      'locked_until': lockedUntil?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  // Helper methods
  String get fullName => '$firstName $lastName';
  
  bool get isAdmin => agentType == 'ADMIN';
  bool get isSupervisor => agentType == 'SUPERVISOR';
  bool get isControlAgent => agentType == 'CONTROL_AGENT';
  bool get isCollector => agentType == 'COLLECTOR';
  bool get isConsultant => agentType == 'CONSULTANT';
  
  bool get hasGeographicAssignment => assignedArrondissement != null || assignedCommune != null;
  
  bool get isAccountLocked => lockedUntil != null && lockedUntil!.isAfter(DateTime.now());
}

class UserPermissions {
  final bool canCreateArticles;
  final bool canEditArticles;
  final bool canDeleteArticles;
  final bool canViewReports;
  final bool canExportData;
  final bool canManageUsers;

  UserPermissions({
    required this.canCreateArticles,
    required this.canEditArticles,
    required this.canDeleteArticles,
    required this.canViewReports,
    required this.canExportData,
    required this.canManageUsers,
  });

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    return UserPermissions(
      canCreateArticles: json['can_create_articles'] ?? false,
      canEditArticles: json['can_edit_articles'] ?? false,
      canDeleteArticles: json['can_delete_articles'] ?? false,
      canViewReports: json['can_view_reports'] ?? false,
      canExportData: json['can_export_data'] ?? false,
      canManageUsers: json['can_manage_users'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_create_articles': canCreateArticles,
      'can_edit_articles': canEditArticles,
      'can_delete_articles': canDeleteArticles,
      'can_view_reports': canViewReports,
      'can_export_data': canExportData,
      'can_manage_users': canManageUsers,
    };
  }

  // Helper methods for permission checks
  bool hasPermission(String permission) {
    switch (permission) {
      case 'can_create_articles':
        return canCreateArticles;
      case 'can_edit_articles':
        return canEditArticles;
      case 'can_delete_articles':
        return canDeleteArticles;
      case 'can_view_reports':
        return canViewReports;
      case 'can_export_data':
        return canExportData;
      case 'can_manage_users':
        return canManageUsers;
      default:
        return false;
    }
  }

  bool get canPerformBasicOperations => canCreateArticles || canEditArticles;
  bool get canPerformAdvancedOperations => canDeleteArticles || canExportData;
  bool get isReadOnly => !canCreateArticles && !canEditArticles && !canDeleteArticles;
}

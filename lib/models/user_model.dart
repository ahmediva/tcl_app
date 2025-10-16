class TCLUser {
  final String id;
  final String userCode; // CIN
  final String nom;
  final String prenom;
  final String email;
  final String passwordHash;
  final String? numeroTelephone; // 8 chiffres
  final String agentType; // collecteur, controle, superviseur, admin
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  // Permissions intégrées directement
  final bool canCreateArticles;
  final bool canEditArticles;
  final bool canDeleteArticles;
  final bool canManageUsers;

  TCLUser({
    required this.id,
    required this.userCode,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.passwordHash,
    this.numeroTelephone,
    required this.agentType,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.canCreateArticles,
    required this.canEditArticles,
    required this.canDeleteArticles,
    required this.canManageUsers,
  });

  factory TCLUser.fromJson(Map<String, dynamic> json) {
    return TCLUser(
      id: json['id'] ?? '',
      userCode: json['user_code'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      numeroTelephone: json['numero_telephone'],
      agentType: json['agent_type'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      isActive: json['is_active'] ?? true,
      canCreateArticles: json['can_create_articles'] ?? false,
      canEditArticles: json['can_edit_articles'] ?? false,
      canDeleteArticles: json['can_delete_articles'] ?? false,
      canManageUsers: json['can_manage_users'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_code': userCode,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password_hash': passwordHash,
      'numero_telephone': numeroTelephone,
      'agent_type': agentType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'can_create_articles': canCreateArticles,
      'can_edit_articles': canEditArticles,
      'can_delete_articles': canDeleteArticles,
      'can_manage_users': canManageUsers,
    };
  }

  // Helper methods
  String get fullName => '$prenom $nom';
  
  bool get isAdmin => agentType == 'admin';
  bool get isSupervisor => agentType == 'superviseur';
  bool get isControlAgent => agentType == 'controle';
  bool get isCollector => agentType == 'collecteur';
  
  // Permission helpers
  bool hasPermission(String permission) {
    switch (permission) {
      case 'can_create_articles':
        return canCreateArticles;
      case 'can_edit_articles':
        return canEditArticles;
      case 'can_delete_articles':
        return canDeleteArticles;
      case 'can_manage_users':
        return canManageUsers;
      default:
        return false;
    }
  }
}

// Permissions intégrées directement dans TCLUser

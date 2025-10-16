// Citizen model for TCL Mobile App
class TCLCitizen {
  final String id;
  final String cin; // Carte d'Identité Nationale (8 digits)
  final String nom;
  final String prenom;
  final String email;
  final String? numeroTelephone;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  TCLCitizen({
    required this.id,
    required this.cin,
    required this.nom,
    required this.prenom,
    required this.email,
    this.numeroTelephone,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  // Factory constructor from JSON
  factory TCLCitizen.fromJson(Map<String, dynamic> json) {
    return TCLCitizen(
      id: json['id'] ?? '',
      cin: json['cin'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      numeroTelephone: json['numero_telephone'],
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      lastLogin: _parseDateTime(json['last_login']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cin': cin,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'numero_telephone': numeroTelephone,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Helper method for parsing DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // Get full name
  String get fullName => '$prenom $nom'.trim();

  // Copy with method for updates
  TCLCitizen copyWith({
    String? id,
    String? cin,
    String? nom,
    String? prenom,
    String? email,
    String? numeroTelephone,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return TCLCitizen(
      id: id ?? this.id,
      cin: cin ?? this.cin,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      numeroTelephone: numeroTelephone ?? this.numeroTelephone,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'TCLCitizen(id: $id, cin: $cin, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TCLCitizen && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

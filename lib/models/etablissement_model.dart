class EtablissementModel {
  final String id;
  final String matricule;
  final String address;
  final num superficie;
  final String categorie;
  final bool status;
  final String ownerName;
  final String ownerCin;
  final String tenantName;
  final String tenantActivity;
  final double latitude;
  final double longitude;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  EtablissementModel({
    required this.id,
    required this.matricule,
    required this.address,
    required this.superficie,
    required this.categorie,
    required this.status,
    required this.ownerName,
    required this.ownerCin,
    required this.tenantName,
    required this.tenantActivity,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EtablissementModel.fromJson(Map<String, dynamic> json) {
    return EtablissementModel(
      id: json['id'],
      matricule: json['matricule'],
      address: json['address'],
      superficie: json['superficie'],
      categorie: json['categorie'],
      status: json['status'] == true || json['status'] == 'true',
      ownerName: json['owner_name'],
      ownerCin: json['owner_cin'],
      tenantName: json['tenant_name'],
      tenantActivity: json['tenant_activity'],
      latitude: (json['latitude'] is double) ? json['latitude'] : double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: (json['longitude'] is double) ? json['longitude'] : double.tryParse(json['longitude'].toString()) ?? 0.0,
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'address': address,
      'superficie': superficie,
      'categorie': categorie,
      'status': status,
      'owner_name': ownerName,
      'owner_cin': ownerCin,
      'tenant_name': tenantName,
      'tenant_activity': tenantActivity,
      'latitude': latitude,
      'longitude': longitude,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

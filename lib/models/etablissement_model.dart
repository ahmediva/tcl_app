class EtablissementModel {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String type;

  EtablissementModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.type,
  });

  factory EtablissementModel.fromJson(Map<String, dynamic> json) {
    return EtablissementModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'type': type,
    };
  }
}

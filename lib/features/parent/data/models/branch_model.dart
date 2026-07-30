class BranchModel {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? cellPhone;
  final String? email;
  final String? primaryColor;
  final String? secondaryColor;
  final String? lema;
  final String? department;
  final String? province;
  final String? district;
  final String? urlLogo;
  final String? urlWhatsapp;
  final bool status;

  BranchModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.cellPhone,
    this.email,
    this.primaryColor,
    this.secondaryColor,
    this.lema,
    this.department,
    this.province,
    this.district,
    this.urlLogo,
    this.urlWhatsapp,
    this.status = true,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      cellPhone: json['cellPhone'] as String?,
      email: json['email'] as String?,
      primaryColor: json['primary_color'] as String?,
      secondaryColor: json['secondary_color'] as String?,
      lema: json['lema'] as String?,
      department: json['department'] as String?,
      province: json['province'] as String?,
      district: json['district'] as String?,
      urlLogo: json['url_logo'] as String?,
      urlWhatsapp: json['url_whatsapp'] as String?,
      status: json['status'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'cellPhone': cellPhone,
      'email': email,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'lema': lema,
      'department': department,
      'province': province,
      'district': district,
      'url_logo': urlLogo,
      'url_whatsapp': urlWhatsapp,
      'status': status,
    };
  }
}

class Person {
  final int id;
  final String name;
  final String lastName;
  final String? documentType;
  final String? documentNumber;
  final String? cellPhone;
  final String? email;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;

  Person({
    required this.id,
    required this.name,
    required this.lastName,
    this.documentType,
    this.documentNumber,
    this.cellPhone,
    this.email,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int,
    name: json['name'] as String,
    lastName: json['lastName'] as String,
    documentType: json['documentType'] as String?,
    documentNumber: json['document_number'] as String?,
    cellPhone: json['cellPhone'] as String?,
    email: json['email'] as String?,
    status: json['status'] as bool?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lastName': lastName,
    'documentType': documentType,
    'document_number': documentNumber,
    'cellPhone': cellPhone,
    'email': email,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

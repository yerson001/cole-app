class Person {
  final int id;
  final String name;
  final String lastname;
  final String? documentNumber;
  final String? phone;
  final String? email;

  Person({
    required this.id,
    required this.name,
    required this.lastname,
    this.documentNumber,
    this.phone,
    this.email,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int,
    name: json['name'] as String,
    lastname: json['lastname'] as String,
    documentNumber: json['document_number'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
  );
}

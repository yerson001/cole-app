import 'package:coleapp/features/auth/data/models/person.dart';

class User {
  final int id;
  final Person? person;

  User({required this.id, this.person});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] is int ? json["id"] : int.parse(json["id"].toString()),
    person: json["person"] != null ? Person.fromJson(json["person"]) : null,
  );
}

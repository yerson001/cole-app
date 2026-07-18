import 'package:coleapp/features/auth/data/models/person.dart';
import 'package:coleapp/features/auth/data/models/profile.dart';

class User {
  final int id;
  final String username;
  final Person? person;
  final List<String> roles;
  final Profile? profile;

  User({
    required this.id,
    required this.username,
    this.person,
    this.roles = const [],
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] is int ? json["id"] : int.parse(json["id"].toString()),
    username: json["username"] as String? ?? '',
    person: json["person"] != null ? Person.fromJson(json["person"]) : null,
    roles: json["roles"] != null
        ? List<String>.from(
            json["roles"].map((x) => x is String ? x : x["name"] ?? ''),
          )
        : [],
    profile: json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'person': person?.toJson(),
    'roles': roles,
    'profile': profile?.toJson(),
  };
}

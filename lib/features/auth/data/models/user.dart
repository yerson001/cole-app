import 'package:coleapp/features/auth/data/models/person.dart';
import 'package:coleapp/features/auth/data/models/profile.dart';
import 'package:coleapp/features/auth/data/models/role.dart';

class User {
  final int id;
  final String username;
  final Person? person;
  final List<Role> roles;
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
        ? List<Role>.from(
            json["roles"].map((x) =>
                x is String
                    ? Role(
                        id: x,
                        name: x,
                        image: '',
                        route: '$x/home',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      )
                    : Role.fromJson(x as Map<String, dynamic>)),
          )
        : [],
    profile: json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'person': person?.toJson(),
    'roles': roles.map((r) => r.toJson()).toList(),
    'profile': profile?.toJson(),
  };
}

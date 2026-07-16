class User {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String dni;
  final dynamic image;
  final dynamic notificationToken;
  final bool isActive;
  final List<String> roles;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.dni,
    this.image,
    this.notificationToken,
    this.isActive = true,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json["id"] : int.parse(json["id"].toString()),
        name: json["name"] ?? '',
        lastname: json["lastname"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        dni: json["dni"] ?? '',
        image: json["image"],
        notificationToken: json["notification_token"],
        isActive: json["is_active"] ?? true,
        roles: json["roles"] != null
            ? List<String>.from(json["roles"].map((x) => x is String ? x : x["name"] ?? ''))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "dni": dni,
        "image": image,
        "notification_token": notificationToken,
        "is_active": isActive,
        "roles": roles,
      };
}

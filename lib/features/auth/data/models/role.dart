class Role {
    String id;
    String name;
    String image;
    String route;
    DateTime createdAt;
    DateTime updatedAt;

    static const Map<String, String> _displayNames = {
      'PRINCIPAL': 'Director',
      'PROMOTER': 'Promotor',
      'SECRETARY': 'Secretaria',
      'ASSISTANT': 'Auxiliar',
      'TEACHER': 'Profesor',
      'PARENT': 'Padre',
    };

    String get displayName => _displayNames[name.toUpperCase()] ?? name;

    Role({
        required this.id,
        required this.name,
        required this.image,
        required this.route,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        route: json["route"] ?? '',
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "route": route,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

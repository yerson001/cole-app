class Profile {
  final String type;
  final int id;
  final String name;

  Profile({required this.type, required this.id, required this.name});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    type: json['type'] as String,
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

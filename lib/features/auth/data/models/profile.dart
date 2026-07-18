class Profile {
  final String type;
  final int id;

  Profile({required this.type, required this.id});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    type: json['type'] as String,
    id: json['id'] as int,
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
  };
}

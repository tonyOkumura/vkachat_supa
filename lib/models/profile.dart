class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
    this.description,
  });

  /// User ID of the profile
  final String id;

  /// Username of the profile
  final String username;

  /// Date and time when the profile was created
  final DateTime createdAt;

  /// Optional description of the profile
  final String? description;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        createdAt = DateTime.parse(map['created_at']),
        description = map['description'];
}

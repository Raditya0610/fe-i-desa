class User {
  final String username;
  final String villageId;

  User({
    required this.username,
    required this.villageId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      villageId: json['village_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'village_id': villageId,
    };
  }
}

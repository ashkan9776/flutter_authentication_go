class Profile {
  final String username;
  final String message;

  const Profile({
    required this.username,
    required this.message,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
    };
  }
}

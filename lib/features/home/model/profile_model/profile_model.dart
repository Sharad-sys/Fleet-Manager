class Profile {
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final bool isActive;

  Profile({
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.isActive,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class User {
  final String name;
  final String password;

  const User({required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      password: json['password'] as String,
    );
  }

}
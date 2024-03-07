class AppConfig {
  final String name;
  final String password;
  final String iOSAppId;

  const AppConfig({required this.name, required this.password, required this.iOSAppId});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      name: json['name'] as String,
      password: json['password'] as String,
      iOSAppId: json['iOSAppId'] as String,
    );
  }

}
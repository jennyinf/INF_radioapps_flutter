import 'package:radioapps/src/service/data/serializer.dart';

class AppConfigSerializer extends Serializer<AppConfig> {
  @override
  Map<String, dynamic> toJson(AppConfig data) {
    return data.toJson();
  }

  @override
  AppConfig fromJson(Map<String, dynamic> data) {
    return AppConfig.fromJson(data);
  }
}


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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'iOSAppId' : iOSAppId
    };
  }

  /// values used by the app secret to determine whether this is switched on or not
  bool get isSecretDebug => password == "debug";

  ///
  bool get isSecretOn => name.isNotEmpty;

}
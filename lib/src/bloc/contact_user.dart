
import 'package:radioapps/src/service/data/serializer.dart';

class ContactUserSerializer extends Serializer<ContactUser> {
  @override
  Map<String, dynamic> toJson(ContactUser data) {
    return data.toJson();
  }

  @override
  ContactUser fromJson(Map<String, dynamic> data) {
    return ContactUser.fromJson(data);
  }
}


/// the contact user
class ContactUser {
  final String name;
  final String nickname;
  final String phoneNumber;


  
  const ContactUser({this.name = "", this.nickname = "", this.phoneNumber = ""});

  factory ContactUser.fromJson(Map<String, dynamic> json) {
    return ContactUser(
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  /// is the app secret set
  bool get isAppSecret => name == 'infonote' && phoneNumber == '1nf0n0t3';


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
    };
  }

  bool get isEmpty => name.isEmpty && nickname.isEmpty; 

}

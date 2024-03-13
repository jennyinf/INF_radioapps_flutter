

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/result.dart';
import 'package:radioapps/src/service/user.dart';

class RadioService {

  AppConfig user = const AppConfig(name: "", password: "",iOSAppId:"");

  RadioService();
  
  Future<void> initialise() async {

    // load the user details first - we need these to talk to the service
    final value = await rootBundle.loadString("${F.appFlavor?.assetsFolder ?? "assets/default"}/user.json");
    final jsonResult = jsonDecode(value);
    user = AppConfig.fromJson(jsonResult);


  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return "";
  }

  Future<bool> request({required ContactUser user,
                  required String message, String artist = "", String song = ""}) async {

      final uri = Uri.parse("https://ids.infonote.com/RadioService/RadioService/Requests");

      final deviceInfo = await _getId();

      final parameters = <String,String>{
        "SentByUser" : user.name,
        "SentByNickname" : user.nickname,
        "SentByPhone" : user.phoneNumber,
        "Artist" : artist,
        "Track" : song,
        "Message" : message,
        "DeviceID" : deviceInfo ?? "",
        "DevicePlatform" : Platform.operatingSystem
      };

      final result = await _postResponse(uri, parameters: parameters);

      return result.succeeded;
  }

  Future<Map<String,String>> _authenticatedHeader( {forceRefresh = false, isForm = false}) async {


    // content type changes depending on whether this is a form or not
    final contentType = isForm ? 'application/x-www-form-urlencoded' : 'application/json; charset=UTF-8';

    
    final authorizationString = kDebugMode || true ? "TestStation:Jubil33HR" : "${user.name}:${user.password}";
    final u = utf8.encode(authorizationString);
    final b = base64.encode(u);
        
    return <String,String>{ 
       "Authorization" : "Basic $b",
       'Content-Type' : contentType,
       
      };


  }


  // use a post to fetch a response from the service and perform initial error checking on it
  Future<Result<String,Exception>> _postResponse(Uri uri, {Map<String,dynamic> parameters = const <String,String>{}}) async {

    return _sendResponse(makeResponse: (headers) => http.post(uri,
                                                              headers: headers,
                                                              body: jsonEncode(parameters)));


  }


  // use a post to fetch a response from the service and perform initial error checking on it
  Future<Result<String,Exception>> _sendResponse({required Future<http.Response> Function(Map<String, String>)  makeResponse }) async {
    final headers = await _authenticatedHeader(forceRefresh: false);

    final response = await makeResponse(headers);

    // final exception = _checkException(response);

    if(response.statusCode < 300) {
      return Success(response.body);
    } else  {
      // this is not something we can recover fron
      return Failure(Exception("Unable to send message"));
    }
    

  }
}

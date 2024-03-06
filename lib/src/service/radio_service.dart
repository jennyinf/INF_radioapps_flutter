

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/service/user.dart';

class RadioService {

  User user = User(name: "", password: "");

  RadioService();
  
  Future<void> initialise() async {

    // load the user details first - we need these to talk to the service
    final value = await rootBundle.loadString("${F.appFlavor?.assetsFolder ?? "assets/default"}/user.json");
    final jsonResult = jsonDecode(value);
    user = User.fromJson(jsonResult);


  }

}
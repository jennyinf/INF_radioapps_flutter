

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/service/user.dart';

class RadioService {

  User user = User(name: "", password: "");

  RadioService() {

    // load the user details first - we need these to talk to the service
    rootBundle.loadString("${F.appFlavor?.assetsFolder ?? "assets/default"}/user.json")
        .then((value) {
          final jsonResult = jsonDecode(value);
          user = User.fromJson(jsonResult);

          _loadStation();
        });

  }

  void _loadStation() {

    /// data is first loaded from saved preferences, then if not available, the local data file
    /// 
    /// once that is done the app will go to the repository to see if it has been updated - the result of that
    /// is saved back to local preferences

  }
}
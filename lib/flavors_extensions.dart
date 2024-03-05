

import 'package:flutter/material.dart';
import 'package:radioapps/flavors.dart';

/// Add flavor extensions here
/// we can assume that the flavors.dart code will be completely overwritten by
/// any rerun of flavorizr
extension FlavorExtensions on Flavor {

  // all assets folders are going to be imported here.  This may get unwieldy and I might need to extend 
  // flutter_flavorizr to cleanout unused assets
  String get assetsFolder => "assets/flavors/$name";

  Image logo({BoxFit fit = BoxFit.scaleDown}) => Image.asset("$assetsFolder/icon.png", fit: fit,);

  String get dataFile => "$assetsFolder/data.json";

}
import 'dart:convert';

import 'package:radioapps/src/service/data/serializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// save aserialisable object as a preference
/// 
/// 
class DataPreferences<T> {
  final String key;
  final Serializer<T> serializer;

  DataPreferences({required this.key, required this.serializer});

  Future<T?> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(key);
      if (data == null ) {
        return null; // No data or expiration time found.
      }

      // convert to json
      final json = jsonDecode(data);

      return serializer.fromJson(json);

     
    } catch (e) {
      return null;
    }

  }

  Future<bool> save( T value ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final json = serializer.toJson(value);

      prefs.setString(key, jsonEncode(json));

      return true;

     
    } catch (e) {
      return false;
    }


  }

  Future<bool> clear() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.remove(key);

      return true;

     
    } catch (e) {
      return false;
    }
  }

}
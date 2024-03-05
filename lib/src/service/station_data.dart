import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/src/service/data/data_preferences.dart';
import 'package:radioapps/src/service/radio_configuration.dart';
import 'package:rxdart/rxdart.dart';

/// manages the extraction of station configuration data
/// 

class StationData {
  /// the location of the asset file the data should be found in
  final String assetLocation;

  /// the location of the remote file
  final String remoteLocation;

  StationData({required this.assetLocation, required this.remoteLocation}) {
    _initialise();
  }

  final DataPreferences<RadioConfiguration> cachedPreferences = DataPreferences(key: "station", serializer: RadioConfigurationSerializer());

  /// the published stream
  final _dataSubject = BehaviorSubject<RadioConfiguration>();

  Stream<RadioConfiguration> get dataStream => _dataSubject.stream;

  Future<void> _initialise() async {
    /// check to see if a value has been saved
    RadioConfiguration? value = await cachedPreferences.load();
    

    if( value == null ) {
      /// load from the asset
      final data = await rootBundle.loadString(assetLocation);

      final jsonResult = jsonDecode(data);
      value = RadioConfiguration.fromJson(jsonResult);

    } 

    _dataSubject.value = value;

    /// TODO - fetch the remote value and save it
  }

}
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

    final remote = await _fetchRemote();
    if( remote != null ) {
      _dataSubject.value = remote;
    }

    // terminate the subject
    _dataSubject.done;
  }

  Future<RadioConfiguration ?> _fetchRemote() async {
    final uri = Uri.parse(remoteLocation);

    final response = await http.get(uri);

    if(response.body.isEmpty) { return null;}

    final jsonResult = jsonDecode(response.body);
    final value = RadioConfiguration.fromJson(jsonResult);

    return value;

  }

// // use a get to fetch a response from the service and perform initial error checking on it
//   Future<Result<String,AuthenticationException>> _getResponse(Uri uri) async {
//     final headers = await _authenticatedHeader(forceRefresh: false);
//     if(headers == null) {
//       return _expireFailure<String,AuthenticationException>(const AuthenticationExpiredException());
//     }
//     final response = await http.get(
//         uri,
//         headers: headers);

//     final exception = _checkException(response);

//     if(response.ok) {
//       return Success(response.body);
//     } else if(exception != null) {
//       // this is not something we can recover fron
//       return _expireFailure(exception.asAuthenticationException);
//     }else {
//       // dorce a refresh of the token
//       final newHeaders = await _authenticatedHeader(forceRefresh: true);

//       final newResponse = await http.get(
//         uri,
//         headers: newHeaders);

//       if(newResponse.ok) {
//         return Success(newResponse.body);
//       }
//       final exception = _checkException(newResponse);
//       if( exception != null ) {
//         return _expireFailure(exception.asAuthenticationException);
//       }


//     }
//     return _expireFailure<String,AuthenticationException>(const AuthenticationExpiredException());

//   }

//   AppException ?_checkException( Response response ) {

//     if( response.ok ) { return null ;}

//     return switch(response.statusCode) {
//       404 => const ServiceNotFoundAppException(),
//       500 => const ServiceFailedAppException(),
//       401 => null, // set when the session has expired and needs to be refreshed
//       _ => ServiceHttpErrorFailedAppException(response.statusCode) 
//     };

    
//   }
  
}
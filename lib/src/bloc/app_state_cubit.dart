import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/data/data_preferences.dart';
import 'package:radioapps/src/service/radio_service.dart';
import 'package:radioapps/src/service/station_data.dart';
import 'package:radioapps/src/service/user.dart';

class AppStateCubit extends Cubit<AppState> {


  DataPreferences<ContactUser> contactPreferences = DataPreferences(key: "contact", serializer: ContactUserSerializer());

  DataPreferences<AppConfig> secretPreferences = DataPreferences(key: "debug", serializer: AppConfigSerializer());

  final RadioService _service = RadioService();

  AppStateCubit({int index = -1, required AppState initialState}) 
                          : super(initialState);

    /// initialise the app with data pulled from the assets directory and user preferences
    void initialise() async {

      RadioService service = _service;
      await service.initialise();

      emit(state.copyWith(user: service.user));

      final contactUser = await contactPreferences.load();
      if( contactUser != null ) {
        emit(state.copyWith(deviceUser: contactUser));
      }

      final debugUser = await secretPreferences.load();
      emit(state.copyWith(debugUser : debugUser));

      final appinfo = await _initPackageInfo();
      final id = appinfo.packageName;
      emit(state.copyWith(appPackageId: id));

      final path = await _getImageFileFromAssets("${F.appFlavor!.assetsFolder}/logo.png", "logo.png");
      emit(state.copyWith(appLogo: path.uri));

      StationData stationData = StationData(assetLocation: state.assetLocation, 
                          remoteLocation: state.remoteLocation);

      // should I use listen here - this will never stop      
      await for(final data in stationData.dataStream) {
        emit(state.copyWith(radioConfiguration: data));
      }

    }

    void setShowedSponsor( bool value ) => emit(state.copyWith(sponsorViewed: value));

    void updateDebugUser( AppConfig config ) async {

      secretPreferences.save(config);
      emit(state.copyWith(debugUser: config));

      initialise();
    }

    Future<PackageInfo> _initPackageInfo() async {
      final PackageInfo info = await PackageInfo.fromPlatform();
      return info;
    }


    /// update the contact user
    void setContactUser( ContactUser contactUser) async {
      final v = await contactPreferences.save(contactUser);
      if( v ) {
        emit(state.copyWith(deviceUser: contactUser));
      }
    }

    void setStatus(RequestStatus status) => emit(state.copyWith(status: status));

    /// send a request to the station
    void sendRequest( {required String message, String artist = "", String song = ""}) async {
      
      setStatus(RequestStatus.processing);
      bool succeeded = await _service.request( user: state.deviceUser, message: message,
                    artist: artist, song:song);

      setStatus(succeeded ? RequestStatus.succeeded : RequestStatus.failed);      
    }

                          
}


  Future<File> _getImageFileFromAssets(String path, String name) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/$name";
    var file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      final byteData = await rootBundle.load(path);
      final buffer = byteData.buffer;
      /// TODO - resize this image
      await file.create(recursive: true);
      return file
          .writeAsBytes(buffer.asUint8List(byteData.offsetInBytes,
          byteData.lengthInBytes));
    }
  }

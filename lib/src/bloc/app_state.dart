

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/data/data_preferences.dart';
import 'package:radioapps/src/service/radio_configuration.dart';
import 'package:radioapps/src/service/radio_service.dart';
import 'package:radioapps/src/service/station_data.dart';
import 'package:radioapps/src/service/station_info.dart';
import 'package:radioapps/src/service/user.dart';
import 'package:radioapps/src/ui/pages/radioapp_page.dart';
/// the app state and the cubit to manage it
/// 
class AppState {

  final AppConfig user;
  final RadioConfiguration radioConfiguration;
  final String assetLocation;
  final bool debugMode;
  final ContactUser deviceUser;
  final String appPackageId;


  const AppState({
                this.radioConfiguration = const RadioConfiguration(), 
                this.user = const AppConfig(name: "", password: "",iOSAppId: ""), 
                required this.assetLocation, 
                this.debugMode = false,
                this.appPackageId = "",
                this.deviceUser = const ContactUser()  });

  String get remoteBaseLocation => debugMode ? "https://raw.githubusercontent.com/InfonoteDS/INF_data/master/radioapps/" :
                   "https://ids.infonote.com/RadioService/radioapps/";

  String get remoteLocation => "$remoteBaseLocation/${user.name}/data.json";

  int get selectedStream => 0; // todo - update the channel;

  StationInfo? get activeStream => radioConfiguration.streams.elementAtOrNull(selectedStream);
  String get streamUri => activeStream?.streamURL ?? "";
  String get streamTitle => activeStream?.stationName ?? "";

  bool get hasNewsFeed => activeStream?.facebookPage.isNotEmpty ?? false;

  // get the link for the app store - if appropriate
  String get appStoreLink {
    if( kIsWeb ) {
      return activeStream?.stationName ?? "";
    } else if (Platform.isAndroid) {
      return "market://details?id=$appPackageId";
    } else if (Platform.isIOS) {
      return "https://itunes.apple.com/us/app/apple-store/id${user.iOSAppId}?mt=8";
    } else if (Platform.isMacOS) {
      return "https://itunes.apple.com/us/app/apple-store/id${user.iOSAppId}?mt=8";
    }
    return activeStream?.stationName ?? "";;

  }

  AppState copyWith({
    AppConfig? user,
    RadioConfiguration? radioConfiguration,
    String? assetLocation,
    bool? debugMode,
    String? appPackageId,
    ContactUser ?deviceUser,
  }) {
    return AppState(
      user: user ?? this.user,
      radioConfiguration: radioConfiguration ?? this.radioConfiguration,
      assetLocation: assetLocation ?? this.assetLocation,
      debugMode: debugMode ?? this.debugMode,
      deviceUser: deviceUser ?? this.deviceUser,
      appPackageId: appPackageId ?? this.appPackageId
    );
  }

}

class AppStateCubit extends Cubit<AppState> {


  DataPreferences<ContactUser> contactPreferences = DataPreferences(key: "contact", serializer: ContactUserSerializer());

  AppStateCubit({int index = -1, required AppState initialState}) 
                          : super(initialState);

    /// initialise the app with data pulled from the assets directory and user preferences
    void initialise() async {

      RadioService service = RadioService();
      await service.initialise();

      emit(state.copyWith(user: service.user));

      final contactUser = await contactPreferences.load();
      if( contactUser != null ) {
        emit(state.copyWith(deviceUser: contactUser));
      }

      final appinfo = await _initPackageInfo();
      final id = appinfo.packageName;
      emit(state.copyWith(appPackageId: id));

      StationData stationData = StationData(assetLocation: state.assetLocation, 
                          remoteLocation: state.remoteLocation);

      // should I use listen here - this will never stop      
      await for(final data in stationData.dataStream) {
        emit(state.copyWith(radioConfiguration: data));
      }

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

                          
}
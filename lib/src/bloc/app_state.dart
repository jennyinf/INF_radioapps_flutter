

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/radio_configuration.dart';
import 'package:radioapps/src/service/station_info.dart';
import 'package:radioapps/src/service/user.dart';

enum RequestStatus {
  pending,succeeded,failed,processing;
}

/// the app state and the cubit to manage it
/// 
class AppState {

  final AppConfig user;
  final RadioConfiguration radioConfiguration;
  final String assetLocation;
  final bool debugMode;
  final ContactUser deviceUser;
  final String appPackageId;
  final Uri ?appLogo; // used to store a URI to the icon file to display in external media
  final AppConfig debugUser;
  final bool sponsorViewed;

  final RequestStatus status;


  const AppState({
                this.radioConfiguration = const RadioConfiguration(), 
                this.user = const AppConfig(name: "", password: "",iOSAppId: ""), 
                required this.assetLocation, 
                this.debugMode = false,
                this.appPackageId = "",
                this.status = RequestStatus.pending,
                this.appLogo,
                this.sponsorViewed = false,
                this.debugUser = const AppConfig(name: "", password: "", iOSAppId: ""),
                this.deviceUser = const ContactUser()  });

  String get remoteBaseLocation => debugMode || debugModeEnabled ? "https://raw.githubusercontent.com/InfonoteDS/INF_data/master/radioapps/" :
                   "https://ids.infonote.com/RadioService/radioapps/";

  String get remoteLocation {
    final u = isAppSecret && debugUser.name.isNotEmpty ? debugUser : user;

    return "$remoteBaseLocation/${u.name}/data.json";

  } 

  int get selectedStream => 0; // todo - update the channel;

  StationInfo? get activeStream => radioConfiguration.streams.elementAtOrNull(selectedStream);
  String get streamUri => activeStream?.streamURL ?? "";
  String get streamTitle => activeStream?.stationName ?? "";

  bool get hasNewsFeed => (activeStream?.hasNewsFeed ?? false);

  bool get isAppSecret => deviceUser.isAppSecret;

  bool get debugModeEnabled => isAppSecret && deviceUser.isAppSecret;

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
    return activeStream?.stationName ?? "";

  }

  AppState copyWith({
    AppConfig? user,
    RadioConfiguration? radioConfiguration,
    String? assetLocation,
    bool? debugMode,
    String? appPackageId,
    ContactUser ?deviceUser,
    RequestStatus ?status,
    AppConfig ?debugUser,
    bool ?sponsorViewed,
    Uri ?appLogo,
  }) {
    return AppState(
      user: user ?? this.user,
      radioConfiguration: radioConfiguration ?? this.radioConfiguration,
      assetLocation: assetLocation ?? this.assetLocation,
      debugMode: debugMode ?? this.debugMode,
      deviceUser: deviceUser ?? this.deviceUser,
      appPackageId: appPackageId ?? this.appPackageId,
      debugUser: debugUser ?? this.debugUser,
      sponsorViewed: sponsorViewed ?? this.sponsorViewed,
      status: status ?? this.status,
      appLogo : appLogo ?? this.appLogo
    );
  }

}

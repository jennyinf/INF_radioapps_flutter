

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/src/service/radio_configuration.dart';
import 'package:radioapps/src/service/radio_service.dart';
import 'package:radioapps/src/service/station_data.dart';
import 'package:radioapps/src/service/station_info.dart';
import 'package:radioapps/src/service/user.dart';

/// the app state and the cubit to manage it
/// 
class AppState {

  final User user;
  final RadioConfiguration radioConfiguration;
  final String assetLocation;
  final bool debugMode;

  const AppState({this.radioConfiguration = const RadioConfiguration(), 
                this.user = const User(name: "", password: ""), 
                required this.assetLocation, 
                this.debugMode = false});

  String get remoteBaseLocation => debugMode ? "https://raw.githubusercontent.com/InfonoteDS/INF_data/master/radioapps/" :
                   "https://ids.infonote.com/RadioService/radioapps/";

  String get remoteLocation => "$remoteBaseLocation/${user.name}/data.json";

  int get selectedStream => 0; // todo - update the channel;

  StationInfo get activeStream => radioConfiguration.streams[selectedStream];
  String get streamUri => radioConfiguration.streams.isEmpty ? "" : radioConfiguration.streams[selectedStream].streamURL;
  String get streamTitle => radioConfiguration.streams.isEmpty ? "" : radioConfiguration.streams[selectedStream].stationName;

  AppState copyWith({
    User? user,
    RadioConfiguration? radioConfiguration,
    String? assetLocation,
    bool? debugMode
  }) {
    return AppState(
      user: user ?? this.user,
      radioConfiguration: radioConfiguration ?? this.radioConfiguration,
      assetLocation: assetLocation ?? this.assetLocation,
      debugMode: debugMode ?? this.debugMode
    );
  }

}

class AppStateCubit extends Cubit<AppState> {

  AppStateCubit({int index = -1, required AppState initialState}) 
                          : super(initialState);

    void initialise() async {

      RadioService service = RadioService();
      await service.initialise();

      emit(state.copyWith(user: service.user));


      StationData stationData = StationData(assetLocation: state.assetLocation, 
                          remoteLocation: state.remoteLocation);

      // should I use listen here - this will never stop      
      await for(final data in stationData.dataStream) {
        emit(state.copyWith(radioConfiguration: data));
      }

    }
                          
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/service/radio_configuration.dart';
import 'package:radioapps/src/service/station_data.dart';
import 'package:radioapps/src/service/user.dart';

/// the app state and the cubit to manage it
/// 
class AppState {

  final User user;
  final RadioConfiguration radioConfiguration;
  final String assetLocation;

  const AppState({this.radioConfiguration = const RadioConfiguration(), 
                this.user = const User(name: "", password: ""), 
                required this.assetLocation});

  String get remoteLocation => "todo";

  int get selectedStream => 0; // todo - update the channel;

  String get streamUri => radioConfiguration.streams.isEmpty ? "" : radioConfiguration.streams[selectedStream].streamURL;

  AppState copyWith({
    User? user,
    RadioConfiguration? radioConfiguration,
    String? assetLocation,
  }) {
    return AppState(
      user: user ?? this.user,
      radioConfiguration: radioConfiguration ?? this.radioConfiguration,
      assetLocation: assetLocation ?? this.assetLocation,
    );
  }

}

class AppStateCubit extends Cubit<AppState> {

  late StationData stationData;

  AppStateCubit({int index = -1, required AppState initialState}) 
                          : super(initialState);

    void initialise() async {

      stationData = StationData(assetLocation: state.assetLocation, remoteLocation: state.remoteLocation);

      // should I use listen here - this will never stop      
      await for(final data in stationData.dataStream) {
        emit(state.copyWith(radioConfiguration: data));
      }

    }
                          
}
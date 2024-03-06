

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/data/data_preferences.dart';
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
  final ContactUser deviceUser;

  const AppState({this.radioConfiguration = const RadioConfiguration(), 
                this.user = const User(name: "", password: ""), 
                required this.assetLocation, 
                this.debugMode = false,
                this.deviceUser = const ContactUser()  });

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
    bool? debugMode,
    ContactUser ?deviceUser,
  }) {
    return AppState(
      user: user ?? this.user,
      radioConfiguration: radioConfiguration ?? this.radioConfiguration,
      assetLocation: assetLocation ?? this.assetLocation,
      debugMode: debugMode ?? this.debugMode,
      deviceUser: deviceUser ?? this.deviceUser
    );
  }

}

class AppStateCubit extends Cubit<AppState> {


  DataPreferences<ContactUser> contactPreferences = DataPreferences(key: "contact", serializer: ContactUserSerializer());

  AppStateCubit({int index = -1, required AppState initialState}) 
                          : super(initialState);

    void initialise() async {

      RadioService service = RadioService();
      await service.initialise();

      emit(state.copyWith(user: service.user));

      final contactUser = await contactPreferences.load();
      if( contactUser != null ) {
        emit(state.copyWith(deviceUser: contactUser));
      }

      StationData stationData = StationData(assetLocation: state.assetLocation, 
                          remoteLocation: state.remoteLocation);

      // should I use listen here - this will never stop      
      await for(final data in stationData.dataStream) {
        emit(state.copyWith(radioConfiguration: data));
      }

    }

    void setContactUser( ContactUser contactUser) async {
      final v = await contactPreferences.save(contactUser);
      if( v ) {
        emit(state.copyWith(deviceUser: contactUser));
      }
    }
                          
}
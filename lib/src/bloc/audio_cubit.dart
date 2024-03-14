import 'package:audio_session/audio_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioState {
  /// this is the currently set uri
  final String streamUri;
  final String title;

  AudioState({this.streamUri = "", this.title = ""});

  AudioState copyWith({
    String? streamUri,
    String? title,
  }) {
    return AudioState(
      streamUri: streamUri ?? this.streamUri,
      title: title ?? this.title,
    );
  }
}

class AudioCubit extends Cubit<AudioState> {
  late AudioPlayer _player;

  AudioPlayer get player => _player;

  AudioCubit({int index = -1, required AudioState initialState}) 
                          : super(initialState) {
    _player = AudioPlayer();
  }

  void initialise() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      // print('A stream error occurred: $e');
    });

  }

  void updateStream(String stream, String title, Uri ?logoPath) async {
    if( stream != state.streamUri ) {
      // update the stream
      emit(state.copyWith(streamUri: stream, title: title));

      if(stream.isEmpty) {
        // stop playing
      } else {
        final source = AudioSource.uri(Uri.parse(stream), 
          tag: MediaItem(
            id: '1', 
            title: title, 
            album: 'Playing your local Radio Station',
            artUri: logoPath));

        try {
          await _player.setAudioSource(source);
        } catch (e, stackTrace) {
          // Catch load errors: 404, invalid url ...
          print("Error loading source: $e");
          print(stackTrace);
        }
        

      }

    }
  }


}

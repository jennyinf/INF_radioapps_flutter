
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/ui/play/common.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  AudioPlayerViewState createState() => AudioPlayerViewState();
}

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
      print('A stream error occurred: $e');
    });

  }

  void updateStream(String stream, String title) async {
    if( stream != state.streamUri ) {
      // update the stream
      emit(state.copyWith(streamUri: stream, title: title));

      if(stream.isEmpty) {
        // stop playing
      } else {
        final source = AudioSource.uri(Uri.parse(stream), 
          tag: MediaItem(id: '1', title: title));

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

class AudioPlayerViewState extends State<AudioPlayerView> {
  // late AudioPlayer _player;

  // String _streamUri = "";

  // late UriAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    // _player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) { 

      final initialState = context.read<AppStateCubit>();
      _updateState(initialState.state);
    });
  }

  void _updateState( AppState state ) {
    final audioState = context.read<AudioCubit>();

    audioState.updateStream(state.streamUri, state.streamTitle);

  }




  @override
  Widget build(BuildContext context) {
    
  return BlocConsumer<AppStateCubit, AppState>(
    bloc: context.read<AppStateCubit>(),
    builder: (context, state) {
      return screen(context);
    },
    listener: (previous, current) async {
      _updateState(current);
    },
  );
  }

  Widget screen(BuildContext context) {

    final audioCubit = context.read<AudioCubit>();

    final player = audioCubit.player;

    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              ControlButtons(audioCubit.player),
              const SizedBox(height: 8.0),
              StreamBuilder(stream: player.icyMetadataStream, 
                builder: (context,snapshot) {
                    final metadata = snapshot.data;
                    final title = metadata?.info?.title ?? '';
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(title,
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ],
                    );

                    } )
            ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.stop, // using stop instead of pause - 
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              value: player.volume,
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

      ],
    );
  }
}

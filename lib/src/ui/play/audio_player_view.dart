
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/audio_cubit.dart';
import 'package:radioapps/src/ui/play/common.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  AudioPlayerViewState createState() => AudioPlayerViewState();
}

class AudioPlayerViewState extends State<AudioPlayerView> {
  @override
  void initState() {
    super.initState();

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

import 'package:flutter/material.dart';
import 'package:radioapps/src/ui/play/audio_player_view.dart';

class ListenPage extends StatelessWidget {
  const ListenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const AudioPlayerView()
,
    );
  }

}
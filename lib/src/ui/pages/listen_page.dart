import 'package:flutter/material.dart';
import 'package:radioapps/src/ui/pages/app_info_view.dart';
import 'package:radioapps/src/ui/play/audio_player_view.dart';

class ListenPage extends StatelessWidget {
  const ListenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          const AudioPlayerView(),
          const Spacer(),
          buttonRow(context)
        ]
      ),
    );
  }

  Widget buttonRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _showAppInfo(context),
          icon: Icon( Icons.info_outline, color: Theme.of(context).colorScheme.primary,),
        ),
        Expanded(child: _sponsorView(context)),
        IconButton(
          onPressed: () => _showShareSheet(context),
          icon: Icon( Icons.share, color: Theme.of(context).colorScheme.primary,),
        )
      ],
    );
  }

  Widget _sponsorView(BuildContext context) {
    // TODO
    return Text("Sponsor goes here", textAlign: TextAlign.center,);
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return Padding(
            padding:  MediaQuery.of(context).viewInsets,
            child: AppInfoView(),
          );
        });

  }


  void _showAppInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        useRootNavigator: true,
        builder: (context) {
          return Padding(
            padding:  MediaQuery.of(context).viewInsets,
            child: const AppInfoView(),
          );
        });

  }

  

}


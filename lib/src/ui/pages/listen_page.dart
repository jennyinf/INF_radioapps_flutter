import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/ui/pages/app_info_view.dart';
import 'package:radioapps/src/ui/play/audio_player_view.dart';
import 'package:share_plus/share_plus.dart';

class ListenPage extends StatefulWidget {
  const ListenPage({super.key});

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
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
    final state = context.read<AppStateCubit>().state;

    if(state.radioConfiguration.sponsor != null) {
      /// TODO: sponsored by and button
      return Text(state.radioConfiguration.sponsor!.name, textAlign: TextAlign.center,);

    }
    return const Text("");
  }

  void _showShareSheet(BuildContext context) async {

    final state = context.read<AppStateCubit>().state;
    
    final appStoreLink = state.appStoreLink;

    final subject = "I'm listening to ${state.streamTitle} via their app!";

    await Share.share("$subject\n$appStoreLink", subject: subject, );
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


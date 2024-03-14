import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state_cubit.dart';
import 'package:radioapps/src/service/sponsor.dart';
import 'package:radioapps/src/ui/components/widget_extensions.dart';
import 'package:radioapps/src/ui/pages/app_info_view.dart';
import 'package:radioapps/src/ui/pages/sponsor_view.dart';
import 'package:radioapps/src/ui/play/audio_player_view.dart';
import 'package:share_plus/share_plus.dart';

class ListenPage extends StatefulWidget {
  const ListenPage({super.key});

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {

  Sponsor ? _sponsor;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) { 

      /// delay slightly to ensure the sponsor is pulled down from the service if present
      Future.delayed(const Duration(milliseconds: 500))
        .then((value) {
          final cubit = context.read<AppStateCubit>();

          final state = cubit.state;
          setState(() {
            _sponsor = state.radioConfiguration.sponsor;
          },);

          if( _sponsor != null && !state.sponsorViewed) {
            _showSponsor(context, _sponsor!, duration: const Duration(seconds: 5));
            cubit.setShowedSponsor(true);

          }

        });
      
    });
  }

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

    if(_sponsor != null) {
      return InkWell(
        onTap: () => _showSponsor(context,_sponsor! ),
        child: Column(
          children: [
            Text(localisations.listen_sponsored_by, 
                 style: Theme.of(context).textTheme.labelMedium,
                 textAlign: TextAlign.center,),
            Text(_sponsor!.name, 
                 style: Theme.of(context).textTheme.bodyMedium,
                 textScaler: const TextScaler.linear(1),
                 textAlign: TextAlign.center,),
          ],
        ),
      );

    }
    return const Text("");
  }

  void _showSponsor(BuildContext context, Sponsor sponsor, {Duration ?duration}) {

    showSponsorDialog(context, sponsor, duration);
    // final dialog = Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here

    //   child: Container(
    //       width: 350,
    //       height: 350,
    //       child: SponsorView(sponsor: sponsor)),);

    // showDialog(context: context, builder: (context) => dialog);

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


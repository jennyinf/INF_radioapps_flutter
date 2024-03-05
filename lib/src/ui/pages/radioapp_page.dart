
import 'package:flutter/material.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/ui/components/page_header_view.dart';
import 'package:radioapps/src/ui/extensions/color_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:radioapps/src/ui/play/audio_player_view.dart';
import 'package:radioapps/src/ui/style/app_theme.dart';


extension AppStateTheme on AppState {
  ThemeData themeData( BuildContext context ) {
    // get the primary and background colors
    Color primary = HexColor.fromHex(radioConfiguration.barColor ?? "#556270");
    Color background = HexColor.fromHex(radioConfiguration.backgroundColor ?? "#ffffff");

    // final theme = Theme.of(context);


    return AppTheme.fromCustomColorScheme(SeedColorScheme.fromSeeds(primaryKey: primary, primaryContainer: background));

  }
}
/// all radioapp pages have the same layout
/// Various parts of the layout may change size depending on the screen in question


class RadioAppPage extends StatefulWidget {
  const RadioAppPage({super.key});

  @override
  State<RadioAppPage> createState() => _RadioAppPageState();
}

class _RadioAppPageState extends State<RadioAppPage> {

  // the logo size will depend on the currently selected page
  double get logoHeight => 250;

  @override
  Widget build(BuildContext context) {

    final appstate = context.watch<AppStateCubit>();

    final themeData = appstate.state.themeData(context);

    return Theme(
      data : themeData,
      child: Scaffold(
        bottomNavigationBar: 
            CustomTabBar(
                options: [TabOption(title: "Listen", iconData: Icons.audiotrack)],),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderView(logoHeight: logoHeight),
              const AudioPlayerView()
            ]),
        ),
      ),
    );
  }

}

class TabOption {
  final String title;
  final IconData iconData;

  const TabOption({required this.title, required this.iconData});

  
}
class CustomTabBar extends StatelessWidget {

  final List<TabOption> options;

  const CustomTabBar({super.key, required this.options});

  // Widget _option(int index) {
  //   index >= options.length ? Spacer() : 
  // }


  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container( 
        height: 60, 
        decoration: BoxDecoration( 
          color: themeData.primaryColor, 
          borderRadius: const BorderRadius.only( 
            topLeft: Radius.circular(20), 
            topRight: Radius.circular(20), 
          ), 
        ), 
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            // _option(1),
            // _option(2),
            // _centralOption,
            // _option(3),
            // _option(4),

          ], 
        ));
  }

}

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/app_state_cubit.dart';
import 'package:radioapps/src/bloc/page_state.dart';
import 'package:radioapps/src/ui/components/custom_tab_bar.dart';
import 'package:radioapps/src/ui/components/page_header_view.dart';
import 'package:radioapps/src/ui/extensions/color_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:radioapps/src/ui/pages/contact_page.dart';
import 'package:radioapps/src/ui/pages/listen_page.dart';
import 'package:radioapps/src/ui/pages/news_page.dart';
import 'package:radioapps/src/ui/pages/settings_page.dart';
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

/*
*/
enum AppPage implements TabOption {
  listen(iconData: Icons.audiotrack,widget: ListenPage()),
  contact(iconData: Icons.email_rounded, logoHeight: 100),
  settings(iconData: Icons.settings, logoHeight: 100),
  news(iconData: Icons.newspaper, logoHeight: 100);

  const AppPage({
    required this.iconData,
    this.logoHeight = 250,
    this.widget
  });

  @override
  final IconData iconData;
  final double logoHeight;
  final Widget ?widget;

  Widget get page => switch(this) {
    listen => const ListenPage(),
    contact => const ContactPage(),
    settings => const SettingsPage(),
    news => const NewsPage()
  };

 @override
 String title( BuildContext context) => switch(this) {
    listen => AppLocalizations.of(context)!.tab_listen,
    contact => AppLocalizations.of(context)!.tab_contact,
    settings => AppLocalizations.of(context)!.tab_settings,
    news =>AppLocalizations.of(context)!.tab_news

 };


}

class _RadioAppPageState extends State<RadioAppPage> {

  // the logo size will depend on the currently selected page
  double get logoHeight => 250;

  // create the cubit to monitor the tab bar
  final PageStateCubit<AppPage> _pageStateCubit = PageStateCubit(initialState: PageState(page: AppPage.listen));

  @override
  Widget build(BuildContext context) {

    final appstate = context.watch<AppStateCubit>();


    final themeData = appstate.state.themeData(context);

    return BlocProvider(
      create: (context) => _pageStateCubit,
      child:   Builder(
        builder: (context) {
          final pagestate = context.watch<PageStateCubit<AppPage>>();

          return Theme(
              data : themeData,
              child: Scaffold(
                bottomNavigationBar: 
                    CustomTabBar(
                        options: _tabOptions(appstate.state),
                        ),
                body: SafeArea(
                  child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
            
                      PageHeaderView(logoHeight: pagestate.state.page.logoHeight),
                      pagestate.state.page.page
                    ])
                ),
              ),
            );
        }
      )
    );
  }

  List<AppPage> _tabOptions( AppState state ) {
    return [
      AppPage.listen, 
      AppPage.contact, 
      AppPage.settings, 
      if(state.hasNewsFeed) AppPage.news
      // TabOption(title: "News", iconData: Icons.newspaper),
          
    ];
  }
}



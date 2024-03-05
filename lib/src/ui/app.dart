import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/ui/pages/radioapp_page.dart';
import 'package:radioapps/src/ui/style/app_theme.dart';

import '../sample_feature/sample_item_details_view.dart';
import '../sample_feature/sample_item_list_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AppStateProvider(
      child: MaterialApp(
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'app',
      
        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
      
        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
      
        // Define a light and dark color theme. Then, read the user's
        // preferred ThemeMode (light, dark, or system default) from the
        // SettingsController to display the correct theme.
        theme: AppTheme.haunted.themeData,
        darkTheme: AppTheme.haunted.darkThemeData,
        themeMode: ThemeMode.light,
      
        // Define a function to handle named routes in order to support
        // Flutter web url navigation and deep linking.
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case SampleItemDetailsView.routeName:
                  return const SampleItemDetailsView();
                case SampleItemListView.routeName:
                default:
                  return const RadioAppPage();
              }
            },
          );
        },
      ),
    );
  }
}

class AppStateProvider extends StatefulWidget {
  const AppStateProvider({super.key, required this.child});
  final Widget child;

  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider> {

  late AppStateCubit stateCubit;

@override
void initState() {
  super.initState();

  // call this after the app has laid out
  WidgetsBinding.instance.addPostFrameCallback((_) { 

    AppState initialState = AppState(assetLocation: F.appFlavor?.dataFile ?? "");
    stateCubit = AppStateCubit(initialState: initialState);
    stateCubit.initialise();

  });
}

  /// add all the cubits needed by the app.
  /// when a view is initialised that needs a cubit it should make sure it is updated.
  /// TODO: I dont know if this is the correct way to implement this.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => stateCubit,
        ),
      ],
      child: widget.child,
    );
  }
}

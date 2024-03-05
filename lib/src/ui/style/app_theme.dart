

import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// this will be updated by the app when the theme or company default colour is changed
Color _appSeedColor = const Color(0xff556270);

// TODO: This would (could) be part of a companies setup.  Id so the company would be wrapped up in a value notifier and
// provide the seed colour to the app.
ValueNotifier<Color> appSeedColor = ValueNotifier(_appSeedColor);

enum AppTheme {
  pink, 
  sunrise,
  mightySlate,
  haunted,
  custom;

  Color get seedColor => switch(this) {
    pink => Colors.pinkAccent,
    haunted => const Color(0xff025D8C),
    sunrise => const Color(0xffe3a750),
    mightySlate => const Color(0xff556270),
    custom => appSeedColor.value

  };
  

  static ThemeData fromCustomColorScheme( ColorScheme colorScheme ) {
    final t = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true
    );

    return haunted._applyStyles(t);

  }

  ThemeData get themeData {
    final t = ThemeData(
      colorScheme: SeedColorScheme.fromSeeds(primaryKey: seedColor),
      useMaterial3: true
    );
    return _applyStyles(t);
  }

  ThemeData _applyStyles( ThemeData data ) {
    final c = data.colorScheme;
    final t1 = data.copyWith(textTheme: GoogleFonts.latoTextTheme(data.textTheme).copyWith(
       labelSmall: GoogleFonts.lato(textStyle: data.textTheme.labelSmall, color: c.primary),
       labelMedium: GoogleFonts.lato(textStyle: data.textTheme.labelMedium, color: c.primary),
       labelLarge: GoogleFonts.lato(textStyle: data.textTheme.labelLarge, color: c.primary)),
       );
       
    final appBarTheme = t1.appBarTheme.copyWith(
              backgroundColor: t1.colorScheme.primary,
              foregroundColor: t1.colorScheme.onPrimary,
              centerTitle: true, 
              toolbarTextStyle: GoogleFonts.aDLaMDisplay(textStyle: t1.textTheme.headlineMedium!, color: t1.colorScheme.onPrimary),
              titleTextStyle: GoogleFonts.aDLaMDisplay(textStyle: t1.textTheme.headlineMedium!, color: t1.colorScheme.onPrimary));

    final tabBarTheme = t1.tabBarTheme.copyWith(
              indicatorColor: t1.colorScheme.onPrimary,
              labelColor: t1.colorScheme.onPrimary,
              unselectedLabelColor: t1.colorScheme.onPrimary.withAlpha(128));

    return t1.copyWith(appBarTheme: appBarTheme, tabBarTheme: tabBarTheme);


  }

  ThemeData get darkThemeData {
    final lightData = themeData;
    final t = ThemeData(
      colorScheme: SeedColorScheme.fromSeeds(primaryKey: seedColor,       
                brightness: Brightness.dark,
                primary: lightData.colorScheme.primary, onPrimary: lightData.colorScheme.onPrimary, 
                onPrimaryContainer: lightData.colorScheme.onPrimaryContainer),      
      useMaterial3: true
    ); 
    return _applyStyles(t);

  }

}
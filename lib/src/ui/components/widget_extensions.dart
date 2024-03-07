

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


extension Localisations<T extends StatefulWidget> on State<T> {
    AppLocalizations get localisations => AppLocalizations.of(context)!;
}


extension StatelessLocalisations on StatelessWidget {
    AppLocalizations localisations(context) => AppLocalizations.of(context)!;
}



extension NavigatorStateExtensions on NavigatorState {

    /// pop until the top route is reached - if this is the destination route return true
    bool popUntilFirst( String destinationRoute) {

    bool isAlreadyFirst = false;

    popUntil((route) {
      final isFirst = route.isFirst;

      if( isFirst && route.toString() == destinationRoute) {
        isAlreadyFirst = true;
      }
      return isFirst;
    });
    return isAlreadyFirst;

  }

}
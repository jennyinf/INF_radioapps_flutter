
import 'package:flutter/material.dart';
import 'package:radioapps/src/ui/components/message_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ContactType {
  phoneNumber, mobileNumber, email, website;

  Icon icon( BuildContext context )  {
    var theme = Theme.of(context);
      switch(this) {
        case ContactType.email:
          return Icon(Icons.email, color:theme.colorScheme.primary,);
        case ContactType.phoneNumber:
          return Icon(Icons.phone, color:theme.colorScheme.primary);
        case ContactType.mobileNumber:
          return Icon(Icons.phone, color:theme.colorScheme.primary);
        case ContactType.website:
          return Icon(Icons.web, color:theme.colorScheme.primary);
      }
  }

  String get title {
    switch(this) {
      case ContactType.email:
        return 'Email';
      case ContactType.phoneNumber:
        return 'Phone Number';
      case ContactType.mobileNumber:
        return 'Mobile Number';
      case ContactType.website:
        return 'Website';
    }

  }

  open( BuildContext context, String value ) async {
    try {
      switch(this) {
        case ContactType.email: {
                  // mailto:<email address>?subject=<subject>&body=<body>
          var v = "mailto:$value";
            var uri = Uri.parse(v);
            if( !await launchUrl(uri) ) {
              throw Exception('Unable to email from this device');
            }

        }
        
        break;
        case ContactType.phoneNumber: {
          // mailto:<email address>?subject=<subject>&body=<body>
          var v = "tel:+$value";
            var uri = Uri.parse(v);
            if( !await launchUrl(uri) ) {
              throw Exception('Unable to call from this device');
            }

        }
          break;
        case ContactType.mobileNumber: {
          // mailto:<email address>?subject=<subject>&body=<body>
          var v = "tel:+$value";
            var uri = Uri.parse(v);
            if( !await launchUrl(uri) ) {
              throw Exception('Unable to call from this device');
            }

        }
          break;
        case ContactType.website: {
            var uri = Uri.parse(value);
            if( !await launchUrl(uri) ) {
              throw Exception('Unable to open website on this device');
            }
        }
      }

    } catch (e) {
        if(context.mounted) {
          MessageDisplay.showErrorInSnackBar(context, failedMessage(context));
        }

    }

  }

  String failedMessage(BuildContext context) => switch(this) {
    website => AppLocalizations.of(context)!.contact_website_failed,
    email => AppLocalizations.of(context)!.contact_email_failed,
    phoneNumber => AppLocalizations.of(context)!.contact_phone_failed,
    mobileNumber => AppLocalizations.of(context)!.contact_phone_failed,
  };

}

class ContactButton extends StatelessWidget {
  const ContactButton({
    super.key,
    required this.value,
    required this.type,
    this.title, this.child
  });

  final String? title;
  final String value;
  final ContactType type;
  // set this for a custom contact button
  final Widget ?child;

  @override Widget build( BuildContext context ) {

    if( child != null ) {
      return InkWell(
          onTap:() { type.open(context,value); },
        child: child!,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap:() { type.open(context,value); },
          child: Row( children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? type.title, style: Theme.of(context).textTheme.labelMedium),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
              
            ),
            const Spacer(),
            type.icon(context)
          ])
        ),
    );
  }
}
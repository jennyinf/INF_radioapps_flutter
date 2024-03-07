
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends CubitState<SettingsPage,AppStateCubit> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _nickNameController = TextEditingController(text: "");
  final TextEditingController _phoneNumberController = TextEditingController(text: "");

  void _save() {
    final appstate = context.read<AppStateCubit>();

    appstate.setContactUser(ContactUser(name: _nameController.text,
                              nickname: _nickNameController.text,
                              phoneNumber: _phoneNumberController.text));
  }
  @override void setCubit( AppStateCubit cubit) {
    final user = cubit.state.deviceUser;

    _nameController.text = user.name;
    _nickNameController.text = user.nickname;
    _phoneNumberController.text = user.phoneNumber;

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("yay")));

  }

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child:  Column(
          children: [
            SectionHeader(title: localizations.settings_contact_section),
            _privacyRow(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: localizations.settings_name_field,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _nickNameController,
                decoration: InputDecoration(
                    labelText: localizations.settings_nickname_field,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                    labelText: localizations.settings_phone_field,
                ),
              ),
            ),
            ElevatedButton(onPressed: _save, child: Text(localizations.save)),
      
            // InkWell(
            //   onTap: _toggleViewPrivacy,
            //   child: SectionHeader(title: localizations.settings_privacy,
            //               trailing: Icon( Icons.info, color: Theme.of(context).colorScheme.onSecondary,) ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: _viewPrivacyStatement ? Text(localizations.settings_privacy_statement) : const Text(""),
            // ),
      
          ],
        ),
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(context: context, 
              builder: (context) => AlertDialog(
          title:  Text(localizations.settings_privacy),
          content:  Text(localizations.settings_privacy_statement),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(localizations.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
    ));
  }

  Widget _privacyRow(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
        onTap: () => _showPrivacy(context),
        child: Row(
          children: [
            Text(AppLocalizations.of(context)!.settings_privacy, style: Theme.of(context).textTheme.labelLarge,),
            const Spacer(),
            Icon( Icons.info, color: Theme.of(context).colorScheme.primary,)
          ],)
    ),
  );

}
  
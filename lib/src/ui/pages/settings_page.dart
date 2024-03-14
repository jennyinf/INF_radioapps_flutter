
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/app_state_cubit.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/service/user.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:radioapps/src/ui/components/wide_elevated_button.dart';

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

  bool _debugModeEnabled = false;
  final TextEditingController _stationUserController = TextEditingController(text: "");

  void _save() {
    final appstate = context.read<AppStateCubit>();

    appstate.setContactUser(ContactUser(name: _nameController.text,
                              nickname: _nickNameController.text,
                              phoneNumber: _phoneNumberController.text));
  }

  void _update() {
    final debugUser = AppConfig(name: _stationUserController.text.trim(), password: _debugModeEnabled ? "debug" : "", iOSAppId: "");

    final appstate = context.read<AppStateCubit>();
    appstate.updateDebugUser(debugUser);
  }
  @override void setCubit( AppStateCubit cubit) {
    final user = cubit.state.deviceUser;

    _nameController.text = user.name;
    _nickNameController.text = user.nickname;
    _phoneNumberController.text = user.phoneNumber;
    _stationUserController.text = cubit.state.debugUser.name;

    _debugModeEnabled = cubit.state.debugModeEnabled;

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("yay")));

  }

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    final appstate = context.watch<AppStateCubit>();

    return Expanded(
      child: SingleChildScrollView(
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
              WideElevatedButton(onTap: _save, 
                          title: localizations.save,
                          padding: 8.0,),
              if( appstate.state.isAppSecret ) _appSecretSection(),        
            ],
          ),
        ),
      ),
    );
  }

  /// no localisation here - this is private to us
  Widget _appSecretSection() {
    return Column(
      children: [
        const SectionHeader(title: "Station"),
        Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(
              "This will update the station the app connects to, so that data updates can be tested.  If you set debug on, data will be retrieved from the interim debug service.  The app icon and name will remain untouched, and do not send via the contact form as it will fail.",
              style: Theme.of(context).textTheme.labelSmall,),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
              const Text("Use debug data"),
              const Spacer(),
                Switch(value: _debugModeEnabled, onChanged: (value) {
                  setState(() {
                    _debugModeEnabled = value;
                  });
                
                }),
             ],
           ),
         ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _stationUserController,
              decoration: const InputDecoration(
                  labelText: "Station User Name",
              ),
            ),
          ),
          WideElevatedButton(onTap: _update, 
                    title: "Update App",
                    padding: 8.0,),

      ],
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
  
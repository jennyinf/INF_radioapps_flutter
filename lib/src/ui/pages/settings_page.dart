
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/contact_user.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _nickNameController = TextEditingController(text: "");
  final TextEditingController _phoneNumberController = TextEditingController(text: "");

  bool _viewPrivacyStatement = false;

  _toggleViewPrivacy() {
    setState(() {
      _viewPrivacyStatement = !_viewPrivacyStatement;
    });
  }

  void _save() {
    final appstate = context.read<AppStateCubit>();

    appstate.setContactUser(ContactUser(name: _nameController.text,
                              nickname: _nickNameController.text,
                              phoneNumber: _phoneNumberController.text));
  }
  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) { 
      final appstate = context.read<AppStateCubit>();

      final user = appstate.state.deviceUser;

      _nameController.text = user.name;
      _nickNameController.text = user.nickname;
      _phoneNumberController.text = user.phoneNumber;

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("yay")));
    });

  }

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child:  Column(
        children: [
          SectionHeader(title: localizations.settings_contact_section),
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

          InkWell(
            onTap: _toggleViewPrivacy,
            child: SectionHeader(title: localizations.settings_privacy,
                        trailing: Icon( Icons.info, color: Theme.of(context).colorScheme.onSecondary,) ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _viewPrivacyStatement ? Text(localizations.settings_privacy_statement) : const Text(""),
          ),

        ],
      ),
    );
  }
}
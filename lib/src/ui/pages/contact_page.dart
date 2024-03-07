

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/page_state.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:radioapps/src/ui/components/widget_extensions.dart';
import 'package:radioapps/src/ui/pages/radioapp_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends CubitState<ContactPage,AppStateCubit> {

  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _hasContactInfo = false;

  final TextEditingController _message = TextEditingController();
  final TextEditingController _artist = TextEditingController();
  final TextEditingController _title = TextEditingController();

  bool _sendSongRequest = false;

  @override
  void setCubit( AppStateCubit cubit ) {
    setState(() {
          _hasContactInfo = !cubit.state.deviceUser.isEmpty;

    });
  }

  @override
  Widget build(BuildContext context) {
    return _hasContactInfo ? mainView(context) : editSettingsView(context);
  }

  Widget editSettingsView(BuildContext context) {

    final cubit = context.read<PageStateCubit<AppPage>>();

    return Expanded(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(localisations.request_setup_needed),
            ),
            ElevatedButton(
                onPressed: () => cubit.setPage(AppPage.settings),
                child: Text(localisations.tab_settings),
            ),
          ],
        ),
      ),
    );
    
  }
  Widget mainView(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _message,
                decoration: InputDecoration(
                    labelText: localisations.request_message_row,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(localisations.request_add_song),
                  const Spacer(),
                  Switch(value: _sendSongRequest, onChanged: (value) {
                    setState(() {
                    _sendSongRequest = value;
                   });
                  })
                ],
              ),
            ),
            if(_sendSongRequest) _songRequestView(context)



        ]
      )
    );
  }

  Widget _songRequestView(BuildContext context) {
    return Column(
      children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _artist,
                decoration: InputDecoration(
                    labelText: localisations.request_artist_row,
                ),
              ),
            ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: _title,
                decoration: InputDecoration(
                    labelText: localisations.request_song_row,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: _addSongFromLibrary, 
                child: SizedBox( width: double.infinity, 
                    child: Text(localisations.request_select_song_row, textAlign: TextAlign.center,))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: _addSongFromLibrary, 
                style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold)),
                child: SizedBox( width: double.infinity, 
                    child: Text(localisations.save, textAlign: TextAlign.center,))),
          )

      ],


    );
    
  }

  void _addSongFromLibrary() {

  }
}
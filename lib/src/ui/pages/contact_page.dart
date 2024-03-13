

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/bloc/page_state.dart';
import 'package:radioapps/src/ui/components/audio_library/audio_query_view.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:radioapps/src/ui/components/wide_elevated_button.dart';
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

  bool get _canSend => _message.text.isNotEmpty;

  bool _tappedSend = false;
  RequestStatus _requestStatus = RequestStatus.pending;

  void _send() {
    final cubit = context.read<AppStateCubit>();

    setState(() {
      _tappedSend = true;
    });
    cubit.sendRequest(message: _message.text.trim(),
                      artist: _artist.text.trim(),
                      song: _title.text.trim());

  }

  void _updateState(AppState state) {
    // only relevant if we tapped send
    if( _tappedSend ) {
      var status = state.status;

      if( status == RequestStatus.succeeded || status == RequestStatus.failed ) {
        status = RequestStatus.pending;
        /// clear down the message - we are done
        _message.text = "";
        _artist.text = "";
        _title.text = "";
        _tappedSend = false;
      }
      setState(() {
        _requestStatus = status;
      });
    }

  }
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


    return BlocListener<AppStateCubit,AppState>(
      bloc: context.read<AppStateCubit>(),
      listener: (context, state) => _updateState(state),
      child: Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _message,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      minLines: 3,
                      onChanged: (_) => setState(() {
                        // state will be recalculated
                      }),
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
                  if(_sendSongRequest) _songRequestView(context),
          
                  if(_canSend && !_tappedSend) WideElevatedButton(padding: 8.0, 
                        usePrimary: true,
                        onTap: _send, 
                        title: localisations.send)
      
          
              ]
            )
          ),
        ),
      ),
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
    
          WideElevatedButton(padding: 8.0, 
                      onTap: () => _addSongFromLibrary(context), 
                      title: localisations.request_select_song_row),
    
      ],
    
    
    );
    
  }

  void _addSongFromLibrary(BuildContext context) async {
    final value = await showModalBottomSheet<SongModel>(
        context: context,
        isScrollControlled: false,
        useRootNavigator: true,
        builder: (context) {
          return Padding(
            padding:  MediaQuery.of(context).viewInsets,
            child: const AudioQueryView(),
          );
        });

    if( value != null ) {
      _artist.text = value.artist ?? "";
      _title.text = value.title;

    }
  }
}


import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radioapps/src/bloc/app_state_cubit.dart';
import 'package:radioapps/src/ui/components/contact_button.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:radioapps/src/ui/components/widget_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppInfoView extends StatefulWidget {
  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends CubitState<AppInfoView,AppStateCubit> {

  String _contactNumber = "";
  String _donationsURL = "";
  String _stationName = "";
  late WebViewController _controller;
  String _statementHTML = "";
  String ?_about;

/*
        if let textPath = Bundle.main.url(forResource: "statement", withExtension: "html"),
              let text = try? String(contentsOf: textPath),
              let stationName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            
            content = text.replacingOccurrences(of: "[StationName]", with: stationName)
            
            let statement = model.about ?? defaultStatement
            
            content = content.replacingOccurrences(of: "[Statement]", with: statement)
            
*/
  String get _content {
    if( !context.mounted ) return "";
    final aboutStatement = localisations.about_statement;

    final statement = _about ?? aboutStatement;

    final v = _statementHTML.replaceAll("[StationName]", _stationName)
                      .replaceAll("[Statement]", statement);

    return v;
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString("assets/data/statement.html")
        .then((value) {
          setState(() {
            _statementHTML = value;
            final content = _content;
            if(content.isNotEmpty) {

              _controller.loadHtmlString(_content, baseUrl: "https://www.infonote.com");

            }
          });
        });


    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if( request.url.startsWith("https://www.infonote.com/") ) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );
      // ..loadRequest(Uri.parse("https://www.infonote.com"));


    _controller = controller;

  }
  @override
  void setCubit( AppStateCubit cubit) {
    final state = cubit.state;

    setState(() {
      _contactNumber = state.radioConfiguration.stationNumber;
      _donationsURL = state.radioConfiguration.donationsURL ?? "";
      _stationName = state.activeStream?.stationName ?? "";
      _about = state.radioConfiguration.about;
      final content = _content;
      if(content.isNotEmpty) {
        _controller.loadHtmlString(_content, baseUrl: "https://www.infonote.com");

      }
      // _controller.loadRequest(Uri.parse("https://www.infonote.com"));
    });
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
      final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  }; 

    return Scaffold(
      body: Column(
        children: [
          SectionHeader(title: localisations.about,
                color: Theme.of(context).colorScheme.primary,
                titleStyle: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary,),
                trailing: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon( Icons.close, color: theme.colorScheme.onPrimary,),
      
                  ),),
          if(_contactNumber.isNotEmpty) ContactButton(value: _contactNumber, type: ContactType.phoneNumber, title: localisations.about_call,),
          if(_donationsURL.isNotEmpty) ContactButton(value: _donationsURL, type: ContactType.website, title: localisations.about_donation,),
          Expanded(child: WebViewWidget(
              gestureRecognizers: gestureRecognizers,
              controller: _controller))
        ],
      ),
    );
  }
}
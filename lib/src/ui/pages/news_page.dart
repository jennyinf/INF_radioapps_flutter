
import 'package:flutter/material.dart';
import 'package:radioapps/src/bloc/app_state.dart';
import 'package:radioapps/src/ui/components/cubit_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends CubitState<NewsPage,AppStateCubit> {

  late final WebViewController _controller;

  @override
  void setCubit(AppStateCubit cubit) {

    final state = cubit.state;

    const webContent = """
                  <head>
                  <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                  </head>
                  <div id="fb-root"></div>
                  <script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_GB/sdk.js#xfbml=1&version=v17.0" nonce="mE152UVT"></script>
                  <div class="fb-page" data-href="https://www.facebook.com/[***]" data-tabs="timeline" data-width="" data-height="" data-small-header="false" data-adapt-container-width="true" data-hide-cover="true" data-show-facepile="false"><blockquote cite="https://www.facebook.com/[***]" class="fb-xfbml-parse-ignore"><a href="https://www.facebook.com/[***]">[nnn]/a></blockquote></div>
                """;
                
    final c = webContent.replaceAll("[***]", state.activeStream?.facebookPage ?? "")
                      .replaceAll("[nnn]", state.activeStream?.stationName ?? "");


    _controller.loadHtmlString(c, baseUrl: "https://www.infonote.com");

  }

               
  


  @override
  void initState() {
    super.initState();


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
                if( request.url.startsWith("https://www.infonote.com/") || 
                    request.url.contains("www.facebook.com")) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://www.infonote.com'));

    _controller = controller;


  }


  @override
  Widget build(BuildContext context) {
    return Expanded(child: WebViewWidget(controller: _controller));
  }
}

class WebKitWebViewPlatform {
}
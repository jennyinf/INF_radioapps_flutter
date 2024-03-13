import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/src/service/radio_service.dart';
import 'package:radioapps/src/ui/app.dart';

void main()  {
  enableFlutterDriverExtension();

IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding();

  /// TODO - need to be able to change this
      F.appFlavor = Flavor.hfm;

  testWidgets('screenshot', (WidgetTester tester) async {
      await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  RadioService service = RadioService();

    // Render the UI of the app
    await tester.pumpWidget(MyApp());

  String platformName = '';

  if (!kIsWeb) {
    // Not required for the web. This is required prior to taking the screenshot.
    await binding.convertFlutterSurfaceToImage();

    if (Platform.isAndroid) {
      platformName = "android";
    } else {
      platformName = "ios";
    }
  } else {
    platformName = "web";
  }

  // To make sure at least one frame has rendered
  await tester.pumpAndSettle();
  // Take the screenshot
  await binding.takeScreenshot('screenshot-$platformName');
  });
}

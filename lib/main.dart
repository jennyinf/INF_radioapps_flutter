import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radioapps/src/settings/settings_controller.dart';
import 'package:radioapps/src/settings/settings_service.dart';
import 'package:radioapps/src/ui/app.dart';

Future<void> main() async {

  final service = SettingsService();
  final settingsController = SettingsController(service);
  settingsController.loadSettings();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp( MyApp(settingsController: settingsController,));
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radioapps/src/service/radio_service.dart';
import 'package:radioapps/src/ui/app.dart';
import 'app.dart';

FutureOr<void> main() async {

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  RadioService service = RadioService();

  runApp(const MyApp());

  // runApp(const App());
}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_run/app/app.dart';
import 'package:dash_run/audio/audio.dart';
import 'package:dash_run/bootstrap.dart';
import 'package:dash_run/firebase_options_prod.dart';
import 'package:dash_run/settings/persistence/persistence.dart';
import 'package:dash_run/settings/settings.dart';
import 'package:dash_run/share/share.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  await audio.initialize();

  final share = ShareController(
    gameUrl: 'https://superdash.flutter.dev/',
  );

  final leaderboardRepository = LeaderboardRepository(
    FirebaseFirestore.instance,
  );

  unawaited(
    bootstrap(
      () => App(
        audioController: audio,
        settingsController: settings,
        shareController: share,
        leaderboardRepository: leaderboardRepository,
      ),
    ),
  );
}
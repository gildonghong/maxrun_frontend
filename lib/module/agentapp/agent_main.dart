import 'package:flutter/material.dart';
import 'package:photoapp/preference.dart';

import 'agent_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initPreferences(),
    // Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform),
  ]);

  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };


  runApp(AgentApp());
}


import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:photoapp/module/photoapp/photo_app.dart';
import 'package:photoapp/preference.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final futures = [
    initPreferences(),
    Future.delayed(Duration(seconds: 1)),
  ];

  await Future.wait(futures);

  FlutterNativeSplash.remove();

  runApp(PhotoApp());
}

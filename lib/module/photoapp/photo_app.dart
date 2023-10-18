import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/screens/list_screen.dart';
import 'package:photoapp/service/user_service.dart';

import 'screens/app_login_screen.dart';

class PhotoApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primary = Colors.black87;
    return MaterialApp(
      title: 'Lotails Admin',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko'),
        Locale('en'),
      ],
      themeMode: ThemeMode.light,
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.light(primary: primary, secondary: primary),
        // colorScheme: ColorScheme.light(primary: Colors.black.withOpacity(0.8), secondary: Colors.red),
        useMaterial3: true,
        dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(fontSize: 16, color: Colors.black87)),
        // buttonTheme: ButtonThemeData(
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12))
        // ),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
            minimumSize: Size(60, 48),
          padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8))
        )),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          labelStyle: TextStyle(fontSize: 18),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Colors.black.withOpacity(0.03),
          // floatingLabelStyle: TextStyle(color: Colors.blue, height: 0.5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ),
      ),
      // home:ConsoleMainScreen(),
      home: StreamBuilder<User?>(
          stream: UserService().user,
          initialData: null,
          builder: (context, snapshot) {
            final user = snapshot.data;
            return user == null ? AppLoginScreen() : ListScreen();
          }),
      builder: EasyLoading.init(),
    );
  }
}

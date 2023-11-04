import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/screens/car_list_screen.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'screens/app_login_screen.dart';

final colorPrimary = Colors.red[800]!.withOpacity(0.9);
final colorSecondary = Colors.red[800]!.withOpacity(0.9);

class PhotoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => UserService().user,
            initialData: User.anonymous()),
        StreamProvider<List<Department>>(
            create: (context) => DepartmentService().departments,
            initialData: const <Department>[]),
        StreamProvider<Department?>(
            create: (context) => DepartmentService().userDepartment,
            initialData: null),
        StreamProvider<Shop?>(
            create: (context) => ShopService().userShop,
            initialData: null),
      ],
      child: MaterialApp(
        title: 'Lotails Admin',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'),
          Locale('en'),
        ],

        themeMode: ThemeMode.light,
        theme: ThemeData(
          // scaffoldBackgroundColor: Colors.black,
          // colorScheme: ColorScheme.fromSwatch(
          //     primarySwatch:Colors.green
          // ),
          appBarTheme: AppBarTheme(
            elevation:8,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black26,
          ),
          colorScheme: ColorScheme.light(
              primary: colorPrimary,
              secondary: colorSecondary,
              onSecondary: Colors.white,
          ),
          // colorScheme: ColorScheme.light(primary: Colors.black.withOpacity(0.8), secondary: Colors.red),
          useMaterial3: true,
          dialogTheme: const DialogTheme(
              titleTextStyle: TextStyle(fontSize: 16, color: Colors.black87)),
          // buttonTheme: ButtonThemeData(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12))
          // ),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(60, 48),
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            filled: true,
            labelStyle: const TextStyle(fontSize: 18),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            fillColor: Colors.black.withOpacity(0.03),
            // floatingLabelStyle: TextStyle(color: Colors.blue, height: 0.5),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
        ),
        // home:ConsoleMainScreen(),
        home: Builder(
          builder: (context) {
            final user = context.watch<User>();
            return user.workerNo == -1 ? AppLoginScreen() : CarListScreen();
          },
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}

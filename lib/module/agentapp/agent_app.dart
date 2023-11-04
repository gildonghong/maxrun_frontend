import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'screens/agent_main_screen.dart';
import 'screens/agent_login_screen.dart';

class AgentApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
            create: (context) => UserService().user.whereNotNull(),
            initialData: User.anonymous()),
        StreamProvider<List<Department>>(
            create: (context) => DepartmentService().departments,
            initialData: <Department>[]),
        StreamProvider<Department?>(
            create: (context) => DepartmentService().userDepartment,
            initialData: null),
        StreamProvider<Shop?>(
            create: (context) => ShopService().userShop, initialData: null),
      ],
      child: MaterialApp(
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          dialogTheme: DialogTheme(
              titleTextStyle: TextStyle(fontSize: 16, color: Colors.black87)),
          // buttonTheme: ButtonThemeData(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12))
          // ),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  minimumSize: Size(60, 48),
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            filled: true,
            labelStyle: TextStyle(fontSize: 18),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
        // home:AgentLoginScreen(),
        home: Builder(
          builder: (context) {
            return context.watch<User>().isAnonymous
                ? AgentLoginScreen()
                : AgentMainScreen();
          },
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}

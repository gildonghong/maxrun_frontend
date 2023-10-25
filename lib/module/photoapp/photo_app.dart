import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/screens/car_cares_screen.dart';
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
    return MaterialApp(
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
        colorScheme: ColorScheme.light(primary: colorPrimary, secondary: colorSecondary),
        // colorScheme: ColorScheme.light(primary: Colors.black.withOpacity(0.8), secondary: Colors.red),
        useMaterial3: true,
        dialogTheme: const DialogTheme(
            titleTextStyle: TextStyle(fontSize: 16, color: Colors.black87)),
        // buttonTheme: ButtonThemeData(
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12))
        // ),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
            minimumSize: const Size(60, 48),
          padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8))
        )),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          labelStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical:12),
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
      home: StreamBuilder<Tuple4<User?, List<Department>, Department?, Shop?>>(
          stream: Rx.combineLatest4(
              UserService().user.asSubject(),
              DepartmentService().departments,
              DepartmentService().userDepartment,
              ShopService().userShop,
                  (a, b, c, d) => Tuple4(a, b, c, d)),
          initialData: const Tuple4(null, [], null, null),
          builder: (context, snapshot) {
            final user = snapshot.data!.item1;
            final departments = snapshot.data!.item2;
            final userDepartment = snapshot.data!.item3;
            final userShop = snapshot.data!.item4;
            return user == null ||
                departments.isEmpty ||
                userDepartment == null ||
                userShop == null
                ? AppLoginScreen()
                : MultiProvider(providers: [
              StreamProvider(
                  create: (context) => UserService().user.whereNotNull(),
                  initialData: user),
              StreamProvider(
                  create: (context) => DepartmentService().departments,
                  initialData: departments),
              StreamProvider(
                  create: (context) => DepartmentService().userDepartment,
                  initialData: userDepartment),
              StreamProvider(
                  create: (context) => ShopService().userShop,
                  initialData: userShop),
            ], child: const CarCaresScreen());
          }),
      builder: EasyLoading.init(),
    );
  }
}

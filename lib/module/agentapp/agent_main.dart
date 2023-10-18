import 'package:flutter/material.dart';
import 'package:photoapp/preference.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:photoapp/service/shop_service.dart';

import 'agent_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();

  if(UserService().user.getValue() != null) {
    await Future.wait([
      DepartmentService().fetch(),
      ShopService().fetch()]);
  }

  runApp(AgentApp());
}


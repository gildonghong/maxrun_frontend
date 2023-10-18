import 'package:flutter/material.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/module/agentapp/screens/department_setting.dart';
import 'package:photoapp/service/shop_service.dart';

import 'shop_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 600,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 16),
        child: Column(
          children: [
            StreamBuilder<Shop?>(
              stream: ShopService().shop,
              initialData: null,
              builder: (context, snapshot) {
                return ShopSettingScreen();
              }
            ),
            SizedBox(height: 32),
            Expanded(child: DepartmentSetting()),
          ],
        ),
      ),
    );
  }
}

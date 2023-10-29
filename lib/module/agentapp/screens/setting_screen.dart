import 'package:flutter/material.dart';
import 'package:photoapp/module/agentapp/screens/shop_department_setting.dart';

import 'shop_info_screen.dart';

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
            ShopInfoScreen(),
            SizedBox(height: 32),
            Expanded(child: ShopDepartmentSetting()),
          ],
        ),
      ),
    );
  }
}

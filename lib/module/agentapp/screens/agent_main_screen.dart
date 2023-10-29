import 'package:flutter/material.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/agentapp/screens/account_screen.dart';
import 'package:photoapp/module/agentapp/screens/notice_screen.dart';
import 'package:photoapp/module/agentapp/screens/photo_manage_screen.dart';
import 'package:photoapp/module/agentapp/screens/shop_manage_screen.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';

import 'setting_screen.dart';
import 'performance_screen.dart';


class AgentMainScreen extends StatefulWidget {
  const AgentMainScreen({super.key});

  @override
  State<AgentMainScreen> createState() => _AgentMainScreenState();
}

typedef ScreenBuilder = Widget Function();

enum Permission {
  both,
  shop,
  hq
}

enum Menu {
  notice(text: "공지사항", permission:Permission.both, screen: NoticeScreen()),
  shop(text: "공업사관리", permission:Permission.hq, screen: ShopManageScreen()),
  repair(text: "사진관리", permission:Permission.both, screen: PhotoManageScreen()),
  account(text: "계정관리", permission:Permission.shop, screen: AccountScreen()),
  work(text: "실적관리", permission:Permission.shop, screen: PerformanceScreen()),
  setting(text: "환경설정", permission:Permission.both, screen: SettingScreen()),
  ;

  final String text;
  final Permission permission;
  final Widget screen;

  const Menu({
    required this.text,
    required this.permission,
    required this.screen,
  });
}

class _AgentMainScreenState extends State<AgentMainScreen> {
  final menus = UserService().user.map((event) {
    if( event?.repairShopNo == -1) {
      return Menu.values.where((element) => element.permission!=Permission.shop).toList();
    } else {
      return Menu.values.where((element) => element.permission!=Permission.hq).toList();
    }
  });

  final PageController pageViewController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Menu>>(
        stream: menus,
        initialData: [],
        builder: (context, snapshot) {
          return Row(
            children: [
              ExcludeFocus(child: menuList(snapshot.data!)),
              Expanded(child: content(snapshot.data!)),
            ],
          );
        }
      ),
    );
  }

  Widget menuList(List<Menu> list) {
    final user = context.watch<User>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.blue[50],
      width: 160,
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            user.repairShopName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ...list.map((e) {
            final index = list.indexOf(e);
            return SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text(e.text,
                    style:
                        TextStyle(fontSize: currentIndex == index ? 18 : 14)),
                onPressed: () {
                  setState(() {
                    pageViewController.jumpToPage(index);
                    // menu = e;
                  });
                },
              ),
            );
          }),
          SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  UserService().logout();
                },
                child: Text(
                  "${user.workerName}\n로그아웃",
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget content(List<Menu> list) {
    return PageView(
      controller: pageViewController,
      children: list.map((e) => e.screen).toList(),
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;

          /// Switching bottom tabs
        });
      },
    );
  }
}

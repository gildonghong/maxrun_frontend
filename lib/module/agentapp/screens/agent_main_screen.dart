import 'package:flutter/material.dart';
import 'package:photoapp/module/agentapp/screens/account_screen.dart';
import 'package:photoapp/module/agentapp/screens/notice_screen.dart';
import 'package:photoapp/module/agentapp/screens/photo_screen.dart';
import 'package:photoapp/module/agentapp/screens/setting_screen.dart';
import 'package:photoapp/module/agentapp/screens/repair_screen.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:photoapp/model/user.dart';

import 'work_screen.dart';


class AgentMainScreen extends StatefulWidget {
  const AgentMainScreen({super.key});

  @override
  State<AgentMainScreen> createState() => _AgentMainScreenState();
}

typedef ScreenBuilder = Widget Function();

enum menu {
  notice(text: "공지사항", screen: NoticeScreen()),
  repair(text: "사진관리", screen: RepairScreen()),
  setting(text: "환경설정", screen: SettingScreen()),
  account(text: "계정관리", screen: AccountScreen()),
  work(text: "실적관리", screen: WorkScreen()),
  ;

  final String text;
  final Widget screen;

  const menu({
    required this.text,
    required this.screen,
  });

}

class _AgentMainScreenState extends State<AgentMainScreen> {
  final PageController pageViewController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          menuList(),
          Expanded(child: content()),
        ],
      ),
    );
  }

  Widget menuList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.blue[50],
      width: 120,
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            "맥스런\n에이전트",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ...menu.values.map((e) {
            return SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text(e.text,
                    style:
                        TextStyle(fontSize: currentIndex == e.index ? 18 : 14)),
                onPressed: () {
                  setState(() {
                    pageViewController.jumpToPage(e.index);
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
                child: StreamBuilder<User?>(
                  stream: UserService().user,
                  initialData: null,
                  builder: (context, snapshot) {
                    return Text(
                      "${snapshot.data?.workerName ?? ""} 님\n로그아웃",
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    );
                  }
                )),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget content() {
    return PageView(
      controller: pageViewController,
      children: menu.values.map((e) => e.screen).toList(),
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;

          /// Switching bottom tabs
        });
      },
    );
  }
}

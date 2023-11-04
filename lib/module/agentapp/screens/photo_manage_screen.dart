import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/agentapp/screens/enter_detail.dart';
import 'package:photoapp/module/agentapp/screens/enter_list_model.dart';
import 'package:photoapp/module/agentapp/screens/shop_list.dart';
import 'package:photoapp/module/agentapp/screens/shop_list_model.dart';
import 'package:photoapp/service/user_service.dart';

import 'enter_list.dart';

class PhotoManageScreen extends StatefulWidget {
  const PhotoManageScreen({super.key});

  @override
  State<PhotoManageScreen> createState() => _PhotoManageScreenState();
}

class _PhotoManageScreenState extends State<PhotoManageScreen>
    with AutomaticKeepAliveClientMixin {
  late StreamSubscription<Shop?> sub;

  @override
  bool get wantKeepAlive => true;

  final shopListModel = ShopListModel();
  final enterListModel = EnterListModel();

  @override
  void initState() {
    super.initState();

    sub = shopListModel.selected.listen((value) {
      enterListModel.repairShopNo = value?.repairShopNo;
      enterListModel.search();
    });
  }

  @override
  void dispose() {
    enterListModel.dispose();
    shopListModel.dispose();
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Visibility(
            visible: currentUser.repairShopNo==-1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: EdgeInsets.all(12),
                    width: 240,
                    child: ShopList(model: shopListModel)),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(12),
              width: 280,
              child: EnterList(
                model: enterListModel,
              )),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: EnterDetail(enter: enterListModel.selected),
          ))
        ],
      ),
    );
  }
}

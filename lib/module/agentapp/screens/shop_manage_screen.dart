import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/module/agentapp/screens/shop_detail_screen.dart';
import 'package:photoapp/module/agentapp/screens/shop_list.dart';
import 'package:photoapp/module/agentapp/screens/shop_list_model.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:rxdart/rxdart.dart';

class ShopManageScreen extends StatefulWidget {
  const ShopManageScreen({super.key});

  @override
  State<ShopManageScreen> createState() => _ShopManageScreenState();
}

class _ShopManageScreenState extends State<ShopManageScreen>
    with AutomaticKeepAliveClientMixin {
  final searchModel = ShopListModel(showAddButton: true);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(12),
              width: 240,
              child: ShopList(
                model: searchModel,
              )),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Container(
            width: 400,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(12.0),
            child: ShopDetailScreen(shop: searchModel.selected),
          )
        ],
      ),
    );
  }
}

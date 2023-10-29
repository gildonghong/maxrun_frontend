import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:rxdart/rxdart.dart';

class ShopListModel {
  var showAddButton = false;
  final searchController = TextEditingController(text: "");
  final selectedShopNo = BehaviorSubject<int?>.seeded(null);
  late final searchStream = searchController.toValueStream(replayValue: true);
  late final list = Rx.combineLatest2(
      ShopService().list, searchStream,
      (a, b) {
    return a
        .where((element) =>
            b.text.isEmpty ||
            element.repairShopName?.trim().toLowerCase().contains(b.text.trim().toLowerCase()) == true)
        .toList();
  });
  late final selected =
      Rx.combineLatest2(ShopService().list, selectedShopNo, (a, b) {
    return a.firstWhereOrNull((element) => element.repairShopNo == b);
  }).asSubject();


  ShopListModel({this.showAddButton=false});


  init() {
    ShopService().fetch().then((value) =>
        selectedShopNo.value = value.firstOrNull?.repairShopNo ?? -1);
  }

  void dispose() {
    selectedShopNo.close();
    try{
      searchController.dispose();
    }catch(e){
      //Once you have called dispose() on a TextEditingController, it can no longer be used.
      //에러가 나지만 다른 방법이 없다
    }
  }
}

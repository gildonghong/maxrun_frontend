import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:listenable_stream/listenable_stream.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:rxdart/rxdart.dart';

class EnterListModel {
  final searchController = TextEditingController();
  final selectedReqNo = BehaviorSubject<int?>.seeded(null);
  late final list = Rx.combineLatest2(
      EnterService().list, searchController.toValueStream(replayValue: true),
          (a, b) {
        return a
            .where((element) =>
        b.text.isEmpty ||
            element.carLicenseNo.trim().contains(b.text.trim()) == true)
            .toList();
      }).asSubject();
  late final selected =
      Rx.combineLatest2(list, selectedReqNo, (a, b) {
    return a.firstWhereOrNull((element) => element.reqNo == b);
  }).asSubject();



  void dispose() {
    selectedReqNo.close();
    searchController.dispose();
  }

  Future<List<Enter>> search({int? repairShopNo})async {
    final list = await EnterService().fetch(
        repairShopNo: repairShopNo, carLicenseNo: searchController.text.trim());

    if(list.firstWhereOrNull((element) => element.reqNo == selectedReqNo.value) == null) {
      selectedReqNo.value = list.firstOrNull?.reqNo;
    }

    return  list;
  }
}

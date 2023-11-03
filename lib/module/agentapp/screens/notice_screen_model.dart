import 'dart:async';

import 'package:darty_json/darty_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/notice.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../service/api_service.dart';

class NoticeScreenModel extends DataGridSource {
  bool shouldRecalc = false;
  var list = <Notice>[];

  String? title;
  String? content;

  final formKey = GlobalKey<FormState>();

  NoticeScreenModel() {
    fetch();
  }

  @override
  List<DataGridRow> rows = [];

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetch() async {
    final res = await api.get<List<dynamic>>(
      "/notice/list",
    );
    list = Json.fromList(res.data!)
        .listOfValue((p0) => Notice.fromJson(p0))
        .toList();

    rows = list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: e.noticeNo),
        DataGridCell<String>(
            columnName: '제목', value: e.noticeTitle),
        DataGridCell<String>(columnName: '일자', value: e.noticeDate.yyyyMMdd),
      ]);
    }).toList();
    shouldRecalc = true;
    notifyListeners();
  }

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
      column(columnName: 'No', width: 80),
      column(columnName: '제목'),
      column(columnName: '일자', width: 100),
    ];

    return columns;
  }

  @override
  bool shouldRecalculateColumnWidths() {
    final r = shouldRecalc;
    shouldRecalc = false;
    return r;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          if (e.columnName == "제목") {
            return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ));
          } else {
            return Container(
                alignment: Alignment.center,
                child: Text(
                  "${e.value}",
                  textAlign: TextAlign.center,
                ));
          }
        }).toList());
    // }
  }



  Future<void> save(int? noticeNo) async {
    await api.post<Map<String, dynamic>>("/notice", data: {
      "noticeNo": noticeNo,
      "title": title,
      "notice": content,
    });

    await fetch();
  }

  Future<void> delete(int noticeNo) async {
    await api.post<Map<String, dynamic>>("/notice", data: {
      "noticeNo": noticeNo,
      "delYn": 'Y',
    });

    await fetch();
  }
}

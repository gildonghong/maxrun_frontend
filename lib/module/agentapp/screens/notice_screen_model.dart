import 'dart:async';

import 'package:darty_json/darty_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/notice.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../service/api_service.dart';

class NoticeScreenModel extends DataGridSource {
  bool shouldRecalc = false;
  var list = <Notice>[];

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
    // final res = await api.get<List<dynamic>>("/notice/list", );
    // list = Json.fromList(res.data!).listOfValue((p0) => Notice.fromJson(p0)).toList();

    rows = list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: e.noticeNo),
        DataGridCell<String>(columnName: '제목', value: e.notice),
        DataGridCell<String>(
            columnName: '일자', value: e.noticeDate.yyyyMMdd),
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
      return Container(
          alignment: e.columnName=="제목"? Alignment.centerLeft : Alignment.center,
          child: Text(
            "${e.value}",
            style: TextStyle(),
            textAlign: TextAlign.center,
          ));
    }).toList());
    // }
  }
}

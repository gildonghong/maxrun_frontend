import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/module/agentapp/screens/account_grid_form.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/user.dart';

class WorkScreenModel extends DataGridSource {
  bool shouldRecalc = false;

  String? workerName;

  String? position;

  String? carNo;

  List<Account> get list => AccountService().accounts.value;
  late StreamSubscription<List<User>> sub;
  DateTimeRange dateRange = DateTimeRange(start: DateTime.now().toUtc().add(Duration(days: -6)), end: DateTime.now().toUtc());

  @override
  List<DataGridRow> rows = [];

  WorkScreenModel() {
    rows = [];
    shouldRecalc = true;
    notifyListeners();
  }

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
      column(columnName: "No", allowSorting: true),
      column(columnName: "전송일자", allowSorting: true),
      column(columnName: "차량번호"),
      column(columnName: "사진전송수", allowSorting: true),
      column(columnName: "부서", allowSorting: true),
      column(columnName: "직책", allowSorting: true),
      column(columnName: "성명", allowSorting: true),
      column(columnName: "휴대폰"),
      column(columnName: "ID"),
      column(columnName: "직원사용일", allowSorting: true),
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
          return Center(
            child: Text(
              "${e.value}",
              style: TextStyle(),
            ),
          );
        }).toList());
    // }
  }
}

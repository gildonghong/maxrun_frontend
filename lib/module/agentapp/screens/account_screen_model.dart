import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/module/agentapp/screens/account_grid_form.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/user.dart';

class AccountScreenModel extends DataGridSource {
  bool shouldRecalc = false;

  List<Account> get list => AccountService().list.value;
  final gridFormList = <AccountGridForm>[];
  late StreamSubscription<List<Account>> sub;

  @override
  List<DataGridRow> rows = [];

  AccountScreenModel() {
    sub = AccountService().list.listen((value) {
      for (var element in gridFormList) {element.dispose();}
      gridFormList.clear();
      gridFormList.addAll(value.map((e) => AccountGridForm(account: e)));
      rows = list.map<DataGridRow>((e) {
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: e.workerNo),
          DataGridCell<String>(columnName: '부서', value: e.departmentName),
          DataGridCell<String>(columnName: '직책', value: e.position),
          DataGridCell<String>(columnName: '성명', value: e.workerName),
          DataGridCell<String>(columnName: '휴대폰', value: e.cpNo),
          DataGridCell<String>(columnName: 'ID', value: e.loginId),
          DataGridCell<String>(columnName: 'PW', value: e.pwd),
          DataGridCell<DateTime>(columnName: '직원사용일', value: e.lastUseDate),
          DataGridCell<String>(columnName: 'App버전', value: e.osVersion),
          // DataGridCell<String>(columnName: '작업중사진', value: "N"),
          DataGridCell<String>(columnName: '상태', value: "Y"),
          DataGridCell<Account>(columnName: '저장', value: e),
        ]);
      }).toList();
      shouldRecalc = true;
      notifyListeners();
    });
  }

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
      column(columnName: "No",width: 70),
      column(columnName: "부서",width: 120),
      column(columnName: "직책",width: 100),
      column(columnName: "성명",width: 90),
      column(columnName: "휴대폰",width: 120),
      column(columnName: "ID"),
      column(columnName: "PW",width: 100),
      column(columnName: "직원사용일",width: 100),
      column(columnName: "App버전",width: 100),
      // column(columnName: "작업중사진",width: 100),
      column(columnName: "상태",width: 100),
      column(columnName: "저장",width: 80),
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
    final index = rows.indexOf(row);
    final form = gridFormList[index];
    final account = form.account;

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          switch (e.columnName) {
            case "No":
              return Center(
                child: Text(
                  "${e.value}",
                  style: TextStyle(),
                ),
              );
            case "부서":
              return form.department;
            case "직책":
              return form.position;
            case "성명":
              return form.name;
            case "휴대폰":
              return form.phone;
            case "ID":
              return form.loginId;
            case "PW":
              return form.pw;
            case "직원사용일":
              return Center(
                child: Text(
                  (e.value as DateTime).yyyyMMdd,
                  style: TextStyle(),
                ),
              );
            case "App버전":
              return Center(
                child: Text(
                  account.osVersion,
                  style: TextStyle(),
                ),
              );
            // case "작업중사진":
            //   return form.workingPhoto;
            case "상태":
              return form.status;
            case "저장":
              return form.save;
            default:
              return Container();
          }
        }).toList());
    // }
  }
}

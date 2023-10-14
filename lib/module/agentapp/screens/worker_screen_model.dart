import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/module/agentapp/screens/worker_grid_form.dart';
import 'package:photoapp/service/worker_service.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/worker.dart';

class WorkerScreenModel extends DataGridSource {
  bool shouldRecalc = false;

  List<Worker> get list => WorkerService().list.value;
  final gridFormList = <WorkerGridForm>[];
  late StreamSubscription<List<Worker>> sub;

  @override
  List<DataGridRow> rows = [];

  WorkerScreenModel() {
    sub = WorkerService().list.listen((value) {
      for (var element in gridFormList) {element.dispose();}
      gridFormList.clear();
      gridFormList.addAll(value.map((e) => WorkerGridForm(worker: e)));
      rows = list.map<DataGridRow>((e) {
        return DataGridRow(cells: [
          DataGridCell<int>(columnName: 'No', value: e.workerNo),
          DataGridCell<String>(columnName: '부서', value: e.departmentName),
          DataGridCell<String>(columnName: '직책', value: e.position),
          DataGridCell<String>(columnName: '성명', value: e.wokerName),
          DataGridCell<String>(columnName: '휴대폰', value: ""),
          DataGridCell<String>(columnName: 'ID', value: "maxrun"),
          DataGridCell<String>(columnName: 'PW', value: ""),
          DataGridCell<DateTime>(
              columnName: '직원사용일',
              value: DateTime.fromMillisecondsSinceEpoch(1697287756322)),
          DataGridCell<String>(columnName: 'App버전', value: e.osVersion),
          DataGridCell<String>(columnName: '작업중사진', value: "N"),
          DataGridCell<String>(columnName: '상태', value: "Y"),
        ]);
      }).toList();
      shouldRecalc = true;
      notifyListeners();
    });
  }

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
      column(columnName: "No",width: 70),
      column(columnName: "부서",width: 100),
      column(columnName: "직책",width: 100),
      column(columnName: "성명",width: 90),
      column(columnName: "휴대폰",width: 120),
      column(columnName: "ID"),
      column(columnName: "PW",width: 100),
      column(columnName: "직원사용일",width: 100),
      column(columnName: "App버전",width: 100),
      column(columnName: "작업중사진",width: 100),
      column(columnName: "상태",width: 100),
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
    final worker = form.worker;

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
              return Center(
                child: Text(
                  "maxrun",
                  style: TextStyle(),
                ),
              );
            case "PW":
              return form.pw;
            case "직원사용일":
              return Center(
                child: Text(
                  DateTime.fromMillisecondsSinceEpoch(worker.loginDate).yyyyMMdd,
                  style: TextStyle(),
                ),
              );
            case "App버전":
              return Center(
                child: Text(
                  worker.osVersion,
                  style: TextStyle(),
                ),
              );
            case "작업중사진":
              return form.workingPhoto;
            case "상태":
              return form.status;
            default:
              return Container();
          }
        }).toList());
    // }
  }
}

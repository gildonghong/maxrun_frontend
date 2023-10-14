import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/model/repair.dart';
import 'package:photoapp/service/api_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RepairScreenModel extends DataGridSource {
  bool shouldRecalc = false;
  var list = <Repair>[];

  RepairScreenModel() {
    fetch();
  }

  @override
  List<DataGridRow> rows = [];

  Future<void> fetch() async {
    // final res = await api.get<List<dynamic>>("/notice/list",);
    // list = Json.fromList(res.data!).listOfValue((p0) => Notice.fromJson(p0)).toList();

    if (kDebugMode && list.isEmpty) {
      // list.add(Notice(noticeNo: 1, notice: "맥스런 리뉴얼 런칭", regDate: "2023-10-14"));
      list.add(Repair(carLicenseNo: "25라 9464"));
      list.add(Repair(carLicenseNo: "119로 6975"));
    }

    rows = list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'No', value: e.carLicenseNo),
      ]);
    }).toList();
    shouldRecalc = true;
    notifyListeners();
  }

  final searchController = TextEditingController();

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
      GridColumn(columnName: 'No', label: SizedBox())
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
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12)),
          padding: EdgeInsets.only(left: 8),
          margin: EdgeInsets.only(bottom: 2),
          alignment: Alignment.centerLeft,
          child: Text(
            "${e.value}",
            style: TextStyle(),
          ),
        ),
      );
    }).toList());
    // }
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/model/performance.dart';
import 'package:photoapp/service/api_service.dart';
import 'package:photoapp/ui/grid.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class PerformanceScreenModel extends DataGridSource {
  bool shouldRecalc = false;
  final account = BehaviorSubject<Account?>.seeded(null);
  final carNo = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<SfDataGridState> gridKey = GlobalKey<SfDataGridState>();

  final dateRange = BehaviorSubject<DateTimeRange>.seeded(DateTimeRange(
      start: DateTime.now().toUtc().add(Duration(days: -6)),
      end: DateTime.now().toUtc()));

  List<Performance> list = [];

  @override
  List<DataGridRow> rows = [];

  resetSearchForm() {
    formKey.currentState?.reset();
    account.value = null;
    carNo.text = "";
    dateRange.value = DateTimeRange(
        start: DateTime.now().toUtc().add(Duration(days: -6)),
        end: DateTime.now().toUtc());
    fetch();
  }

  fetch() async {
    final res = await api
        .get<List<dynamic>>("/repairshop/performance/list", queryParameters: {
      "workerName": account.valueOrNull?.workerName,
      "fromDate": dateRange.value.start.yyyyMMdd,
      "toDate": dateRange.value.end.yyyyMMdd,
      "carLicenseNo": carNo.text,
    });
    list = res.data!.map((e) => Performance.fromJson(e)).toList();
    rows = list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: '전송일자', value: e.regDate),
        DataGridCell<String>(columnName: '차량번호', value: e.carLicenseNo),
        DataGridCell<int>(columnName: '사진전송수', value: e.photoCount),
        DataGridCell<String>(columnName: '부서', value: e.departmentName),
        DataGridCell<String>(columnName: '직책', value: e.position),
        DataGridCell<String>(columnName: '성명', value: e.workerName),
        DataGridCell<String?>(columnName: '휴대폰', value: e.cpNo),
        DataGridCell<String>(columnName: 'ID', value: e.loginId),
        // DataGridCell<String>(columnName: '작업중사진', value: "N"),
        DataGridCell<String>(
            columnName: '직원사용일', value: e.lastUseDate.yyyyMMdd),
      ]);
    }).toList();
    shouldRecalc = true;
    notifyListeners();
  }

  List<GridColumn> getColumns() {
    final columns = <GridColumn>[
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
          "${e.value ?? ''}",
          style: TextStyle(),
        ),
      );
    }).toList());
    // }
  }

  Future<void> exportToExcel() async {
    final Workbook workbook = gridKey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = await workbook.save();
    workbook.dispose();

    final path = await FilePicker.platform
        .saveFile(dialogTitle: "파일을 저장하실 위치를 선택해주세요.", fileName: "실적관리.xlsx");
    if (path == null) {
      return;
    }

    await File(path).writeAsBytes(bytes);

    // await helper.FileSaveHelper.saveAndLaunchFile(bytes, '$fileName.xlsx');
  }
}

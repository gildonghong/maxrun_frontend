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
        DataGridCell<Notice>(
            columnName: '내용', value: e),
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
          if (e.columnName == "내용") {
            final notice = e.value as Notice;
            return Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Text(notice.notice,
                  ),
                  onPressed: () {
                    openDialog(notice);
                  },
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

  openDialog(Notice? notice) {
    content = notice?.notice ?? "";
    final nav = Navigator.of(formKey.currentContext!);
    showDialog(
      context: formKey.currentContext!,
      builder: (context) =>
          Form(
            key: formKey,
            child: AlertDialog(
              title: Text(
                  notice == null ? "공지사항 등록" : "공지사항 수정", style: TextStyle()),
              content: SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "내용"),
                  validator: (value) {
                    if (value
                        ?.trim()
                        .isNotEmpty != true) {
                      return "내용을 입력하세요";
                    }
                  },
                  onChanged: (value) {
                    content = value;
                  },
                  initialValue: content,
                  minLines: 10,
                  maxLines: 20,
                ),
              ),
              actions: [
                TextButton(
                  child: Text("취소", style: TextStyle()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("등록", style: TextStyle()),
                  onPressed: () async {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }
                    await save(notice?.noticeNo);
                    nav.pop();
                    EasyLoading.showSuccess("공지사항을 등록했습니다.");
                  },
                )
              ],
            ),
          ),
    );
  }


  Future<void> save(int? noticeNo) async {
    await api.post<Map<String, dynamic>>("/notice", data: {
      "noticeNo": noticeNo,
      "notice": content,
    });

    await fetch();
  }
}

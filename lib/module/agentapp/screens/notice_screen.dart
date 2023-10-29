import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/notice.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/agentapp/screens/notice_screen_model.dart';
import 'package:photoapp/ui/always_disabled_focus_node.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final model = NoticeScreenModel();

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list(),
      floatingActionButton: addButton(),
    );
  }

  Widget list() {
    final user = context.watch<User>();
    return SfDataGrid(
      rowHeight: 32,
      source: model,
      columnWidthMode: ColumnWidthMode.fill,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
      onCellTap: (details) {
        if(details.column.columnName=='내용') {
          final notice = model.list[details.rowColumnIndex.rowIndex-1];
          openDialog(notice,user);
        }
      },
    );
  }

  openDialog(Notice? notice, User user) {

    model.content = notice?.notice ?? "";
    showDialog(
      context: context,
      builder: (context) =>
          Form(
            key: model.formKey,
            child: AlertDialog(
              title: Text(
                  user.repairShopNo!=-1 ?"공지사항":
                  notice == null ? "공지사항 등록" : "공지사항 수정", style: TextStyle()),
              content: SizedBox(
                width: 400,
                child: TextFormField(
                  focusNode: user.repairShopNo==-1?null:AlwaysDisabledFocusNode(),
                  decoration: InputDecoration(labelText: "내용"),
                  validator: (value) {
                    if (value
                        ?.trim()
                        .isNotEmpty != true) {
                      return "내용을 입력하세요";
                    }
                  },
                  onChanged: (value) {
                    model.content = value;
                  },
                  initialValue: model.content,
                  minLines: 10,
                  maxLines: 20,
                ),
              ),
              actions: [
                TextButton(
                  child: Text("닫기", style: TextStyle()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Visibility(
                  visible: user.repairShopNo ==-1,
                  child: TextButton(
                    child: Text("저장", style: TextStyle()),
                    onPressed: () async {
                      if (model.formKey.currentState?.validate() != true) {
                        return;
                      }
                      await model.save(notice?.noticeNo);
                      Navigator.of(context).pop();
                      EasyLoading.showSuccess("공지사항을 등록했습니다.");
                    },
                  ),
                )
              ],
            ),
          ),
    );
  }


  Widget addButton() {
    final user = context.watch<User>();
    return FloatingActionButton(
      onPressed: () {
        openDialog(null, user);
      },
      child: Icon(Icons.add),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photoapp/module/agentapp/screens/notice_screen_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>  with AutomaticKeepAliveClientMixin {
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
    return list();
  }

  Widget list() {
    return SfDataGrid(
      rowHeight: 32,
      source: model,
      columnWidthMode: ColumnWidthMode.fill,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
    );
  }
}

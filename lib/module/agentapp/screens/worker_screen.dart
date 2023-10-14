import 'package:flutter/material.dart';
import 'package:photoapp/module/agentapp/screens/worker_screen_model.dart';
import 'package:photoapp/service/worker_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WorkerScreen extends StatefulWidget {
  const WorkerScreen({super.key});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final model = WorkerScreenModel();

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:floatingActionButton(),
      body: list(),
    );
  }

  Widget floatingActionButton(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(onPressed: (){},child:Icon(Icons.edit) ,),
        SizedBox(height:12),
        FloatingActionButton(onPressed: (){
          WorkerService().fetch();
        },child:Icon(Icons.refresh) ,),
      ],
    );
  }

  Widget list() {
    return SfDataGrid(
      rowHeight: 48,
      source: model,
      columnWidthMode: ColumnWidthMode.auto,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
    );
  }
}

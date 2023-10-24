import 'package:flutter/material.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/module/agentapp/screens/account_screen_model.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final AccountScreenModel model;

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final departments = context.read<List<Department>>();
    model = AccountScreenModel(departments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:floatingActionButton(),
      body: list(),
    );
  }

  Widget floatingActionButton(){
    final departments = context.watch<List<Department>>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(onPressed: (){
          AccountService().add(departments.first);
        },child:Icon(Icons.add) ,),
        SizedBox(height:12),
        FloatingActionButton(onPressed: (){
          AccountService().fetch();
        },child:Icon(Icons.refresh) ,),
      ],
    );
  }

  Widget list() {
    return SfDataGrid(
      gridLinesVisibility: GridLinesVisibility.none,
      rowHeight: 48,
      source: model,
      columnWidthMode: ColumnWidthMode.auto,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
    );
  }
}

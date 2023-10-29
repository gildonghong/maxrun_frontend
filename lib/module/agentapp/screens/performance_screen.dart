import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'performance_screen_model.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final model = PerformanceScreenModel();

  @override
  void initState() {
    super.initState();
    model.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchForm(),
        Expanded(child: list()),
      ],
    );
  }

  Widget searchForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: Form(
        key: model.formKey,
        child: Row(
          children: [
            SizedBox(width: 240, child: dateRange()),
            SizedBox(width: 8),
            SizedBox(width: 140, child: worker()),
            SizedBox(width: 8),
            SizedBox(width: 140, child: carNo()),
            SizedBox(width: 8),
            searchButton(),
            SizedBox(width: 8),
            resetButton(),
            SizedBox(width: 8),
            excel(),
          ],
        ),
      ),
    );
  }

  Widget searchButton() {
    return FilledButton(
      onPressed: () {
        model.fetch();
      },
      child: Text("조회", style: TextStyle()),
    );
  }

  Widget resetButton() {
    return FilledButton(
      onPressed: () {
        model.resetSearchForm();
      },
      child: Text("초기화", style: TextStyle()),
    );
  }

  Widget excel() {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Colors.green),
      onPressed: () {
        model.exportToExcel();
      },
      child: Text("액셀다운로드", style: TextStyle()),
    );
  }

  Widget dateRange() {
    return FormBuilderDateRangePicker(
      locale: Locale.fromSubtags(languageCode: "ko", countryCode: "KR"),
      saveText: "확인",
      pickerBuilder: (p0, p1) {
        return Dialog(child: SizedBox(width: 400, child: p1!));
      },
      initialEntryMode: DatePickerEntryMode.calendar,
      decoration: InputDecoration(labelText: "기간"),
      textAlign: TextAlign.center,
      initialValue: model.dateRange.value,
      format: DateFormat("yyyy-MM-dd"),
      name: '기간',
      firstDate: DateTime.now().add(Duration(days: -364)).toUtc(),
      lastDate: DateTime.now().toUtc(),
      onChanged: (value) {
        if( value == model.dateRange.value) {
          return;
        }
        model.dateRange.value = value ?? model.dateRange.value;
        model.fetch();
      },
    );
  }

  Widget worker() {
    return StreamBuilder2<List<Account>, Account?>(
      streams: StreamTuple2(AccountService().accounts, model.account),
      initialData: InitialDataTuple2([], null),
      builder: (context, snapshot) {
        final list = snapshot.snapshot1.data ?? [];
        final value = snapshot.snapshot2.data;
        return DropdownButtonFormField<Account?>(
          decoration: InputDecoration(labelText: "담당자"),
          value: value,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text("전체", style: TextStyle()),
            ),
            ...list.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.workerName, style: TextStyle()),
                ))
          ],
          onChanged: (value) {
            if( value == model.account.value) {
              return;
            }
            model.account.value = value;
            model.fetch();
          },
        );
      },
    );
  }

  Widget carNo() {
    return TextFormField(
      controller: model.carNo,
      onEditingComplete: () {
        model.fetch();
      },
      decoration: InputDecoration(labelText: "차량번호"),
    );
  }

  Widget list() {
    return SfDataGrid(
      key: model.gridKey,
      rowHeight: 32,
      source: model,
      allowSorting: true,
      columnWidthMode: ColumnWidthMode.auto,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
    );
  }
}

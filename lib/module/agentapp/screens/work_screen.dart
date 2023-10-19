import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/agentapp/screens/account_screen_model.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'work_screen_model.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final model = WorkScreenModel();

  @override
  void dispose() {
    super.dispose();
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        search(),
        list(),
      ],
    );
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
      child: Row(
        children: [
          SizedBox(width: 260, child: term()),
          SizedBox(width: 8),
          SizedBox(width: 100, child: worker()),
          SizedBox(width: 8),
          SizedBox(width: 100, child: department()),
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
    );
  }

  Widget searchButton() {
    return FilledButton(
      onPressed: () {},
      child: Text("조회", style: TextStyle()),
    );
  }

  Widget resetButton() {
    return FilledButton(
      onPressed: () {},
      child: Text("초기화", style: TextStyle()),
    );
  }

  Widget excel() {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Colors.green),
      onPressed: () {},
      child: Text("액셀다운로드", style: TextStyle()),
    );
  }

  Widget term() {
    return FormBuilderDateRangePicker(
      locale: Locale.fromSubtags(languageCode: "ko", countryCode: "KR"),
      saveText: "확인",
      pickerBuilder: (p0, p1) {
        return Dialog(child: SizedBox(width: 400, child: p1!));
      },
      initialEntryMode: DatePickerEntryMode.calendar,
      decoration: InputDecoration(labelText: "기간"),
      textAlign: TextAlign.center,
      initialValue:
          DateTimeRange(start: model.dateRange.start, end: model.dateRange.end),
      format: DateFormat("yyyy-MM-dd"),
      name: '기간',
      firstDate: DateTime.now().add(Duration(days: -364)).toUtc(),
      lastDate: DateTime.now().toUtc(),
      onChanged: (value) {
        model.dateRange = value ?? model.dateRange;
      },
    );
  }

  Widget worker() {
    return StreamBuilder<List<Account>>(
      stream: AccountService().accounts,
      initialData: [],
      builder: (context, snapshot) {
        return DropdownButtonFormField(
          decoration: InputDecoration(labelText: "담당자"),
          value: model.workerName,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text("전체", style: TextStyle()),
            ),
            ...snapshot.data!.map((e) => DropdownMenuItem(
                  value: e.workerName,
                  child: Text(e.workerName, style: TextStyle()),
                ))
          ],
          onChanged: (value) {
            model.workerName = value;
          },
        );
      },
    );
  }

  Widget department() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: "직책"),
      value: model.position,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text("전체", style: TextStyle()),
        ),
        ...["관리자", "공장장", "부장", "반장", "팀장", "반장", "사원", "작업폰"]
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: TextStyle()),
                ))
      ],
      onChanged: (value) {
        model.position = value;
      },
    );
  }

  Widget carNo() {
    return TextFormField(
      decoration: InputDecoration(labelText: "차량번호"),
      onChanged: (value) {
        model.carNo = value;
      },
    );
  }

  Widget list() {
    return SfDataGrid(
      rowHeight: 32,
      source: model,
      allowSorting: true,
      columnWidthMode: ColumnWidthMode.auto,
      columns: model.getColumns(),
      selectionMode: SelectionMode.none,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import 'enter_list_model.dart';

class EnterList extends StatefulWidget {
  EnterListModel model;

  EnterList({required this.model, super.key});

  @override
  State<EnterList> createState() => _EnterListState();
}

class _EnterListState extends State<EnterList> {
  EnterListModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    model.search();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2<List<Enter>, int?>(
      streams: StreamTuple2<List<Enter>, int?>(model.list, model.selectedReqNo),
      initialData: InitialDataTuple2<List<Enter>, int?>([], null),
      builder:
          (BuildContext context, SnapshotTuple2<List<Enter>, int?> snapshots) {
        final list = snapshots.snapshot1.data!;
        final reqNo = snapshots.snapshot2.data;
        return Column(
          children: [
            searchField(list),
            SizedBox(height: 8),
            Expanded(child: enterList(list, reqNo)),
          ],
        );
      },
    );
  }

  Widget searchField(List<Enter> list) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: FilledButton(
                    style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      model.search();
                    },
                    child: Icon(Icons.refresh))),
            SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                controller: model.searchController,
                onEditingComplete: () {
                  model.search();
                },
                decoration: InputDecoration(
                    labelText: "차량 번호 검색",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        model.searchController.text = "";
                        model.search();
                      },
                    )),
              ),
            ),
          ],
        ),
        SizedBox(height:12),
        FormBuilderDateRangePicker(
          locale: Locale.fromSubtags(languageCode: "ko", countryCode: "KR"),
          saveText: "확인",
          pickerBuilder: (p0, p1) {
            return Dialog(child: SizedBox(width: 400, child: p1!));
          },
          initialEntryMode: DatePickerEntryMode.calendar,
          decoration: InputDecoration(labelText: "입고 일자",
            counterText: "총 ${list.length}건",
          ),
          textAlign: TextAlign.center,
          initialValue: model.dateRange.value,
          format: DateFormat("yyyy-MM-dd"),
          name: '기간',
          firstDate: DateTime.now().add(Duration(days: -365 * 5)),
          lastDate: DateTime.now(),
          onChanged: (value) {
            if (value == model.dateRange.value) {
              return;
            }
            model.dateRange.value = value ?? model.dateRange.value;
            model.search();
          },
        )
      ],
    );
  }

  Widget enterList(List<Enter> list, int? selectedReqNo) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text("검색결과가 없습니다.", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 2),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return listItem(list[index], selectedReqNo);
      },
    );
  }

  Widget listItem(Enter e, int? selectedReqNo) {
    return FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: selectedReqNo == e.reqNo
                ? Colors.blue
                : Colors.blueAccent.withOpacity(0.15),
            foregroundColor:
                selectedReqNo == e.reqNo ? Colors.white : Colors.black87,
            elevation: 0,
            minimumSize: Size(0, 40)),
        onPressed: () {
          setState(() {
            model.selectedReqNo.value = e.reqNo;
          });
        },
        child: Text(e.carLicenseNo, style: TextStyle()));
    // return Card(
    //   clipBehavior: Clip.antiAlias,
    //   child: InkWell(
    //     onTap: () {
    //       setState(() {
    //         selected = e;
    //       });
    //     },
    //     child: Container(
    //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    //         child: Text(e.carLicenseNo, style: TextStyle())),
    //   ),
    // );
  }
}

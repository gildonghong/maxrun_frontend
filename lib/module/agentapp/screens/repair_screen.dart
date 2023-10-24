import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/module/agentapp/screens/enter_detail_screen.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final searchController = TextEditingController();
  final selectedReqNo = BehaviorSubject<int?>.seeded(null);
  late final selected = Rx.combineLatest2(EnterService().list, selectedReqNo, (a, b) {
    return a.firstWhereOrNull((element) => element.reqNo==b);
  });

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  search() {
    EnterService().fetch(carLicenseNo: searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(12), width: 240, child: leftSection()),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: EnterDetailDetail(enter:selected),
          ))
        ],
      ),
    );
  }

  Widget leftSection() {
    return StreamBuilder<List<Enter>>(
      stream: EnterService().list,
      initialData: [],
      builder: (context, snapshot) {
        return Column(
          children: [
            searchField(snapshot.data!),
            SizedBox(height: 8),
            Expanded(child: workList(snapshot.data!)),
          ],
        );
      },
    );
  }

  Widget searchField(List<Enter> list) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 40,
            width: 40,
            child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  search();
                },
                child: Icon(Icons.refresh))),
        SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: searchController,
            onEditingComplete: () {
              search();
            },
            decoration: InputDecoration(
                labelText: "검색",
                counterText: "총 ${list.length}건",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.text = "";
                    search();
                  },
                )),
          ),
        ),
      ],
    );
  }

  Widget workList(List<Enter> list) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 2),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return listItem(list[index]);
      },
    );
  }

  Widget listItem(Enter e) {
    return FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: selected == e ? Colors.blue: Colors.grey[350],
            foregroundColor: selected == e ? Colors.white:Colors.black87,
            elevation: 0,
            minimumSize: Size(0, 40)),
        onPressed: () {
          setState(() {
            selectedReqNo.value = e.reqNo;
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

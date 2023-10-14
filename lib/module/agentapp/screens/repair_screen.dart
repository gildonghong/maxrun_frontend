import 'package:flutter/material.dart';
import 'package:photoapp/module/agentapp/screens/repair_screen_model.dart';
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

  final model = RepairScreenModel();

  @override
  void dispose() {
    super.dispose();
    model.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(12), width: 300, child: leftSection()),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: rightSection(),
          ))
        ],
      ),
    );
  }

  Widget leftSection() {
    return Column(
      children: [
        search(),
        SizedBox(height: 8),
        workList(),
      ],
    );
  }

  final searchController = TextEditingController();

  Widget search() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 40,
            width: 40,
            child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                child: Icon(Icons.refresh))),
        SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
                labelText: "검색",
                counterText: "총 1544건",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.text = "";
                  },
                )),
          ),
        ),
      ],
    );
  }

  Widget workList() {
    return SfDataGrid(
      headerRowHeight: 0,
      headerGridLinesVisibility: GridLinesVisibility.none,
      gridLinesVisibility: GridLinesVisibility.none,
      rowHeight: 32,
      source: model,
      columnWidthMode: ColumnWidthMode.fill,
      columns: model.getColumns(),
      selectionMode: SelectionMode.single,
    );
  }

  Widget rightSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: maker()),
            SizedBox(width: 8),
            Expanded(flex: 2, child: modelField())
          ],
        ),
        SizedBox(height: 12),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 1, child: etc()),
              SizedBox(width: 8),
              Expanded(flex: 2, child: memo()),
            ],
          ),
        ),
        SizedBox(height: 12),
        message(),
        SizedBox(height: 12),
        Expanded(flex: 2, child: photo())
      ],
    );
  }

  Widget message() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: () {},
            child: Text("케미컬 청구신청", style: TextStyle()),
          ),
          SizedBox(width: 12),
          FilledButton(
            onPressed: null,
            child: Text("작업완료 알림톡 신청완료. 2023.06.28", style: TextStyle()),
          ),
        ],
      ),
    );
  }

  Widget photo() {
    return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
            4,
            (index) => Image(
              fit: BoxFit.contain,
                image: AssetImage("assets/v$index.jpeg"))));
  }

  int? _selectedIndex;

  Future confirmDelete() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("삭제하시겠습니까?", style: TextStyle()),
        actions: [
          TextButton(
            child: Text("취소", style: TextStyle()),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text("삭제", style: TextStyle()),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

  Widget etc() {
    return InputDecorator(
      decoration: InputDecoration(labelText: "기타"),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        'Item $index',
                        style: TextStyle(
                            fontSize: 14,
                            color: _selectedIndex == index
                                ? Colors.red
                                : Colors.black87),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (await confirmDelete() == true) {}
                        },
                        icon: Icon(
                          Icons.close,
                          size: 16,
                        ),
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                suffixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                child: Text("추가", style: TextStyle()),
              ),
            )),
          )
        ],
      ),
    );
  }

  Widget memo() {
    return InputDecorator(
      decoration: InputDecoration(labelText: "메모"),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        'Item $index',
                        style: TextStyle(
                            fontSize: 14,
                            color: _selectedIndex == index
                                ? Colors.red
                                : Colors.black87),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (await confirmDelete() == true) {}
                        },
                        icon: Icon(
                          Icons.close,
                          size: 16,
                        ),
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                suffixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                child: Text("추가", style: TextStyle()),
              ),
            )),
          )
        ],
      ),
    );
  }

  Widget maker() {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: "제조사"),
      isExpanded: true,
      items: [],
      onChanged: (value) {},
    );
  }

  Widget modelField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: "모델"),
      isExpanded: true,
      items: [],
      onChanged: (value) {},
    );
  }
}

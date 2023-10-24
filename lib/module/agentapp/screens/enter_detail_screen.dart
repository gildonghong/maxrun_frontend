import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:rxdart/rxdart.dart';

class EnterDetailDetail extends StatefulWidget {
  Stream<Enter?> enter;

  EnterDetailDetail({required this.enter, super.key});

  @override
  State<EnterDetailDetail> createState() => _EnterDetailDetailState();
}

class _EnterDetailDetailState extends State<EnterDetailDetail> {
  Stream<Enter?> get enter => widget.enter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("EnterDetail.initState");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Enter?>(
        stream: widget.enter,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          return Column(
            children: [
              Expanded(flex: 2, child: photo(snapshot.data!)),
              SizedBox(height: 12),
              message(),
              SizedBox(height: 12),
              Expanded(
                flex: 1,
                child: memo(snapshot.data!),
              ),
            ],
          );
        });
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

  Widget photo(Enter enter) {
    final dir =
        Directory.fromRawPath(Uint8List.fromList(enter.clientPath.codeUnits));
    final files = (dir.existsSync() ? dir.listSync() : <FileSystemEntity>[])
        .where((element) {
      return ["jpg", "jpeg", "png"]
          .contains(element.path.toLowerCase().split('.').last);
    });

    if (files.isEmpty) {
      return Center(
          child: Text("디렉토리가 없거나 비어 있습니다.", style: TextStyle(fontSize: 20)));
    }

    return SingleChildScrollView(
      child: Wrap(
          alignment: WrapAlignment.start,
          clipBehavior: Clip.hardEdge,
          spacing: 8,
          runSpacing: 8,
          children: files
              .map((e) => Image(
                  width: 300,
                  fit: BoxFit.contain,
                  image: FileImage(File(e.path))))
              .toList()),
    );
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

  Widget memo(Enter enter) {
    return InputDecorator(
      decoration: InputDecoration(labelText: "메모"),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: enter.memo.length,
              itemBuilder: (BuildContext context, int index) {
                final memo = enter.memo[index];
                return Container(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        memo.regDate.yyyyMMdd,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        memo.text,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () async {
                          if (await confirmDelete() == true) {
                            EnterService().removeMemo(enter, memo);
                          }
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
            controller: memoTextController,
            onEditingComplete: () async {
              await EnterService().addMemo(enter, memoTextController.text);
              memoTextController.text = '';
            },
            decoration: InputDecoration(
                suffixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () async {
                  await EnterService().addMemo(enter, memoTextController.text);
                  memoTextController.text = '';
                },
                child: Text("추가", style: TextStyle()),
              ),
            )),
          )
        ],
      ),
    );
  }

  final memoTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    memoTextController.dispose();
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

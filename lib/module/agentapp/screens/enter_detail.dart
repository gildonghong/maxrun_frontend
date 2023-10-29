import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/model/photo.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:rxdart/rxdart.dart';

class EnterDetail extends StatefulWidget {
  Stream<Enter?> enter;

  EnterDetail({required this.enter, super.key});

  @override
  State<EnterDetail> createState() => _EnterDetailState();
}

class _EnterDetailState extends State<EnterDetail> {
  Stream<Enter?> get enter => widget.enter;
  late final photos = enter.asyncMap((event) async {
    return event == null ? <Photo>[] : await EnterService().getPhotos(event.reqNo);
  });


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Enter?>(
        stream: widget.enter,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }

          final enter = snapshot.data!;

          return Column(
            children: [
              Expanded(flex: 2, child: photoList(enter)),
              SizedBox(height: 12),
              message(enter),
              SizedBox(height: 12),
              Expanded(
                flex: 1,
                child: memo(enter),
              ),
            ],
          );
        });
  }

  Widget message(Enter enter) {
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
            onPressed: enter.maxrunTalkYn
                ? null
                : () async {
                    final result =
                        await EnterService().postChemicalRequestMessage(enter);
                    EasyLoading.showSuccess(
                        result ? "케미컬 청구를 신청했습니다." : "오류가 발생했습니다.");
                  },
            child: Text(enter.maxrunTalkYn ? "케미컬 청구신청 완료" : "케미컬 청구신청",
                style: TextStyle()),
          ),
          SizedBox(width: 12),
          FilledButton(
            onPressed: enter.customerTalkYn
                ? null
                : () async {
                    if (enter.ownerCpNo?.isNotEmpty != true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red[800]!,
                        content: Text("차주 연락처가 없습니다.", style: TextStyle()),
                      ));
                      return;
                    }
                    final result =
                        await EnterService().postRepairCompleteMessage(enter);
                    EasyLoading.showSuccess(
                        result ? "작업완료 알림톡을 발송했습니다." : "오류가 발생했습니다.");
                  },
            child: Text(enter.customerTalkYn ? "작업완료 알림톡 신청완료" : "작업완료 알림톡 발송",
                style: TextStyle()),
          ),
        ],
      ),
    );
  }

  Widget photoList(Enter enter) {
    return SingleChildScrollView(
      child: StreamBuilder<List<Photo>>(
        stream: photos,
        initialData: [],
        builder: (context, snapshot) {
          final photos = snapshot.data ?? [];
          return Wrap(
              alignment: WrapAlignment.start,
              clipBehavior: Clip.hardEdge,
              spacing: 8,
              runSpacing: 8,
              children: photos.map((e) => photo(e)).toList());
        },
      ),
    );
  }

  Widget photo(Photo photo) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Image(
            width: 300,
            fit: BoxFit.contain,
            image: NetworkImage(photo.serverFile)),
        Container(
            width: 300,
            color: Colors.white.withOpacity(0.5),
            child: Text(photo.clientFileName,
                textAlign: TextAlign.center, style: TextStyle())),
      ],
    );
  }

  int? _selectedIndex;

  Future confirmDelete() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("메모를 삭제하시겠습니까?", style: TextStyle()),
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
                        memo.regDate.format("yyyy-MM-dd HH:mm"),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        memo.memo,
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

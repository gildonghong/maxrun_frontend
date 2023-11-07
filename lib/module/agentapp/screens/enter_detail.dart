import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
  late StreamSubscription<Enter?> sub;

  Stream<Enter?> get enter => widget.enter;
  final formKey = GlobalKey<FormState>();
  final carLicenseNo = TextEditingController();
  late final photos = enter.asyncMap((event) async {
    return event == null
        ? <Photo>[]
        : await EnterService().getPhotos(event.reqNo, repairShopNo: event.repairShopNo);
  });

  @override
  void dispose() {
    super.dispose();
    memoTextController.dispose();
    carLicenseNo.dispose();
  }

  @override
  void initState() {
    super.initState();

    sub = enter.listen((event) {
      carLicenseNo.text = event?.carLicenseNo??"";
    });
  }



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
              bar(enter),
              SizedBox(height: 12),
              Expanded(flex: 2, child: photoList(enter)),
              SizedBox(height: 12),
              Expanded(
                flex: 1,
                child: memo(enter),
              ),
            ],
          );
        });
  }


  Widget bar(Enter enter) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 140,
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: carLicenseNo,
                  onChanged: (value) {
                    enter.carLicenseNo = value;
                  },
                  validator: (value) {
                    if (value?.trim().isNotEmpty != true) {
                      return "차량번호를 입력하세요";
                    }
                  },
                  decoration: InputDecoration(labelText: "차량번호"),
                ),
              )),
          SizedBox(width: 8),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                await EnterService().enterIn(
                    reqNo: enter.reqNo, carLicenseNo: enter.carLicenseNo);
                EasyLoading.showSuccess("차량번호를 저장했습니다.");
              }
            },
            child: Text("저장", style: TextStyle()),
          ),
          SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[800]),
            onPressed: () async {
              deleteDialog(enter);
            },
            child: Text("삭제", style: TextStyle()),
          ),
          Spacer(),
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

  deleteDialog(Enter enter) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("입고기록을 삭제하시겠습니까?", style: TextStyle()),
        actions: [
          TextButton(
            child: Text("취소", style: TextStyle()),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text("삭제", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );

    if (confirm == true) {
      await EnterService().delete(enter.reqNo);
      EasyLoading.showSuccess("입고기록을 삭제했습니다.");
    }
  }

  Widget photoList(Enter enter) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // alignment: Alignment.center,
      child: StreamBuilder<List<Photo>>(
          stream: photos,
          initialData: [],
        builder: (context, snapshot) {
          final photos = snapshot.data ?? [];

          if( photos.isEmpty) {
            return Center(child: Text(("등록된 사진이 없습니다"), style:TextStyle(fontSize: 20)));
          }

          return SingleChildScrollView(
            child: Wrap(
                alignment: WrapAlignment.start,
                clipBehavior: Clip.hardEdge,
                spacing: 8,
                runSpacing: 8,
                children: photos.map((e) => photo(e)).toList()),
          );
        }
      ),
    );
  }

  Widget photo(Photo photo) {
    return InkWell(
      onTap: () {
        photoDialog(photo.serverFile);
      },
      child: Container(
        color: Colors.black,
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: photo.serverFile,
                cacheKey: "${photo.serverFile}600",
                maxWidthDiskCache: 600,
                maxHeightDiskCache: 600,
                memCacheWidth: 600,
                memCacheHeight: 600,
                  fit: BoxFit.contain,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.image_not_supported_rounded),),
            ),
            Container(
              width: 300,
              color: Colors.black.withOpacity(0.5),
              child: Text(photo.clientFileName,
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white), softWrap: true,),
            ),
          ],
        ),
      ),
    );
  }

  photoDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
            child: CachedNetworkImage(
              cacheKey: "${url}1920",
              maxWidthDiskCache: 1920,
              maxHeightDiskCache: 1920,
              memCacheWidth: 1920,
              memCacheHeight: 1920,
              imageUrl: url,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.image_not_supported_rounded),
            )),
      ),
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

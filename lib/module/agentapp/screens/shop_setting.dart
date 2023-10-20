import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/service/api_service.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:photoapp/ui/always_disabled_focus_node.dart';
import 'package:provider/provider.dart';

class ShopSettingScreen extends StatefulWidget {
  ShopSettingScreen({super.key});

  @override
  State<ShopSettingScreen> createState() => _ShopSettingScreenState();
}

class _ShopSettingScreenState extends State<ShopSettingScreen>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  late final photoSavePathController = TextEditingController();
  late final maxrunChargerCpNoController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final shop = context.read<Shop?>();
    photoSavePathController.text = shop?.photoSavePath??"";
    maxrunChargerCpNoController.text = shop?.maxrunChargerCpNo??"";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: InputDecorator(
          decoration: InputDecoration(
              labelText: "정비소 설정",
              isDense: true,
              contentPadding: EdgeInsets.all(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              SizedBox(width: 200, child: cpno()),
              SizedBox(height: 12),
              photoSavePath(),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      await ShopService().modify(photoSavePathController.text,
                          maxrunChargerCpNoController.text);
                      EasyLoading.showSuccess("저장했습니다.");
                    }
                  },
                  child: Text("저장", style: TextStyle()),
                ),
              )
            ],
          ),
        ));
  }

  Widget cpno() {
    return TextFormField(
      // initialValue: maxrunChargerCpNo,
      controller: maxrunChargerCpNoController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
      decoration: InputDecoration(labelText: "담당자 휴대전화"),
      validator: (value) {
        if (value?.isNotEmpty != true) {
          return "담당자 휴대전화번호를 입력해 주세요.";
        }
      },
      // onChanged: (value) {
      //   maxrunChargerCpNo = value;
      // },
    );
  }

  var filePickerOpened = false;

  Widget photoSavePath() {
    return TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      enableInteractiveSelection: false, // will disable paste operation
      controller: photoSavePathController,
      decoration: InputDecoration(
          label: Text(
            "사진 저장 폴더",
            style: TextStyle(),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero, minimumSize: Size(56, 44)),
              onPressed: filePickerOpened
                  ? null
                  : () async {
                setState(() {
                  filePickerOpened = true;
                });
                photoSavePathController.text =
                    await FilePicker.platform.getDirectoryPath() ??
                        photoSavePathController.text;
                setState(() {
                  filePickerOpened = false;
                });
              },
              child: Text("찾기", style: TextStyle()),
            ),
          )),
    );
  }
}


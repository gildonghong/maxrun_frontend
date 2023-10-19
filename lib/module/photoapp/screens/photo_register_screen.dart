import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/service/car_care_service.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';

class PhotoRegisterScreen extends StatefulWidget {
  List<XFile> files;

  Department department;

  PhotoRegisterScreen(
      {required this.files, super.key, required this.department});

  @override
  State<PhotoRegisterScreen> createState() => _PhotoRegisterScreenState();
}

class _PhotoRegisterScreenState extends State<PhotoRegisterScreen> {
  final formKey = GlobalKey<FormState>();

  int? reqNo;
  late int departmentNo = widget.department.departmentNo;
  String? carLicenseNo;
  String? ownerName;
  String? ownerCpNo;
  String? paymentType;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: departmentField(),
          actions: [
            SizedBox(width: 48),
          ],
        ),
        // floatingActionButton: home(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Column(
            children: [
              images(),
              SizedBox(height: 24),
              carLicenseNoField(),
              SizedBox(height: 24),
              owner(),
              SizedBox(height: 24),
              Visibility(
                visible: UserService().isManager,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: payment(),
                ),
              ),
              saveButton(),
              // SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  submit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final reqNo = await CarCareService().enterIn(carLicenseNo!, ownerName, ownerCpNo!, paymentType);
    await CarCareService().repair(reqNo, departmentNo, widget.files);

    EasyLoading.showSuccess("등록했습니다.");
    Navigator.of(context).pop(true);
  }

  Widget saveButton() {
    return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: submit,
          child: Text("저장", style: TextStyle(fontSize: 16)),
        ));
  }

  Widget payment() {
    return FormBuilderChoiceChip(
        decoration: InputDecoration(labelText: "수리구분"),
        spacing: 8,
        alignment: WrapAlignment.center,
        initialValue: null,
        name: "payment",
        validator: (value) {
          if (UserService().isManager && value == null) {
            return "수리구분을 선택하세요.";
          }
        },
        onChanged: (value) {
          setState(() {
            paymentType = value;
          });
        },
        options: ["보험", "보증", "일반"]
            .map((e) => FormBuilderChipOption(
                  value: e,
                  child: Text(e, style: TextStyle(color: e==paymentType ? Colors.white:Colors.black87)),
                ))
            .toList());
  }

  Widget carLicenseNoField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(labelText: "차량 번호 및 차종"),
      validator: (value) {
        if (value?.isNotEmpty != true) {
          return "차량 번호 및 차종을 입력하세요";
        }
      },
      onChanged: (value) {
        carLicenseNo = value;
      },
    );
  }

  Widget owner() {
    return Row(
      children: [
        Visibility(
          visible: UserService().isManager,
          child: Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "차주 성명"),
                  validator: (value) {
                    if (UserService().isManager && value?.isNotEmpty != true) {
                      return "차주 성명을 입력하세요.";
                    }
                  },
                  onChanged: (value) {
                    ownerName = value;
                  },
                ),
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "차주 연락처"),
              validator: (value) {
    if (value?.isNotEmpty != true) {
                  return "차주 연락처를 입력하세요";
                }
              },
              onChanged: (value) {
                ownerCpNo = value;
              },
            )),
      ],
    );
  }

  Widget departmentField() {
    final departments = context.watch<List<Department>>();
    return DropdownButtonFormField<int?>(
      // decoration: InputDecoration(labelText: "부서"),
      value: departmentNo,
      items: departments
          .map((e) => DropdownMenuItem(
                value: e.departmentNo,
                child: Text(e.departmentName, style: TextStyle()),
              ))
          .toList(),
      onChanged: (int? value) {
        departmentNo = value ?? departmentNo;
      },
    );
  }

  Widget images() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "부서 사진",
        contentPadding:
            EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8,
            children: widget.files
                .map((e) => Image.file(height: 220, File(e.path)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget home() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.home),
    );
  }
}

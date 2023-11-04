/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:photoapp/ui/always_disabled_focus_node.dart';

class PhotoRegisterScreen extends StatefulWidget {
  CarCare? carCare;

  PhotoRegisterScreen(
      {this.carCare});

  @override
  State<PhotoRegisterScreen> createState() => _PhotoRegisterScreenState();
}

class _PhotoRegisterScreenState extends State<PhotoRegisterScreen> {
  final formKey = GlobalKey<FormState>();

  late int? reqNo = widget.carCare?.reqNo;
  late int departmentNo = widget.department.departmentNo;
  late String? carLicenseNo = widget.carCare?.carLicenseNo;
  late String? ownerName = widget.carCare?.ownerName;
  late String? ownerCpNo = widget.carCare?.ownerCpNo;
  late String? paymentType = widget.carCare?.paymentType;

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
                  child: repairType(),
                ),
              ),
              // SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }



  Widget repairType() {
    return FormBuilderChoiceChip(
        decoration: InputDecoration(labelText: "수리구분"),
        spacing: 8,
        alignment: WrapAlignment.center,
        initialValue: widget.carCare?.paymentType,
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
                  child: Text(e,
                      style: TextStyle(
                          color: e == paymentType
                              ? Colors.white
                              : Colors.black87)),
                ))
            .toList());
  }

  Widget carLicenseNoField() {
    return TextFormField(
      initialValue: widget.carCare?.carLicenseNo ?? "",
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "차량 번호",
      ),
      validator: (value) {
        if (value?.isNotEmpty != true) {
          return "차량 번호를 입력하세요";
        }
      },
      onChanged: (value) {
        carLicenseNo = value;
      },
    );
  }

  Widget owner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: UserService().isManager,
          child: Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextFormField(
                initialValue: widget.carCare?.ownerName ?? "",
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
              initialValue: widget.carCare?.ownerCpNo ?? "",
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
    return TextFormField(
      focusNode: AlwaysDisabledFocusNode(),
      textAlign: TextAlign.center,
      initialValue: widget.department.departmentName,
    );
    // return DropdownButtonFormField<int?>(
    //   // decoration: InputDecoration(labelText: "부서"),
    //   value: departmentNo,
    //   items: departments
    //       .map((e) => DropdownMenuItem(
    //             value: e.departmentNo,
    //             child: Text(e.departmentName, style: TextStyle()),
    //           ))
    //       .toList(),
    //   onChanged: (int? value) {
    //     departmentNo = value ?? departmentNo;
    //   },
    // );
  }

  Widget images() {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        label: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("부서 사진", style: TextStyle()),
        ),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6))),
        margin: EdgeInsets.only(top: 6, left: 5,right: 5,bottom: 4),
        clipBehavior: Clip.antiAlias,
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
*/

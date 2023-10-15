import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  List<XFile> files;

  RegisterScreen({required this.files, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: department(),
        actions: [SizedBox(width:48),],
      ),
      // floatingActionButton: home(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Column(
          children: [
            images(),
            SizedBox(height: 24),
            carNumber(),
            SizedBox(height: 24),
            owner(),
            SizedBox(height: 24),
            payment(),
            SizedBox(height: 12),
            saveButton(),
            // SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          child: Text("저장", style: TextStyle(fontSize: 20)),
        ));
  }

  Widget payment() {
    return FormBuilderChoiceChip(
        selectedColor: Colors.blueAccent,
        decoration: InputDecoration(labelText: "결제 방식"),
        spacing: 8,
        alignment: WrapAlignment.center,
        initialValue: "일반",
        name: "payment",
        options: ["일반", "보험", "보증"]
            .map((e) => FormBuilderChipOption(
                  value: e,
                  child: Text(e, style: TextStyle()),
                ))
            .toList());
  }

  Widget carNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: "차량 번호 및 차종"),
    );
  }

  Widget owner() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: TextFormField(
              decoration: InputDecoration(labelText: "차주 성명"),
            )),
        SizedBox(width: 8),
        Expanded(
            flex: 3,
            child: TextFormField(
              decoration: InputDecoration(labelText: "차주 연락처"),
            )),
      ],
    );
  }

  Widget department() {
    return DropdownButtonFormField(
      items: [
        "0.작업지시서",
        "1.최초",
        "2.판금",
        "3.하체",
        "4.도장",
        "5.완료",
        "6.서류",
        "7.기타1",
        "8.기타2",
        "9.기타3"
      ]
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: TextStyle()),
              ))
          .toList(),
      onChanged: (String? value) {},
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

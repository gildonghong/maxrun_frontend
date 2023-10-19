import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:provider/provider.dart';

import 'department_form.dart';

class DepartmentSetting extends StatefulWidget {
  const DepartmentSetting({super.key});

  @override
  State<DepartmentSetting> createState() => _DepartmentSettingState();
}

class _DepartmentSettingState extends State<DepartmentSetting> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
          labelText: "부서관리", contentPadding: EdgeInsets.all(16)),
      child: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: list(),
          ),
          SizedBox(height: 12),
          addField()
        ],
      ),
    );
  }

  final ScrollController scrollController = ScrollController();

  Widget list() {
    final departments = context.watch<List<Department>>();
    return ListView.separated(
      controller: scrollController,
      itemCount: departments.length,
      itemBuilder: (BuildContext context, int index) {
        return DepartmentListForm(department: departments[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 8);
      },
    );
  }

  final departmentNameController = TextEditingController();
  final addFormKey = GlobalKey<FormState>();

  Widget addField() {
    return Form(
      key: addFormKey,
      child: TextFormField(
        onFieldSubmitted: (value) {
          submitAdd();
        },
        controller: departmentNameController,
        validator: (value) {
          if (value?.isNotEmpty != true) {
            return "부서명을 입력해주세요.";
          }
        },
        decoration: InputDecoration(
            suffixIcon: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FilledButton(
            style: FilledButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: Size(56, 44)),
            onPressed: submitAdd,
            child: Text("추가", style: TextStyle()),
          ),
        )),
      ),
    );
  }

  submitAdd() async {
    if (DepartmentService().departments.value.firstWhereOrNull((element) =>
            element.departmentName == departmentNameController.text) !=
        null) {
      EasyLoading.showError("부서명 중복입니다.");
      return;
    }

    if (addFormKey.currentState?.validate() == true) {
      await DepartmentService().add(departmentNameController.text);
      departmentNameController.text = "";
      await Future.delayed(Duration(milliseconds: 10));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

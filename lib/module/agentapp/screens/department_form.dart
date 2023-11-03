import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/service/department_service.dart';

class DepartmentListForm extends StatefulWidget {
  Department department;

  DepartmentListForm({required this.department, super.key});

  @override
  State<DepartmentListForm> createState() => _DepartmentListFormState();
}

class _DepartmentListFormState extends State<DepartmentListForm> {
  Department get department => widget.department;
  late String departmentName = department.departmentName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: nameField()),
        SizedBox(width: 8),
        saveButton(),
        SizedBox(width: 8),
        deleteButton(),
        // SizedBox(width: 8),
        // FilledButton(
        //   onPressed: () async {
        //     // DepartmentService().delete(d);
        //   },
        //   child: Text("삭제", style: TextStyle()),
        //   style: FilledButton.styleFrom(
        //       padding: EdgeInsets.zero,
        //       minimumSize: Size(56, 44),
        //       backgroundColor: Colors.red[900]!),
        // )
      ],
    );
  }

  Widget nameField() {
    return TextFormField(
      initialValue: departmentName,
      decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
      onChanged: (value) {
        setState(() {
          departmentName = value;
        });
      },
    );
  }

  Widget saveButton() {
    return FilledButton(
      onPressed: departmentName == department.departmentName
          ? null
          : () async {
              await DepartmentService()
                  .modify(department.departmentNo, departmentName);
              EasyLoading.showSuccess("부서명을 수정했습니다.");
            },
      child: Text("저장", style: TextStyle()),
      style: FilledButton.styleFrom(
          padding: EdgeInsets.zero, minimumSize: Size(56, 44)),
    );
  }

  Widget deleteButton() {
    return FilledButton(
      onPressed: () async {
        await showDeleteDialog();
      },
      child: Text("삭제", style: TextStyle()),
      style: FilledButton.styleFrom(
          padding: EdgeInsets.zero, minimumSize: Size(56, 44)),
    );
  }

  showDeleteDialog() async {
    final confirm = await showDialog(
        context: context,
        builder: (context) {
        return  AlertDialog(
            title: Text("부서를 삭제하시겠습니까?", style: TextStyle()),
            actions: [
              TextButton(
                child: Text("취소", style: TextStyle()),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text("삭제", style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if(confirm) {
      await DepartmentService().delete(department.departmentNo);
      EasyLoading.showSuccess("부서를 삭제했습니다.");
    }
  }
}

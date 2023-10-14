import 'package:flutter/material.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/worker.dart';
import 'package:photoapp/service/department_service.dart';

class WorkerGridForm{
  Worker worker;
  late Widget department;
  late Widget position;
  late Widget name;
  late Widget phone;
  late Widget pw;
  late Widget workingPhoto;
  late Widget status;

  WorkerGridForm({
    required this.worker,
  }){
    final textStyle = TextStyle(fontSize: 14, color: Colors.black87);
    department = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: StreamBuilder<List<Department>>(
          stream: DepartmentService().list,
          initialData: [],
          builder: (context, snapshot) {
            return DropdownButtonFormField<int>(
              style: textStyle,
              value: worker.departmentNo,
              items: snapshot.data!
                  .map((e) => DropdownMenuItem<int>(
                value: e.departmentNo,
                child: Text(e.name, style: TextStyle()),
              ))
                  .toList(),
              onChanged: (value) {
                worker.departmentNo = value ?? worker.departmentNo;
              },
            );
          }),
    );

    position = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<String>(
        style: textStyle,
        value: worker.position,
        items: ["관리자","공장장","부장","반장","팀장","반장","사원","작업폰"]
            .map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: TextStyle()),
        ))
            .toList(),
        onChanged: (value) {
          worker.position = value ?? worker.position;
        },
      ),
    );

    name =Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        style: textStyle,
        initialValue: worker.wokerName,
        onChanged:(value) {
        worker.wokerName = value;
      },),
    );

    phone =Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        style: textStyle,
        initialValue: "",
        onChanged:(value) {
        // worker.wokerName = value;
      },),
    );

    pw =Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        style: textStyle,
        obscureText: true,
        initialValue: "",
        onChanged:(value) {
        // worker.wokerName = value;
      },),
    );

    workingPhoto = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<String>(
        style: textStyle,
        value: "사용",
        items: ["사용","미사용"]
            .map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: TextStyle()),
        ))
            .toList(),
        onChanged: (value) {
        },
      ),
    );

    status = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<String>(
        style: textStyle,
        value: "사용",
        items: ["사용","미사용"]
            .map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: TextStyle()),
        ))
            .toList(),
        onChanged: (value) {
        },
      ),
    );
  }

  dispose(){

  }
}
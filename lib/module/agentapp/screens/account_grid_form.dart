import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/account.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/service/account_service.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/ui/always_disabled_focus_node.dart';
import 'package:rxdart/rxdart.dart';

class AccountGridForm {
  Account account;
  late Account edited;
  late Widget department;
  late Widget position;
  late Widget name;
  late Widget phone;
  late Widget loginId;
  late Widget pw;

  // late Widget workingPhoto;
  late Widget status;
  late Widget save;

  final changed = BehaviorSubject<bool>.seeded(false);
  final positionFocus = FocusNode();
  final nameFocus = FocusNode();
  final cpNoFocus = FocusNode();
  final loginIdFocus = FocusNode();
  final pwdFocus = FocusNode();

  AccountGridForm({
    required this.account, required List<Department> departments,
  }) {
    edited = Account.fromJson(account.toJson());
    changed.value = account.workerNo == 0;

    final textStyle = TextStyle(fontSize: 14, color: Colors.black87);
    department = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<int>(
        style: textStyle,
        value: account.departmentNo,
        items: departments
            .map((e) => DropdownMenuItem<int>(
                  value: e.departmentNo,
                  child: Text(e.departmentName, style: TextStyle()),
                ))
            .toList(),
        onChanged: (value) {
          edited.departmentNo = value ?? account.departmentNo;
          checkIfChanged();
        },
      ),
    );

    position = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        focusNode: positionFocus,
        style: textStyle,
        initialValue: account.position,
        onChanged: (value) {
          edited.position = value;
          checkIfChanged();
        },
      ),
    );

    name = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        focusNode: nameFocus,
        style: textStyle,
        initialValue: account.workerName,
        onChanged: (value) {
          edited.workerName = value;
          checkIfChanged();
        },
      ),
    );

    phone = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        focusNode: cpNoFocus,
        style: textStyle,
        initialValue: account.cpNo,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          edited.cpNo = value;
          checkIfChanged();
        },
      ),
    );

    loginId = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        style: textStyle,
        focusNode: account.workerNo == 0 ? loginIdFocus : AlwaysDisabledFocusNode(),
        initialValue: account.loginId,
        onChanged: (value) {
          edited.loginId = value;
          checkIfChanged();
          // worker.wokerName = value;
        },
      ),
    );

    pw = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        style: textStyle,
        focusNode: pwdFocus,
        obscureText: true,
        initialValue: "",
        onChanged: (value) {
          edited.pwd = value;
          checkIfChanged();
          // worker.wokerName = value;
        },
      ),
    );

    // workingPhoto = Container(
    //   alignment: Alignment.center,
    //   padding: EdgeInsets.symmetric(horizontal: 2),
    //   child: DropdownButtonFormField<String>(
    //     style: textStyle,
    //     value: "사용",
    //     items: ["사용", "미사용"]
    //         .map((e) => DropdownMenuItem<String>(
    //               value: e,
    //               child: Text(e, style: TextStyle()),
    //             ))
    //         .toList(),
    //     onChanged: (value) {
    //       edited.
    //     },
    //   ),
    // );

    status = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<String>(
        style: textStyle,
        value: "사용중",
        items: ["사용중", "미사용"]
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e, style: TextStyle()),
                ))
            .toList(),
        onChanged: (value) {
          edited.status = value ?? account.status;
          checkIfChanged();
        },
      ),
    );

    save = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: StreamBuilder<bool>(
          stream: changed,
          initialData: false,
          builder: (context, snapshot) {
            return FilledButton(
              onPressed: snapshot.data == true ? submit : null,
              child: Text("저장", style: TextStyle()),
            );
          }),
    );
  }

  submit() async {
    if (edited.position.trim().isEmpty) {
      EasyLoading.showError("직책을 입력하세요");
      positionFocus.requestFocus();
      return;
    }
    if (edited.workerName.trim().isEmpty) {
      EasyLoading.showError("성명을 입력하세요");
      nameFocus.requestFocus();
      return;
    }
    if (edited.cpNo?.trim().isNotEmpty!=true) {
      EasyLoading.showError("휴대폰을 입력하세요");
      cpNoFocus.requestFocus();
      return;
    }
    if (edited.loginId.trim().isEmpty) {
      EasyLoading.showError("아이디를 입력하세요");
      loginIdFocus.requestFocus();
      return;
    }
    if (edited.workerNo == 0 && edited.pwd?.isNotEmpty != true) {
      EasyLoading.showError("비밀번호를 입력하세요");
      pwdFocus.requestFocus();
      return;
    }

    if (edited.workerNo == 0) {
      await AccountService().create(edited);
    } else {
      await AccountService().update(edited);
    }
    EasyLoading.showSuccess("계정을 수정했습니다.");
  }

  checkIfChanged() {
    changed.value =
        account.workerNo == 0 || jsonEncode(account) != jsonEncode(edited);
  }

  dispose() {
    changed.close();
  }
}

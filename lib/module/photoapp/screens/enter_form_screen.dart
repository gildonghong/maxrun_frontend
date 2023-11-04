import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/enter.dart';
import 'package:photoapp/module/photoapp/photo_app.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';

class EnterFormScreen extends StatefulWidget {
  EnterFormScreen({super.key, this.carCare});

  CarCare? carCare;


  @override
  State<EnterFormScreen> createState() => _EnterRegisterPopupState();
}

class _EnterRegisterPopupState extends State<EnterFormScreen> {
  CarCare? get car => widget.carCare;
  final formKey = GlobalKey<FormState>();

  late int? reqNo = car?.reqNo;
  late String? carLicenseNo = car?.carLicenseNo;
  late String? ownerName = car?.ownerName;
  late String? ownerCpNo = car?.ownerCpNo;
  late String? paymentType = car?.paymentType;


  @override
  void initState() {
    super.initState();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: colorPrimary,
    //   statusBarBrightness: Brightness.light,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          car != null ? "입고 내역 수정" : "입고 등록", style: TextStyle()),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              carLicenseNoField(),
              SizedBox(height: 12),
              ownerNameField(),
              SizedBox(height: 12),
              ownerCpNoField(),
              SizedBox(height: 12),
              Visibility(
                visible: UserService().isManager,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: repairType(),
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

  Future submit() async {
    if (formKey.currentState?.validate() != true) {
      return null;
    }

    final nav = Navigator.of(context);

    final enter = await EnterService().enterIn(
        reqNo: reqNo,
        carLicenseNo: carLicenseNo!,
        ownerName: ownerName,
        ownerCpNo: ownerCpNo!,
        paymentType: paymentType);

    EasyLoading.showSuccess(reqNo==null?"입고 등록을 완료했습니다.":"입고 내역을 수정했습니다.");

    nav.pop(enter);
  }

  Widget saveButton() {
    return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: submit,
          child: Text(reqNo==null?"등록":"수정", style: TextStyle(fontSize: 16)),
        ));
  }

  Widget repairType() {
    return FormBuilderChoiceChip(
        decoration: InputDecoration(labelText: "수리구분"),
        spacing: 8,
        alignment: WrapAlignment.center,
        initialValue: car?.paymentType,
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
            .map((e) =>
            FormBuilderChipOption(
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
      initialValue: car?.carLicenseNo ?? "",
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

  Widget ownerNameField() {
    return TextFormField(
      initialValue: car?.ownerName ?? "",
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
    );
  }

  Widget ownerCpNoField() {
    return TextFormField(
      initialValue: car?.ownerCpNo ?? "",
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: "차주 연락처"),
      validator: (value) {
        if (value?.isNotEmpty != true) {
          return "차주 연락처를 입력하세요";
        }
      },
      onChanged: (value) {
        ownerCpNo = value;
      },
    );
  }


}

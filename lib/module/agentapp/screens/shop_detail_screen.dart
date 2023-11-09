import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:rxdart/rxdart.dart';

class ShopDetailScreen extends StatefulWidget {
  BehaviorSubject<Shop?> shop;

  ShopDetailScreen({required this.shop, super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final shopName = TextEditingController();
  final ceoName = TextEditingController();
  final businessNo = TextEditingController();
  final repairShopTelNo = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var useYn = "Y";

  @override
  void initState() {
    super.initState();

    widget.shop.listen((value) {
      shopName.text = value?.repairShopName ?? "";
      ceoName.text = value?.ceoName ?? "";
      businessNo.text = value?.businessNo ?? "";
      repairShopTelNo.text = value?.repairShopTelNo ?? "";
      useYn = value?.useYn ?? "Y";
    });
  }

  @override
  void dispose() {
    shopName.dispose();
    ceoName.dispose();
    businessNo.dispose();
    repairShopTelNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: StreamBuilder<Shop?>(
          stream: widget.shop,
          initialData: null,
          builder: (context, snapshot) {
            final shop = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(shop == null ? "공업사 신규 등록" : "공업사 정보 수정",
                        style: TextStyle(fontSize: 24))),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(labelText: "공업사명"),
                  controller: shopName,
                  validator: (value) {
                    if (value?.trim().isNotEmpty != true) {
                      return "공업사명을 입력하세요.";
                    }
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: "대표자명"),
                  controller: ceoName,
                  validator: (value) {
                    if (value?.trim().isNotEmpty != true) {
                      return "대표자명을 입력하세요.";
                    }
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: "사업자등록번호"),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
                  keyboardType: TextInputType.number,
                  controller: businessNo,
                  validator: (value) {
                    if (value?.trim().isNotEmpty != true) {
                      return "사업자등록번호를 입력하세요.";
                    }
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: "대표번호"),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
                  keyboardType: TextInputType.number,
                  controller: repairShopTelNo,
                  validator: (value) {
                    if (value?.trim().isNotEmpty != true) {
                      return "대표번호를 입력하세요.";
                    }
                  },
                ),
                SizedBox(height: 12),
                DropdownButtonFormField(
                  value: useYn,
                  items: [
                  DropdownMenuItem(
                    value: "Y",
                    child: Text("사용", style:TextStyle()),),
                  DropdownMenuItem(
                    value: "N",
                    child: Text("미사용", style:TextStyle()),),
                ], onChanged: (value) {
                    setState(() {
                      useYn = value ?? useYn;
                    });
                },),
                SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }

                    await ShopService().hqSave(
                      repairShopNo: shop?.repairShopNo,
                      repairShopName: shopName.text,
                      ceoName: ceoName.text,
                      businessNo: businessNo.text,
                      repairShopTelNo: repairShopTelNo.text,
                      useYn: useYn,
                    );

                    EasyLoading.showSuccess(shop?.repairShopNo != null
                        ? "공업사를 정보를 수정 했습니다."
                        : "새로운 공업사를 등록 했습니다.");
                  },
                  child: Text(shop?.repairShopNo != null ? "수정" : "등록",
                      style: TextStyle()),
                )
              ],
            );
          }),
    );
  }
}

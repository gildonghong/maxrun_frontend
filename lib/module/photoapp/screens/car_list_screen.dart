import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/photo_app.dart';
import 'package:photoapp/module/photoapp/screens/enter_detail_screen.dart';
import 'package:photoapp/module/photoapp/screens/enter_form_screen.dart';
import 'package:photoapp/module/photoapp/screens/photo_register_screen.dart';
import 'package:photoapp/service/car_care_service.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:collection/collection.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final searchController = TextEditingController();
  Department? department;

  @override
  void initState() {
    super.initState();
    CarCareService().fetch();

    final departments = context.read<List<Department>>();

    department = departments
        .firstWhereOrNull((element) => element.departmentName == '신규등록');
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: user.managerYn == "Y" ? registerButton() : null,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: showAccountPopup,
                    icon: Icon(
                      Icons.account_circle_rounded,
                      size: 36,
                      color: colorPrimary,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {
                        CarCareService().fetch(searchController.text);
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "차량 번호 검색",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FilledButton(
                            style: FilledButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
                            child: Icon(
                              Icons.search,
                              size: 24,
                            ),
                            onPressed: () {
                              CarCareService().fetch(searchController.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(child: list()),
          ],
        ),
      ),
    );
  }

  showAccountPopup() {
    final user = context.read<User>();
    final department = context.read<Department?>();
    final shop = context.read<Shop?>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(shop?.repairShopName ?? "",
                style: TextStyle(fontSize: 16))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text("${department?.departmentName??""} ${user.workerName} 님",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  UserService().logout();
                },
                child: Text("로그아웃", style: TextStyle()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FloatingActionButton.extended(
        onPressed: () {
          // showPickerOptionDialog();
          openRegisterDialog();
        },
        label: Row(
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 48,
            ),
            SizedBox(height: 8),
            Text("등록", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  final pickerOptionFormKey = GlobalKey<FormState>();
  var images = <XFile>[];


  openRegisterDialog() async {
    final nav = Navigator.of(context);

    final result = await nav.push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return EnterFormScreen();
      },
    ));

    if (result is CarCare) {
      nav.push(MaterialPageRoute(
        builder: (context) => EnterDetailScreen(result),
      ));
    }
  }



  Widget list() {
    return RefreshIndicator(
      onRefresh: () async {
        await CarCareService().fetch(searchController.text);
        return;
      },
      child: StreamBuilder<List<CarCare>>(
          stream: CarCareService().list,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text("검색결과가 없습니다.", style: TextStyle(fontSize: 20)),
              );
            }

            return GroupedListView.grid(
              shrinkWrap: false,
              padding: EdgeInsets.symmetric(horizontal: 12),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              itemsAspectRatio: 0.7,
              items: snapshot.data!,
              itemGrouper: (CarCare i) => i.yyyyMm.replaceAll("-", "년 ") + "월",
              headerBuilder: (context, String month) => Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(month,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900))),
              gridItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                      CarCare item, int itemIndexInOriginalList) =>
                  listItem(item),
              crossAxisCount: 2,
            );
          }),
    );
  }

  Widget listItem(CarCare item) {
    final user = context.watch<User>();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EnterDetailScreen(item,),
        ));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.fileSavedPath ?? "",
              fit: BoxFit.cover,
              headers: {
                "Authorization": "Bearer ${user.uAtoken}",
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text(
                      "${item.ownerName ?? ''} ${item.formattedOwnerCpNo ?? ''}"
                          .trim(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text(item.carLicenseNo ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget departmentField() {
    final departments = context.watch<List<Department>>();

    return DropdownButtonFormField<Department?>(
      decoration: InputDecoration(labelText: "부서"),
      value: department,
      validator: (value) {
        if (department == null) {
          return "부서를 선택하세요";
        }
      },
      items: [
        DropdownMenuItem(
          value: null,
          child: Text("부서 선택", style: TextStyle()),
        ),
        ...departments.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e.departmentName, style: TextStyle()),
            ))
      ],
      onChanged: (Department? value) {
        department = value;
      },
    );
  }
}

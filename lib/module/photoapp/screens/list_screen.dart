import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/module/photoapp/screens/photo_register_screen.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: registerButton(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "차량 번호 검색",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: SizedBox(width: 40),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(48, 48)),
                    onPressed: UserService().logout,
                    child: Icon(Icons.logout_outlined),
                  )
                ],
              ),
            ),
            Expanded(child: list()),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FloatingActionButton.large(
        shape: CircleBorder(),
        // foregroundColor: Colors.white,
        // backgroundColor: Colors.red,
        onPressed: () {
          showPickerOptionDialog();
        },
        child: Icon(
          Icons.edit_note_rounded,
          size: 64,
        ),
      ),
    );
  }

  final pickerOptionFormKey = GlobalKey<FormState>();
  var images =<XFile>[];

  pushRegisterScreen() async {
    if(images.isEmpty) {
      return;
    }
      final registered = await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return PhotoRegisterScreen(
              department: department!, files: images);
        },
      ));

    if( registered) {
      //화면 갱신해야함
    }
  }

  showPickerOptionDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("차량 신규 등록", style: TextStyle()),
              content: Form(
                key: pickerOptionFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    departmentField(),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FilledButton.icon(
                  onPressed: () async {
                    if(pickerOptionFormKey.currentState?.validate() != true) {
                      return;
                    }

                    images = await picker.pickMultiImage();
                    pushRegisterScreen();

                  },
                  icon: Icon(Icons.photo_library),
                  label: Text("앨범", style: TextStyle()),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    if(pickerOptionFormKey.currentState?.validate() != true) {
                      return;
                    }
                    final XFile? photo =
                        await picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      images = [photo];
                      pushRegisterScreen();
                    }
                  },
                  icon: Icon(Icons.camera),
                  label: Text("카메라", style: TextStyle()),
                ),
              ],
            ));
  }

  final ImagePicker picker = ImagePicker();

  Widget list() {
    return GroupedListView.grid(
      padding: EdgeInsets.symmetric(horizontal: 12),
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      itemsAspectRatio: 0.7,
      items: List<int>.generate(100, (index) => index + 1)
          .map((e) => DateTime(2023, 10, e))
          .toList(),
      itemGrouper: (DateTime i) => "${i.year}년 ${i.month}월",
      headerBuilder: (context, String month) => Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Text(month,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
      gridItemBuilder: (context, int countInGroup, int itemIndexInGroup,
              DateTime item, int itemIndexInOriginalList) =>
          listItem(),
      crossAxisCount: 2,
    );
  }

  Widget listItem() {
    return InkWell(
      onTap: () {
        showPickerOptionDialog();
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/v0.jpeg",
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text("뉴진스 010.5581.2378",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text("19버 1120",
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

  var department = UserService().workerDepartment;

  Widget departmentField() {
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
        ...DepartmentService().list.map((e) => DropdownMenuItem(
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

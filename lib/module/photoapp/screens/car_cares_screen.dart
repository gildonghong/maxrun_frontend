import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/screens/photo_register_screen.dart';
import 'package:photoapp/service/car_care_service.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class CarCaresScreen extends StatefulWidget {
  const CarCaresScreen({super.key});

  @override
  State<CarCaresScreen> createState() => _CarCaresScreenState();
}

class _CarCaresScreenState extends State<CarCaresScreen> {
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

  pushRegisterScreen([CarCare? item]) async {
    if(images.isEmpty) {
      return;
    }

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        return PhotoRegisterScreen(
            department: department!, files: images, carCare: item);
      },
    ));
  }

  showPickerOptionDialog([CarCare? item]) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(item==null?"차량 신규 등록":"부서 사진 추가", style: TextStyle()),
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
                    pushRegisterScreen(item);

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
                      pushRegisterScreen(item);
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
    return StreamBuilder<List<CarCare>>(
      stream: CarCareService().list,
      initialData: [],
      builder: (context, snapshot) {
        return GroupedListView.grid(
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
          gridItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                  CarCare item, int itemIndexInOriginalList) =>
              listItem(item),
          crossAxisCount: 2,
        );
      }
    );
  }

  Widget listItem(CarCare item) {
    final user = context.watch<User>();
    return InkWell(
      onTap: () {
        showPickerOptionDialog(item);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.fileSavedPath,
              fit: BoxFit.cover,
              headers: {
                "Authorization":"Bearer ${user.uAtoken}",
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
                  child: Text("${item.ownerName} ${item.formattedOwnerCpNo}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text(item.carLicenseNo??"",
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

  Department? department;

  @override
  void initState() {
    super.initState();
    department = context.read<Department?>();
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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/module/photoapp/screens/register_screen.dart';
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
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "차량 번호 검색", prefixIcon: Icon(Icons.search)),
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
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

  showPickerOptionDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("차량 신규 등록", style: TextStyle()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  department(),
                  // SizedBox(height:16),
                  // Row(children: [
                  //
                  // ],)
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FilledButton.icon(
                  onPressed: () async {
                    final List<XFile> images = await picker.pickMultiImage();

                    if (images.isNotEmpty) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return RegisterScreen(files: images);
                        },
                      ));
                    }
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text("앨범", style: TextStyle()),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final XFile? photo =
                        await picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return RegisterScreen(files: [photo]);
                        },
                      ));
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
          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
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
                  padding: EdgeInsets.only(left: 8,top: 8),
                  color: Colors.black45,
                  width: double.infinity,
                  child: Text("뉴진스 010.5581.2378",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: -0.5)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8,bottom: 4),
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

  Widget department() {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: "부서"),
      value: "1.최초",
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
}

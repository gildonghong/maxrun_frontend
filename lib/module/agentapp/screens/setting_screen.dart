import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: photoSavePath()),
          SizedBox(width:12),
          Expanded(child: department())
        ],
      ),
    );
  }

  final photoSavePathController = TextEditingController();

  Widget photoSavePath() {
    return InkWell(
      onTap: () async {
        photoSavePathController.text =

            await FilePicker.platform.getDirectoryPath() ??
            photoSavePathController.text;
      },
      child: TextFormField(
        enabled: false,

        controller: photoSavePathController,
        onTap: () async {

        },
        decoration: InputDecoration(labelText: "사진 저장 경로"),
      ),
    );
  }

  Widget department() {
    return InputDecorator(
      decoration: InputDecoration(labelText: "부서관리"),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        'Item $index',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () async {
                        },
                        icon: Icon(
                          Icons.close,
                          size: 16,
                        ),
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilledButton(
                    style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {},
                    child: Text("추가", style: TextStyle()),
                  ),
                )),
          )
        ],
      ),
    );
  }

}

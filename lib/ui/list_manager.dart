import 'package:flutter/material.dart';

class ListManager extends StatefulWidget {
  String? labelText;
   ListManager({this.labelText, super.key});

  @override
  State<ListManager> createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: "기타"),
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
                        onPressed: () {},
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
                suffixIcon: FilledButton(
                  style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {},
                  child: Text("추가", style: TextStyle()),
                )),
          )
        ],
      ),
    );
  }
}

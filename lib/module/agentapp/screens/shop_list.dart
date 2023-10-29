import 'package:flutter/material.dart';
import 'package:photoapp/model/shop.dart';
import 'package:photoapp/service/shop_service.dart';

import 'shop_list_model.dart';

class ShopSearchView extends StatefulWidget {
  ShopListModel model;

  ShopSearchView({required this.model,super.key});

  @override
  State<ShopSearchView> createState() => _ShopSearchViewState();
}

class _ShopSearchViewState extends State<ShopSearchView> {
  ShopListModel get model=>widget.model;

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Shop>>(
      stream: model.list,
      initialData: [],
      builder: (context, snapshot) {
        return Column(
          children: [
            searchField(snapshot.data!),
            SizedBox(height: 8),
            Expanded(child: ExcludeFocus(child: listView(snapshot.data!))),
          ],
        );
      },
    );
  }

  Widget searchField(List<Shop> list) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 40,
            width: 40,
            child: FilledButton(
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  ShopService().fetch();
                },
                child: Icon(Icons.refresh))),
        SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: model.searchController,
            decoration: InputDecoration(
                labelText: "공업사 검색",
                counterText: "총 ${list.length}건",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    model.searchController.text = "";
                  },
                )),
          ),
        ),
        Visibility(
          visible: model.showAddButton,
          child: Container(
            padding: EdgeInsets.only(left: 4),
              height: 40,
              width: 40,
              child: FilledButton(
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero, backgroundColor: Colors.orange),
                  onPressed: () {
                    model.selectedShopNo.value = null;
                  },
                  child: Icon(Icons.add))),
        )
      ],
    );
  }

  Widget listView(List<Shop> list) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 2),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return listItem(list[index]);
      },
    );
  }

  Widget listItem(Shop e) {
    return StreamBuilder<int?>(
        stream: model.selectedShopNo,
        builder: (context, snapshot) {
          final selectedNo = snapshot.data;
          return FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: selectedNo == e.repairShopNo
                      ? Colors.blue
                      : Colors.grey[350],
                  foregroundColor: selectedNo == e.repairShopNo
                      ? Colors.white
                      : Colors.black87,
                  elevation: 0,
                  minimumSize: Size(0, 40)),
              onPressed: () {
                setState(() {
                  model.selectedShopNo.value = e.repairShopNo;
                });
              },
              child: Text(e.repairShopName ?? "", style: TextStyle()));
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loadmore/loadmore.dart';
import 'package:photoapp/extension/datetime_ext.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/module/photoapp/photo_app.dart';
import 'package:photoapp/module/photoapp/screens/enter_detail_screen.dart';
import 'package:photoapp/module/photoapp/screens/enter_form_screen.dart';
import 'package:photoapp/service/car_care_service.dart';
import 'package:photoapp/service/department_service.dart';
import 'package:photoapp/service/shop_service.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen>with AutomaticKeepAliveClientMixin {
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  // ignore: prefer_function_declarations_over_variables
  late final scrollListener = (){
    if(scrollController.position.extentAfter < 450){
      debugPrint("scrollListener");
      EasyThrottle.throttle(
          'car-list-paging',
          Duration(milliseconds: 300),
          () {
            debugPrint("throttle");
            CarCareService().loadMore();
          },
      );
    }
  };

  @override
  void initState() {
    super.initState();
    CarCareService().fetch();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    EasyThrottle.cancel('car-list-paging');
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: UserService().isManager ? registerButton() : null,
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
                        CarCareService().carLicenseNo=  searchController.text;
                        CarCareService().fetch();
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
                              CarCareService().carLicenseNo=  searchController.text;
                              CarCareService().fetch();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(ShopService().userShop.value?.repairShopName ?? "",
                style: TextStyle(fontSize: 16))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text("${DepartmentService().userDepartment.value?.departmentName??""} ${UserService().user.getValue()?.workerName} 님",
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
        CarCareService().carLicenseNo=  searchController.text;
        await CarCareService().fetch();
        return;
      },
      child: StreamBuilder<List<CarCare>>(
          stream: CarCareService().list,
          initialData: [],
          builder: (context, snapshot) {
            final list = snapshot.data!;
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text("검색결과가 없습니다.", style: TextStyle(fontSize: 20)),
              );
            }

            return GroupedListView.grid(
              shrinkWrap: false,
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 12),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              itemsAspectRatio: 0.7,
              items: snapshot.data!,
              // itemGrouper: (CarCare i) => i.enterInDate.yyyyMM,
              itemGrouper: (CarCare i) => i.enteredAt.yyyyMM,
              headerBuilder: (context, String month) {
                // debugPrint("month:$month");
                return Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(month.replaceAll("-", "년 ") + "월",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900)));
              },
              gridItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                      CarCare item, int itemIndexInOriginalList) =>
                  listItem(item),
              crossAxisCount: 2,
            );
          }),
    );
  }

  Widget listItem(CarCare item) {
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
            CachedNetworkImage(
              fit: BoxFit.cover,
              cacheKey: (item.fileSavedPath ?? "") + "300",
              imageUrl: item.fileSavedPath??"",
              maxWidthDiskCache: 300,
              maxHeightDiskCache: 300,
              memCacheWidth: 300,
              memCacheHeight: 300,
              fadeInDuration: Duration(milliseconds: 150),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                  child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.image_not_supported_rounded),
              httpHeaders: {
                "Authorization": "Bearer ${currentUser.uAtoken}",
              },
            ),
            // Image.network(
            //   item.fileSavedPath ?? "",
            //   fit: BoxFit.cover,
            //   headers: {
            //     "Authorization": "Bearer ${user.uAtoken}",
            //   },
            // ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

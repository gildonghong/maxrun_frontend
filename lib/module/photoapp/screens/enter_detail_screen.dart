import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoapp/model/car_care.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/model/photo.dart';
import 'package:photoapp/model/user.dart';
import 'package:photoapp/module/photoapp/photo_app.dart';
import 'package:photoapp/module/photoapp/screens/enter_form_screen.dart';
import 'package:photoapp/service/car_care_service.dart';
import 'package:photoapp/service/enter_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterDetailScreen extends StatefulWidget {
  CarCare car;

  EnterDetailScreen(this.car, {super.key});

  @override
  State<EnterDetailScreen> createState() => _EnterDetailScreenState();
}

class _EnterDetailScreenState extends State<EnterDetailScreen> {
  late CarCare car = widget.car;
  final photos = <Photo>[];
  final ImagePicker picker = ImagePicker();
  late Department? department;
  late final User user;

  @override
  void initState() {
    super.initState();
    fetchPhotos();

    user = context.read<User>();
    department = context.read<Department?>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leadingWidth: 64,
        titleSpacing: 0,
        bottom: car.ownerName?.isNotEmpty == true ||
                car.ownerCpNo?.isNotEmpty == true
            ? PreferredSize(
                preferredSize: Size(double.infinity, 40),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(car.ownerName ?? "", style: TextStyle(fontSize: 16)),
                        Gap(4),
                        Text(car.ownerCpNo ?? "", style: TextStyle(fontSize: 16)),
                      if (car.ownerCpNo?.isNotEmpty == true)
                        IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: colorPrimary,
                          ),
                          onPressed: () {
                            launchUrl(Uri.parse("tel://${car.ownerCpNo}"));
                          },
                        )
                    ],
                  ),
                ),
              )
            : null,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(8)),
              child: Text(car.paymentType,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            Gap(4),
            Text(car.carLicenseNo ?? "",
                style: TextStyle(color: Colors.black87, fontSize: 20)),
          ],
        ),
        actions: [
          if (user.isManager)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: Size.zero,
              ),
              onPressed: () {
                modify();
              },
              icon: Icon(
                Icons.edit,
                size: 20,
              ),
              label: Text("수정", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          Gap(12)
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: photosGrid()),
          addImageSection(),
        ],
      ),
    );
  }

  modify() async {
    final car = await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EnterFormScreen(
        carCare: this.car,
      ),
    ));

    if (car is CarCare) {
      setState(() {
        this.car = car;
      });
    }
  }

  fetchPhotos() async {
    final fetched = await EnterService().getPhotos(car.reqNo);
    setState(() {
      photos
        ..clear()
        ..addAll(fetched);
    });
  }

  Widget addImageSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 8)
      ]),
      padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16, top: 16),
      child: Column(
        children: [
          if (user.isManager) departmentField(),
          if (user.isManager) Gap(12),
          Row(
            children: [
              Expanded(
                  child: FilledButton.icon(
                onPressed: pickAlbumImages,
                label: Text("앨범 사진 추가", style: TextStyle()),
                icon: Icon(Icons.photo_library),
              )),
              Gap(8),
              Expanded(
                  child: FilledButton.icon(
                onPressed: () {
                  captureCamera();
                },
                label: Text("카메라로 사진 추가", style: TextStyle()),
                icon: Icon(Icons.camera),
              )),
            ],
          ),
        ],
      ),
    );
  }

  pickAlbumImages() async {
    final images = await picker.pickMultiImage();
    if (images.isEmpty) {
      return;
    }

    await CarCareService().repair(car.reqNo, department!.departmentNo, images);
    await fetchPhotos();

    EasyLoading.showSuccess("${department?.departmentName ?? ''} 사진을 등록했습니다.");
  }

  captureCamera() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }

    await CarCareService().repair(car.reqNo, department!.departmentNo, [image]);
    await fetchPhotos();

    EasyLoading.showSuccess("${department?.departmentName ?? ''} 사진을 등록했습니다.");
  }

  Widget photosGrid() {
    if (photos.isEmpty) {
      return Center(
          child: Text("등록된 사진이 없습니다.", style: TextStyle(fontSize: 20)));
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
      itemBuilder: (context, index) {
        return photo(photos[index]);
      },
    );
  }

  Widget photo(Photo p) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CachedNetworkImage(
                imageUrl: p.serverFile,
                fadeInDuration: Duration(milliseconds: 150),
                errorWidget: (context, url, error) => Icon(Icons.image_not_supported_rounded),
              ),
            ),
          ),
        );
      },
      child: Stack(fit: StackFit.loose, children: [
        Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: Image(image: NetworkImage(p.serverFile))),
        Container(
          color: Colors.black54,
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(p.departmentName ?? "",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }

  Widget departmentField() {
    final departments = context.read<List<Department>>();
    return DropdownButtonFormField<Department>(
      decoration: InputDecoration(labelText: "부서 사진 추가"),
      value: department,
      items: departments
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.departmentName, style: TextStyle()),
              ))
          .toList(),
      onChanged: (Department? value) {
        department = value ?? department;
      },
    );
  }
}

// To parse this JSON data, do
//
//     final photo = photoFromJson(jsonString);

import 'dart:convert';

Photo photoFromJson(String str) => Photo.fromJson(json.decode(str));

String photoToJson(Photo data) => json.encode(data.toJson());

class Photo {
  String departmentName;
  String clientFileName;
  String fileSavedPath;
  String serverFile;

  Photo({
    required this.departmentName,
    required this.clientFileName,
    required this.fileSavedPath,
    required this.serverFile,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    departmentName: json["departmentName"],
    clientFileName: json["clientFileName"],
    fileSavedPath: json["fileSavedPath"],
    serverFile: json["serverFile"],
  );

  Map<String, dynamic> toJson() => {
    "departmentName": departmentName,
    "clientFileName": clientFileName,
    "fileSavedPath": fileSavedPath,
    "serverFile": serverFile,
  };
}

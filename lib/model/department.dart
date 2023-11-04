/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

class Department{
  String departmentName;
  int repairShopNo;
  int departmentNo;

  Department({
    required this.departmentName,
    required this.repairShopNo,
    required this.departmentNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'departmentName': this.departmentName,
      'repairShopNo': this.repairShopNo,
      'departmentNo': this.departmentNo,
    };
  }

  factory Department.none() {
    return Department(
      departmentName: "",
      repairShopNo: -1,
      departmentNo: -1,
    );
  }
  factory Department.fromJson(Map<String, dynamic> map) {
    return Department(
      departmentName: map['departmentName'] as String,
      repairShopNo: map['repairShopNo'] as int,
      departmentNo: map['departmentNo'] as int,
    );
  }
}
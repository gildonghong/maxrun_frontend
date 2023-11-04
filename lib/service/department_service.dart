import 'package:collection/collection.dart';
import 'package:photoapp/extension/stream_ext.dart';
import 'package:photoapp/model/department.dart';
import 'package:photoapp/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';

class DepartmentService {
  static final DepartmentService _instance = DepartmentService._();

  factory DepartmentService() {
    return _instance;
  }

  final departments = BehaviorSubject<List<Department>>.seeded([]);
  final userDepartment = BehaviorSubject<Department?>.seeded(null);

  DepartmentService._() {
    UserService().user.listen((user) async {
      if( user==null ) {
        departments.value = [];
        userDepartment.value = null;
      } else {
        await fetch();
        userDepartment.value = departments.value.firstWhereOrNull((element) => element.departmentNo==user.departmentNo);
      }
    });
  }

  Future<void> fetch() async {
    final res = await api.get<List<dynamic>>(
      "/repairshop/department/list",
    );
    departments.value = res.data!.map((e) => Department.fromJson(e)).toList();
  }

  // Future delete(Department d) {
  // }

  Future add(String departmentName) async {
    final res =
        await api.post<Map<String, dynamic>>("/repairshop/department", data: {
      "departmentName": departmentName,
    });
    // final d = Department.fromJson(res.data!);
    // departments.value = departments.value..add(d);
    fetch();
  }

  Future modify(int departmentNo, String departmentName)async {
    final res =
    await api.post<Map<String, dynamic>>("/repairshop/department", data: {
      "departmentNo": departmentNo,
      "departmentName": departmentName,
    });
    // final d = Department.fromJson(res.data!);
    // final listValue = departments.value;
    // final index = listValue.indexWhere((element) => element.departmentNo == departmentNo);
    //
    // if( index > -1) {
    //   listValue[index] = d;
    // } else {
    //   listValue.add(d);
    // }
    // departments.value = listValue;
    fetch();
  }

  Future delete(int departmentNo)async {
    final res =
    await api.post<Map<String, dynamic>>("/repairshop/department", data: {
      "departmentNo": departmentNo,
      "delYn": 'Y',
    });
    // final d = Department.fromJson(res.data!);
    // final listValue = departments.value;
    // final index = listValue.indexWhere((element) => element.departmentNo == departmentNo);
    //
    // if( index > -1) {
    //   listValue[index] = d;
    // } else {
    //   listValue.add(d);
    // }
    // departments.value = listValue;
    fetch();
  }
}

List<Department> get departments => DepartmentService().departments.value;
Department get userDepartment => DepartmentService().userDepartment.value!;

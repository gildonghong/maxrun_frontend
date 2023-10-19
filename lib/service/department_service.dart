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

  DepartmentService._() {
    UserService().user.listen((value) {
      if( value == null) {
        departments.value = [];
      } else {
        fetch();
      }
    });
  }


  late final userDepartment = Rx.combineLatest2(UserService().user, departments, (user, departments) {
    return departments.firstWhereOrNull((element) => element.departmentNo==user?.departmentNo);
  }).asSubject();

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
    final d = Department.fromJson(res.data!);
    departments.value = departments.value..add(d);
  }

  Future modify(int departmentNo, String departmentName)async {
    final res =
    await api.post<Map<String, dynamic>>("/repairshop/department", data: {
      "departmentNo": departmentNo,
      "departmentName": departmentName,
    });
    final d = Department.fromJson(res.data!);
    final listValue = departments.value;
    final index = listValue.indexWhere((element) => element.departmentNo == departmentNo);

    if( index > -1) {
      listValue[index] = d;
    } else {
      listValue.add(d);
    }
    departments.value = listValue;
  }
}

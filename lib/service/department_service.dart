import 'package:photoapp/model/department.dart';
import 'package:rxdart/subjects.dart';

class DepartmentService {
  static final DepartmentService _instance = DepartmentService._();

  DepartmentService._();

  factory DepartmentService() {
    return _instance;
  }

  final list = BehaviorSubject<List<Department>>.seeded([
    Department(departmentNo: 1, name:"최초"),
    Department(departmentNo: 2, name:"판금"),
    Department(departmentNo: 3, name:"하체"),
    Department(departmentNo: 4, name:"도장"),
  ]);
}
import 'package:photoapp/model/account.dart';
import 'package:rxdart/subjects.dart';

import 'api_service.dart';
import 'department_service.dart';
import 'user_service.dart';

class AccountService {
  static final AccountService _instance = AccountService._();

  factory AccountService() {
    return _instance;
  }

  AccountService._() {
    fetch();
  }

  final list = BehaviorSubject<List<Account>>.seeded([]);

  Future<void> fetch() async {
    final res = await api.get<List<dynamic>>("/repairshop/employee/list",
        queryParameters: {
          "repairShopNo": UserService().user.getValue()?.repairShopNo
        });
    list.value = res.data!.map((e) => Account.fromJson(e)).toList();
  }

  Future<Account> update(Account account) async {
    final param = <String, dynamic>{
      "departmentNo": account.departmentNo,
      "workerNo": account.workerNo,
      "workerName": account.workerName,
      "position": account.position,
      "managerYn": account.managerYn,
      "cpNo": account.cpNo,
      "status": account.status,
    };

    if (account.pwd?.isNotEmpty == true) {
      param["pwd"] = account.pwd;
    }

    final res = await api.post<Map<String, dynamic>>("/repairshop/employee",
        queryParameters: param);

    account = Account.fromJson(res.data!);
    final index = list.value
        .indexWhere((element) => element.workerNo == account.workerNo);

    if (index > -1) {
      list.value = list.value..[index] = account;
    } else {
      list.value = list.value..add(account);
    }

    return account;
  }

  add() {
    list.value = list.value
      ..add(Account(
          cpNo: "",
          managerYn: "N",
          loginId: "",
          workerNo: 0,
          os: "android",
          lastUseDate: DateTime.now(),
          osVersion: "1.0.0",
          departmentNo: departments[0].departmentNo,
          departmentName: departments[0].departmentName,
          position: "",
          workerName: "",
          status: "사용중"));
  }

  Future<Account> create(Account account) async {
    final param = <String, dynamic>{
      "departmentNo": account.departmentNo,
      "workerName": account.workerName,
      "position": account.position,
      "managerYn": account.managerYn,
      "cpNo": account.cpNo,
      "status": account.status,
      "loginId": account.loginId,
      "pwd": account.pwd,
      "os": account.os,
      "osVersion": account.osVersion,
    };

    final res = await api.post<Map<String, dynamic>>("/repairshop/employee",
        queryParameters: param);

    account = Account.fromJson(res.data!);
    final index = list.value
        .indexWhere((element) => element.workerNo == account.workerNo);

    if (index > -1) {
      list.value = list.value..[index] = account;
    } else {
      list.value = list.value..add(account);
    }

    return account;
  }
}

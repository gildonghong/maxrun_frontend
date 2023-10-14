import 'package:darty_json/darty_json.dart';
import 'package:flutter/foundation.dart';
import 'package:photoapp/model/worker.dart';
import 'package:rxdart/subjects.dart';

import 'api_service.dart';
import 'login_service.dart';

class WorkerService {
  static final WorkerService _instance = WorkerService._();

  factory WorkerService() {
    return _instance;
  }

  WorkerService._() {
    fetch();
  }

  final list = BehaviorSubject<List<Worker>>.seeded([]);

  Future<void> fetch() async {
    // final res = await api.get<List<dynamic>>(
    //   "/notice/list",
    // );
    // list.value = Json.fromList(res.data!)
    //     .listOfValue((p0) => Worker.fromJson(p0))
    //     .toList();

    if (kDebugMode && list.value.isEmpty) {
      // list.add(Notice(noticeNo: 1, notice: "맥스런 리뉴얼 런칭", regDate: "2023-10-14"));
      list.value = list.value..add(LoginService().worker.value!);
    }
  }
}

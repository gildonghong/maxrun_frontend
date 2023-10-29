// To parse this JSON data, do
//
//     final memo = memoFromJson(jsonString);

import 'dart:convert';

import 'package:darty_json/darty_json.dart';
import 'package:photoapp/extension/datetime_ext.dart';

Memo memoFromJson(String str) => Memo.fromJson(json.decode(str));

String memoToJson(Memo data) => json.encode(data.toJson());

class Memo {
  int? reqNo;
  int memoNo;
  DateTime regDate;
  String memo;

  Memo({
    required this.reqNo,
    required this.memoNo,
    required this.regDate,
    required this.memo,
  });

  factory Memo.fromJson(Map<String, dynamic> json) {
    final j = Json.fromMap(json);
    final m = Memo(
      reqNo: json["reqNo"],
      memoNo: json["memoNo"],
      regDate: json["regDate"] is int ? DateTime.fromMillisecondsSinceEpoch(json["regDate"]) : DateTime.parse(json["regDate"]),
      memo: json["memo"],
    );

    return m;
  }

  Map<String, dynamic> toJson() => {
    "reqNo": reqNo,
    "memoNo": memoNo,
    "regDate": regDate.millisecondsSinceEpoch,
    "memo": memo,
  };
}

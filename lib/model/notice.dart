// To parse this JSON data, do
//
//     final notice = noticeFromJson(jsonString);

import 'dart:convert';

Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

String noticeToJson(Notice data) => json.encode(data.toJson());

class Notice {
  int rownum;
  int noticeNo;
  DateTime noticeDate;
  String notice;

  Notice({
    required this.rownum,
    required this.noticeNo,
    required this.noticeDate,
    required this.notice,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    rownum: json["rownum"],
    noticeNo: json["noticeNo"],
    noticeDate: DateTime.fromMillisecondsSinceEpoch(json["noticeDate"]),
    notice: json["notice"],
  );

  Map<String, dynamic> toJson() => {
    "rownum": rownum,
    "noticeNo": noticeNo,
    "noticeDate": noticeDate.millisecondsSinceEpoch,
    "notice": notice,
  };
}

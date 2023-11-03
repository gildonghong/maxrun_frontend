// To parse this JSON data, do
//
//     final notice = noticeFromJson(jsonString);

import 'dart:convert';

Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

String noticeToJson(Notice data) => json.encode(data.toJson());

class Notice {
  int noticeNo;
  DateTime noticeDate;
  String? noticeTitle;
  String notice;

  Notice({
    required this.noticeNo,
    required this.noticeDate,
    required this.noticeTitle,
    required this.notice,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    noticeNo: json["noticeNo"],
    noticeDate: DateTime.fromMillisecondsSinceEpoch(json["noticeDate"]),
    noticeTitle: json["noticeTitle"],
    notice: json["notice"],
  );

  Map<String, dynamic> toJson() => {
    "noticeNo": noticeNo,
    "noticeDate": noticeDate.millisecondsSinceEpoch,
    "noticeTitle": noticeTitle,
    "notice": notice,
  };
}

// To parse this JSON data, do
//
//     final memo = memoFromJson(jsonString);

import 'dart:convert';

Memo memoFromJson(String str) => Memo.fromJson(json.decode(str));

String memoToJson(Memo data) => json.encode(data.toJson());

class Memo {
  DateTime regDate;
  String text;

  Memo({
    required this.regDate,
    required this.text,
  });

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
    regDate: DateTime.parse(json["regDate"]),
    text: json["memo"],
  );

  Map<String, dynamic> toJson() => {
    "regDate": regDate.toIso8601String(),
    "memo": text,
  };
}

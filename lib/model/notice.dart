class Notice{
  int noticeNo;
  String notice;
  String regDate;

  Notice({
    required this.noticeNo,
    required this.notice,
    required this.regDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'noticeNo': this.noticeNo,
      'notice': this.notice,
      'regDate': this.regDate,
    };
  }

  factory Notice.fromJson(Map<String, dynamic> map) {
    return Notice(
      noticeNo: map['noticeNo'] as int,
      notice: map['notice'] as String,
      regDate: map['regDate'] as String,
    );
  }
}
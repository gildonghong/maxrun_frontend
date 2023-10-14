class Repair{
  String carLicenseNo;

  Repair({
    required this.carLicenseNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'carLicenseNo': this.carLicenseNo,
    };
  }

  factory Repair.fromJson(Map<String, dynamic> map) {
    return Repair(
      carLicenseNo: map['carLicenseNo'] as String,
    );
  }
}
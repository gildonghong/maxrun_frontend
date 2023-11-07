// const double inch = 72.0;
// const double cm = inch / 2.54;
// const double mm = inch / 25.4;

import 'package:intl/intl.dart';

extension DateTimeExtention on DateTime {
  String format(String layout){
    return DateFormat(layout).format(this);
  }
  String get yyyyMMdd{
    return format("yyyy-MM-dd");
  }
  String get yyyyMM{
    return format("yyyy-MM");
  }
}

// const double inch = 72.0;
// const double cm = inch / 2.54;
// const double mm = inch / 25.4;
import 'package:pdf/pdf.dart';

extension DoubleExtention on double {
  double get mm => this * PdfPageFormat.mm;
  double get cm => this * PdfPageFormat.cm;
  double get round2 => (this * 100.0).roundToDouble()/100;
}

extension IntExtention on int {
  double get mm => this * PdfPageFormat.mm;
  double get cm => this * PdfPageFormat.cm;
}

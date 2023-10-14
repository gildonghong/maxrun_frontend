import 'dart:math';

import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.length > oldValue.text.length &&
        int.tryParse(newValue.text[newValue.text.length - 1]) == null) {
      return oldValue;
    }

    if (newValue.text.length > oldValue.text.length) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final plainNumber = newValue.text
          .replaceAll("-", '')
          .replaceAll(" ", '')
          .replaceAll(":", '');

      if (plainNumber.length > 8) {
        return oldValue;
      }

      final year =
      plainNumber.length >= 4 ? plainNumber.substring(0, 4) : plainNumber;
      final month = plainNumber.length >= 5
          ? plainNumber.substring(4, min(plainNumber.length, 6))
          : "";
      final day = plainNumber.length >= 7
          ? plainNumber.substring(6, min(plainNumber.length, 8))
          : "";

      var newString = year;
      if (month != "") newString += "-$month";
      if (day != "") newString += "-$day";

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
import 'package:{{project_name}}/utils/string_extention.dart';
import 'package:flutter/services.dart';

class CapitalFirstLatterOfWorkdFormatter extends TextInputFormatter {
  CapitalFirstLatterOfWorkdFormatter();
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toTitleCase(),
      selection: TextSelection.collapsed(offset: newValue.text.length),
    );
  }
}

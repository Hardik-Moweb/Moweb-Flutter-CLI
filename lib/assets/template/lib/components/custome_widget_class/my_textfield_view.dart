// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'dart:math' as math;

import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFieldView extends StatelessWidget {
  IconData? image;
  TextAlign textAlign = TextAlign.left;

  double? fontSize = FontSize.s16;
  TextInputType keyboardType = TextInputType.text;
  TextEditingController controller;
  int? maxLength = 2;
  Color? txtColor = textColor;
  List<TextInputFormatter>? inputFormatters;
  bool isAllowdecimal = false;
  String hinttext = "";
  Function(String)? onTextChanged;
  Function(String)? onFieldSubmitted;
  bool? passwordText = false;
  double? cornerRadius = 6;
  Color? backgroundColor;
  bool? isBorder = true;
  int? lines = 1;
  FocusNode? focusnode;
  TextInputAction? action;
  bool? capitalisation;
  bool? autoFocus;
  bool? isEnable;
  Widget? suffixIcon;
  TextFieldView(this.hinttext, this.controller, this.textAlign,
      this.keyboardType, this.isAllowdecimal,
      {super.key,
      this.txtColor,
      this.image,
      this.fontSize,
      this.maxLength,
      this.isEnable,
      this.inputFormatters,
      this.onTextChanged,
      this.onFieldSubmitted,
      this.passwordText,
      this.cornerRadius,
      this.backgroundColor,
      this.isBorder,
      this.lines,
      this.focusnode,
      this.action,
      this.capitalisation,
      this.autoFocus,
      this.suffixIcon,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: lines == null ? s.s45 : null,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(cornerRadius == null ? 6 : cornerRadius!),
          color: isEnable == false
              ? Colors.transparent
              : backgroundColor ?? Colors.white,
          border: Border.all(
              color: isBorder != null ? Colors.transparent : (AppColors.borderColor),
              width: isBorder != null ? 0 : 1)),
      child: Align(
        alignment: Alignment.center,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: TextFormField(
            autocorrect: false,
            textInputAction: action ?? TextInputAction.done,
            maxLines: lines ?? 1,
            minLines: lines ?? 1,
            textAlign: TextAlign.left,
            textCapitalization:
                (capitalisation != null && capitalisation == false) ||
                        keyboardType == TextInputType.emailAddress
                    ? TextCapitalization.none
                    : TextCapitalization.sentences,
            focusNode: focusnode,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize ?? FontSize.s15,
              color: textColor,
            ),
            keyboardType: keyboardType,
            controller: controller,
            maxLength: keyboardType == TextInputType.phone ? 9 : maxLength,
            inputFormatters: (inputFormatters != null)
                ? inputFormatters
                : isAllowdecimal
                    ? [DecimalTextInputFormatter(decimalRange: 2)]
                    : keyboardType == TextInputType.phone ||
                            keyboardType == TextInputType.number
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ]
                        : null,
            decoration: InputDecoration(
              prefixIcon: image != null
                  ? Icon(
                      image,
                      color: secondTextColor,
                      size: s.s25,
                    )
                  : null,
              counterText: "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              enabled: isEnable ?? true,
              // Added this
              contentPadding: image != null
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 13)
                  : EdgeInsets.all(s.s10),
              hintText: hinttext,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey,
              ),
              suffixIcon: suffixIcon,
            ),
            onChanged: (value) {
              if (onTextChanged != null) {
                onTextChanged!(value);
              }
            },
            obscureText: passwordText != null ? passwordText! : false,
            onFieldSubmitted: onFieldSubmitted,
            autofocus: autoFocus ?? false,
          ),
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 2}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (decimalDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
    }

    if (newText.contains('.')) {
      //in case if user's first input is "."
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: const TextSelection.collapsed(offset: 2),
        );
      }
      //in case if user tries to input multiple "."s or tries to input
      //more than the decimal place
      else if ((newText.split(".").length > 2) ||
          (newText.split(".")[1].length > decimalDigits)) {
        return oldValue;
      } else {
        return newValue;
      }
    }

    //in case if input is empty or zero
    if (newText.trim() == '' || newText.trim() == '0') {
      return newValue.copyWith(text: '');
    } else if (int.parse(newText) < 1) {
      return newValue.copyWith(text: '');
    }

    double newDouble = double.parse(newText);
    var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}

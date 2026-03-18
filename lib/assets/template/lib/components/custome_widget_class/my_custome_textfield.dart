// ignore_for_file: must_be_immutable

import 'dart:math' as math;

import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  String? strImage = "";
  TextAlign textAlign = TextAlign.left;
  FontWeight? fontWeight = FontWeight.normal;
  double? fontSize = FontSize.s16;
  TextInputType keyboardType = TextInputType.text;
  TextEditingController controller;
  int? maxLength;
  Color? txtColor = textColor;
  List<TextInputFormatter>? inputFormatters;
  bool isAllowdecimal = false;
  String strHinttext = "";
  Function(String)? onTextChanged;
  Function(String)? onFieldSubmitted;
  bool? isPasswordText = false;
  double? dbCornerRadius = 6;
  Color? backgroundColor;
  bool? isBorder = true;
  int? minLines = 1;
  int? maxLines = 1;
  FocusNode? focusnode;
  TextInputAction? action;
  bool? isEnable;
  bool isRequired;
  TextCapitalization? textcapitalization;
  String? Function(String? str)? validator;
  Function? onPasswordShow;
  bool? isObsecure;
  String? prefixIcon;
  bool? autoFocus;
  Widget? suffixWidget;
  bool? suffixDivider;
  double? padding;
  bool? autoExpand;

  CustomTextField(
    this.strHinttext,
    this.controller,
    this.textAlign,
    this.keyboardType,
    this.isAllowdecimal, {
    super.key,
    this.txtColor,
    this.strImage,
    this.fontWeight,
    this.textcapitalization,
    this.fontSize,
    this.maxLength,
    this.inputFormatters,
    this.onTextChanged,
    this.onFieldSubmitted,
    this.isPasswordText,
    this.dbCornerRadius,
    this.backgroundColor,
    this.isBorder,
    this.minLines,
    this.maxLines,
    this.focusnode,
    this.action,
    this.isEnable,
    this.isObsecure,
    this.isRequired = false,
    this.onPasswordShow,
    this.validator,
    this.prefixIcon = "",
    this.autoFocus = false,
    this.suffixWidget,
    this.suffixDivider = true,
    this.padding,
    this.autoExpand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: autoExpand ?? false ? null : minLines == null ? s.s45 : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          dbCornerRadius == null ? 6 : dbCornerRadius!,
        ),
        color: backgroundColor ?? Colors.white,
        border: Border.all(
          color: isBorder == null ? Colors.transparent : borderSecondColor,
          width: isBorder == null ? 0 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: TextFormField(
                  autocorrect: true,
                  textInputAction: action ?? TextInputAction.done,
                  maxLines: autoExpand ?? false ? null : maxLines ?? 1,
                  minLines: minLines ?? 1,
                  textAlign: TextAlign.left,
                  textCapitalization: TextInputType.emailAddress == keyboardType
                      ? TextCapitalization.none
                      : textcapitalization == null
                      ? TextCapitalization.sentences
                      : textcapitalization!,
                  focusNode: focusnode,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: fontWeight,
                    fontSize: fontSize ?? FontSize.s15,
                    color: textColor,
                  ),
                  keyboardType: keyboardType,
                  controller: controller,
                  maxLength: keyboardType == TextInputType.phone ? 9 : maxLength,
                  inputFormatters: (inputFormatters != null)
                      ? inputFormatters
                      : isAllowdecimal
                      ? [
                          DecimalTextInputFormatter(decimalRange: 2),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ]
                      : keyboardType == TextInputType.phone ||
                              keyboardType == TextInputType.number
                          ? <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ]
                          : null,
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    suffixIconConstraints: BoxConstraints(maxHeight: s.s30),
                    suffixIcon: isPasswordText == true
                        ? IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (onPasswordShow != null) {
                                onPasswordShow!();
                              }
                            },
                            icon: Icon(
                              isObsecure == true
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: secondTextColor,
                            ),
                            iconSize: s.s20,
                          )
                        : null,
                    prefixIcon: prefixIcon!.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(s.s12),
                            child: Image.asset(prefixIcon!),
                          )
                        : null,
                    contentPadding: EdgeInsets.all(padding ?? s.s10),
                    hintText: strHinttext,
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: fontSize ?? 16,
                      color: AppColors.disableGrey,
                    ),
                  ),
                  onChanged: (value) {
                    if (onTextChanged != null) {
                      onTextChanged!(value);
                    }
                  },
                  obscureText: isObsecure ?? false,
                  onFieldSubmitted: onFieldSubmitted,
                  enabled: isEnable ?? true,
                  autofocus: autoFocus ?? false,
                  validator: validator ??
                      (String? str) {
                        if (isRequired) {
                          if (str?.isEmpty == true) {
                            return "Field is required";
                          }
                        }
                        return null;
                      },
                ),
              ),
            ),
          ),
          if (suffixWidget != null)
            Row(
              children: [
                if (suffixDivider!)
                  SizedBox(
                    height: s.s45,
                    child: VerticalDivider(
                      width: 0,
                      color: greyColor,
                    ),
                  ),
                sbw(s.s10),
                suffixWidget!,
                if (!suffixDivider!) sbw(s.s5),
              ],
            ),
        ],
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
    TextEditingValue oldValue,
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

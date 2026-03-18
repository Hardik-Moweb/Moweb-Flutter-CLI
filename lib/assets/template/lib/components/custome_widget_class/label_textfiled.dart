import 'package:{{project_name}}/components/custome_widget_class/my_textfield_view.dart';
import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';

import 'my_custome_textfield.dart';

String countryCode = '';

class LabelTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool? isAllowdecimal;
  final bool? isPassword;
  final int? minLine;
  final int? maxLine;
  final Color? backgroundColorofTextfield;
  final bool? isEnable;
  final bool? isStaticText;
  final FocusNode? focusnode;
  final int? maxLength;
  final bool? isPhoneNumber;
  final bool? isOptional;
  final String? postString;
  final Function(String)? onTextChange;
  final Function? onPasswordShow;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final bool? isObsecure;
  final bool? isBorder;
  final Widget? suffixWidget;
  final FontWeight? fontWeight;
  final TextInputAction? action;
  final Function(String)? onFieldSubmitted;

  const LabelTextField(
    this.title,
    this.hint,
    this.controller,
    this.inputType,
    this.isAllowdecimal, {
    super.key,
    this.isPassword,
    this.maxLine,
    this.minLine,
    this.isOptional,
    this.backgroundColorofTextfield,
    this.isEnable,
    this.isStaticText,
    this.focusnode,
    this.onTextChange,
    this.maxLength,
    this.postString,
    this.isPhoneNumber,
    this.onPasswordShow,
    this.textCapitalization,
    this.isObsecure,
    this.isBorder,
    this.suffixWidget,
    this.fontWeight,
    this.inputFormatters = const [],
    this.action,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title?.isNotEmpty ?? false == true) ...[
          Row(
            children: [
              TitleTextView(
                title,
                fontWeight: fontWeight ?? MyFontWeights.regular,
                color: Colors.black,
                fontSize: FontSize.s14,
              ),
              isOptional == false
                  ? TitleTextView(
                      "*",
                      fontWeight: fontWeight ?? MyFontWeights.regular,
                      color: AppColors.redColor,
                      fontSize: FontSize.s14,
                    )
                  : Container(),
            ],
          ),
          sb(10),
        ],
        isStaticText ?? false == true
            ? staticPrefixTextField(
                hint,
                controller,
                isPhoneNumber ?? false,
                postString,
                isEnable,
                focusnode,
                onTextChange,
                inputFormatters,
              )
            : Container(
                color: Colors.transparent,
                child: CustomTextField(
                  hint!,
                  controller!,
                  TextAlign.left,
                  inputType!,
                  isAllowdecimal!,
                  fontSize: FontSize.s14,
                  isPasswordText: isPassword ?? false,
                  minLines: minLine ?? 1,
                  maxLines: maxLine ?? 1,
                  backgroundColor: isEnable == false
                      ? Colors.grey.withValues(alpha: 0.1)
                      : backgroundColorofTextfield,
                  isEnable: isEnable,
                  textcapitalization: textCapitalization,
                  focusnode: focusnode,
                  onTextChanged: (value) {
                    if (onTextChange != null) {
                      onTextChange!(value);
                    }
                  },
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  isObsecure: isObsecure,
                  isBorder: isBorder,
                  onPasswordShow: () {
                    if (onPasswordShow != null) {
                      onPasswordShow!();
                    }
                  },
                  suffixWidget: suffixWidget,
                  suffixDivider: false,
                  action: action,
                  onFieldSubmitted: onFieldSubmitted,
                ),
              ),
      ],
    );
  }

  Widget staticPrefixTextField(
    String? hint,
    TextEditingController? controller,
    bool isPhoneNumber,
    String? postString,
    bool? isEnable,
    FocusNode? focusnode,
    Function(String)? onChanged,
    final List<TextInputFormatter> inputFormatters,
  ) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isEnable == false ? Colors.grey.withValues(alpha: 0.1) : whiteColor,
        borderRadius: radius(5),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        children: [
          TitleTextView(
            isPhoneNumber == true ? countryCode : postString ?? "TZS",
            fontSize: FontSize.s17,
          ),
          sbw(8),
          Expanded(
            child: TextFieldView(
              hint!,
              controller!,
              TextAlign.left,
              isPhoneNumber == true
                  ? TextInputType.phone
                  : TextInputType.number,
              true,
              isBorder: false,
              fontSize: FontSize.s17,
              isEnable: isEnable,
              focusnode: focusnode,
              onTextChanged: onChanged,
              inputFormatters: inputFormatters,
            ),
          ),
        ],
      ),
    );
  }
}

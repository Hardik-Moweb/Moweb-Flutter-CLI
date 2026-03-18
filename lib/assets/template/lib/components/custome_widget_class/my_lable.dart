// ignore_for_file: must_be_immutable

import 'package:{{project_name}}/utils/import.dart';

class TitleTextView extends StatelessWidget {
  final String? text;
  TextAlign textAlign = TextAlign.left;
  Color? color = textColor;
  FontWeight? fontWeight = FontWeight.normal;
  double? fontSize = FontSize.s16;
  bool softWrap = true;
  int? maxLines;
  bool isStrikeText = false;
  TextOverflow? overflow;
  double? lineHeight;
  bool? isUnderline;

  TitleTextView(this.text,
      {super.key,
      this.textAlign = TextAlign.left,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.softWrap = true,
      this.maxLines,
      this.isStrikeText = false,
      this.overflow,
      this.lineHeight,
      this.isUnderline});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '-',
      textAlign: textAlign,
      overflow: (overflow == null) ? TextOverflow.clip : overflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontFamily: 'Inter',
        height: lineHeight ?? 1.2,
        color: (color == null) ? Colors.black : color,
        fontSize: (fontSize == null) ? FontSize.s16 : fontSize,
        fontWeight: fontWeight,
        decoration: (isUnderline != null && isUnderline!)
            ? TextDecoration.underline
            : (isStrikeText)
                ? TextDecoration.lineThrough
                : TextDecoration.none,
      ),
    );
  }
}

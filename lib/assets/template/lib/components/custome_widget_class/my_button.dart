import 'package:{{project_name}}/components/custome_widget_class/my_bounce.dart';
import 'package:{{project_name}}/components/loader_view.dart';
import 'package:{{project_name}}/utils/import.dart';

class Button extends StatelessWidget {
  final Function()? ontap;
  final String? strTitle;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? fontColor;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final bool? isBorderEnable;
  final Color? borderColors;
  final bool? isShadow;
  final bool? isDisable;
  final bool? isButtonLoading;
  final bool isLoading;
  final Color? loaderColor;
  final double? height;
  final double? borderRadius;
  const Button(
      {super.key,
      this.ontap,
      this.strTitle,
      this.fontSize,
      this.fontWeight,
      this.fontColor,
      this.backgroundColor,
      this.textAlign,
      this.isBorderEnable,
      this.isShadow,
      this.isDisable,
      this.isButtonLoading,
      this.borderColors,
      this.loaderColor,
      this.isLoading = false,
        this.height,
        this.borderRadius,
      });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(padding: EdgeInsets.symmetric(vertical: s.s10),child: LoaderView(color: loaderColor,),);
    }
    return isButtonLoading == true
        ? const LoaderView()
        : Bounce(
            duration: Duration(
                milliseconds:
                    isDisable == null || isDisable == false ? 110 : 0),
            onPressed: () {
              if (isDisable == null || isDisable == false) {
                if (ontap != null) {
                  ontap!();
                }
              }
            },
            isDisable: isDisable ?? false,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: s.s8),
              decoration: BoxDecoration(
                borderRadius: radius(borderRadius ?? 8),
                color: isDisable == null || isDisable == false
                    ? (backgroundColor ?? themeColor)
                    : Colors.grey,
                border: isBorderEnable != null
                    ? (isBorderEnable!
                        ? Border.all(
                            color: borderColors == null
                                ? borderSecondColor
                                : borderColors!,
                            width: 1)
                        : null)
                    : null,
                boxShadow: isShadow == null || isShadow == true
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 4.0,
                          spreadRadius: 2,
                          offset: const Offset(
                            0,
                            2,
                          ),
                        )
                      ]
                    : null,
              ),
              height: height??s.s45,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  strTitle!,
                   textScaler: TextScaler.noScaling,
                  textAlign: textAlign ?? TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    decoration: TextDecoration.none,
                    fontWeight: fontWeight ?? MyFontWeights.semiBold,
                    fontSize: fontSize ?? s.s14,
                    color: fontColor == null ? buttonTextColor : fontColor!,
                  ),
                ),
              ),
            ),
          );
  }
}

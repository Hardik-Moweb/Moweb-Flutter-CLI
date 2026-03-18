import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';

class AppbarWithBackAndAction extends StatelessWidget
    implements PreferredSizeWidget {
  final String strTitle;
  final List<Widget> array;
  final Function()? onBackPressed;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool? hideLeading;
  final bool? transparent;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  
  const AppbarWithBackAndAction({
    super.key,
    required this.strTitle,
    this.array = const [],
    this.onBackPressed,
    this.bottom,
    this.leading,
    this.hideLeading = false,
    this.transparent = false,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? whiteColor;
    final txtColor = textColor ?? AppColors.blackColor;
    final icnColor = iconColor ?? txtColor;
    
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0)),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          centerTitle: true,
          bottom: bottom,
          leading: (hideLeading ?? false) 
              ? Container() 
              : leading ?? InkWell(
                  onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: icnColor,
                      size: FontSize.s20,
                    ),
                  ),
                ),
          title: TitleTextView(
            strTitle,
            fontSize: FontSize.s16,
            fontWeight: MyFontWeights.semiBold,
            color: txtColor,
          ),
          actions: array,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom == null ? kToolbarHeight : 110);
}

PreferredSize appBarWithBackAndAction({
  required String strTitle,
  List<Widget> array = const [],
  Function()? onBackPressed,
  PreferredSizeWidget? bottom,
  Widget? leading,
  bool? hideLeading = false,
  bool? transparent = false,
  Color? backgroundColor,
  Color? textColor,
  Color? iconColor,
}) {
  final appBar = AppbarWithBackAndAction(
    strTitle: strTitle,
    array: array,
    onBackPressed: onBackPressed,
    bottom: bottom,
    leading: leading,
    hideLeading: hideLeading,
    transparent: transparent,
    backgroundColor: backgroundColor,
    textColor: textColor,
    iconColor: iconColor,
  );
  
  return PreferredSize(
    preferredSize: appBar.preferredSize,
    child: appBar,
  );
}
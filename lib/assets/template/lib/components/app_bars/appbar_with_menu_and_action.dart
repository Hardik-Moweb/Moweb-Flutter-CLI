import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/services.dart';

PreferredSize appBarWithMenuAndAction(
  String strTitle,
  List<Widget> array, {
  Function? onMenuPressed,
  PreferredSizeWidget? bottom,
  bool? isSeachEnable,
  TextEditingController? controller,
  bool? transparent,
  final Function(String)? onEditComplete,
  Widget? titleChild,
  double? elevation,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        elevation: 0, // must be 0 because shadow is from Container
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: transparent ?? false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        centerTitle: true,
        bottom: bottom,
        leading: InkWell(
          onTap: () {
            onMenuPressed?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Icon(Icons.menu_rounded)/*SvgPicture.asset(
              Imagename.icMenuIcon,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            )*/,
          ),
        ),
        title: isSeachEnable ?? false
            ? titleChild
            : TitleTextView(
                strTitle,
                fontSize: FontSize.s16,
                fontWeight: MyFontWeights.semiBold,
                color: textColor,
              ),
        actions: array,
      ),
    ),
  );
}

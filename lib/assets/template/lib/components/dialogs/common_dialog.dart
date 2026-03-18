import '../../utils/import.dart';

/// Reusable dialog with title, description, and positive/negative buttons.
class CommonDialog extends StatefulWidget {

  const CommonDialog(
      {super.key, required this.title, this.description="", required this.positiveButtonText, required this.negativeButtonText, this.onPositiveClick, this.onNegativeClick,});

  final String title;
  final String description;
  final String positiveButtonText;
  final String negativeButtonText;
  final Function()? onPositiveClick;
  final Function()? onNegativeClick;

  @override
  State<CommonDialog> createState() => _AlertLogoutDialogState();
}

/// Internal state for CommonDialog; builds title, description, and action buttons.
class _AlertLogoutDialogState extends State<CommonDialog> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return myBody();
  }

  /// Builds dialog content with title, description, and two buttons.
  Widget myBody() {
    return Container(
      padding: EdgeInsets.all(s.s20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleTextView(
            widget.title,
            fontWeight: FontWeight.w600,
            fontSize: FontSize.s16,
            color: AppColors.blackColor,
          ),
          sb(s.s15),
          if(widget.description.isNotEmpty)...[
            TitleTextView(
              widget.description,
              fontWeight: FontWeight.w600,
              fontSize: FontSize.s14,
              color: greySecondColor,
            ),
          ],
          sb(s.s17),
          Row(
            children: [
              Expanded(
                child: Button(
                  strTitle: widget.negativeButtonText,
                  isShadow: false,
                  isBorderEnable: true,
                  fontColor: greySecondColor,
                  backgroundColor: whiteColor,
                  ontap: () {
                    pop(context);
                    if(widget.onNegativeClick != null){
                      widget.onNegativeClick!();
                    }
                  },
                ),
              ),
              sbw(s.s10),
              Expanded(
                child: Button(
                  strTitle: widget.positiveButtonText,
                  isShadow: false,
                  isBorderEnable: false,
                  backgroundColor: AppColors.primaryColor,
                  fontColor: whiteColor,
                  ontap: () {
                    pop(context);
                    if(widget.onPositiveClick != null){
                      widget.onPositiveClick!();
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
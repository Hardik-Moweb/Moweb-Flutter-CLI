import 'dart:ui';

import 'package:{{project_name}}/utils/import.dart';

class ShowCustomDialog extends StatefulWidget {
  final String strTitle;
  final String strMsg;
  final String strPositiveTitle;
  final String? strNegativeTitle;
  final Function()? onPositivePressed;
  final Function()? onNegativePressed;

  const ShowCustomDialog(this.strTitle, this.strMsg, this.strPositiveTitle,
      {super.key,
      this.strNegativeTitle,
      this.onPositivePressed,
      this.onNegativePressed});

  @override
  State<ShowCustomDialog> createState() => _ShowCustomDialogState();
}

class _ShowCustomDialogState extends State<ShowCustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with smooth duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Scale animation with elastic curve for bounce effect
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInBack,
    );

    // Fade animation for smooth opacity transition
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for subtle upward motion
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Close dialog with reverse animation
  Future<void> _closeDialog() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6.0 * _fadeAnimation.value,
                  sigmaY: 6.0 * _fadeAnimation.value,
                ),
                child: Container(
                  padding: EdgeInsets.all(s.s10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: radius(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15 * _fadeAnimation.value),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: s.s10,
                          ),
                          TitleTextView(
                            widget.strTitle,
                            fontWeight: MyFontWeights.bold,
                            textAlign: TextAlign.center,
                            fontSize: FontSize.s15,
                            color: textColor,
                          ),
                          SizedBox(
                            height: s.s15,
                          ),
                          TitleTextView(
                            widget.strMsg,
                            textAlign: TextAlign.center,
                            fontSize: FontSize.s15,
                            color: textColor,
                          ),
                          SizedBox(height: s.s20),
                          Row(
                            mainAxisAlignment: widget.strNegativeTitle != null &&
                                    widget.strNegativeTitle != ""
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            children: <Widget>[
                              widget.strNegativeTitle != null &&
                                      widget.strNegativeTitle != ""
                                  ? Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (widget.onNegativePressed != null) {
                                            await _closeDialog();
                                            widget.onNegativePressed!();
                                          } else {
                                            await _closeDialog();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(s.s10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: themeColor, width: 1),
                                            borderRadius: radius(8),
                                          ),
                                          child: TitleTextView(
                                            widget.strNegativeTitle!,
                                            fontSize: 16,
                                            textAlign: TextAlign.center,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              widget.strNegativeTitle != null &&
                                      widget.strNegativeTitle != ""
                                  ? SizedBox(width: s.s10)
                                  : Container(),
                              Expanded(
                                child: SizedBox(
                                  height: s.s45,
                                  child: Button(
                                    strTitle: widget.strPositiveTitle,
                                    backgroundColor: themeColor,
                                    fontColor: Colors.white,
                                    ontap: () async {
                                      if (widget.onPositivePressed != null) {
                                        await _closeDialog();
                                        widget.onPositivePressed!();
                                      } else {
                                        await _closeDialog();
                                      }
                                    },
                                    fontWeight: MyFontWeights.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: s.s10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

extension SizedBoxHelpers on num {
  // Original from common_extensions
  Widget get sb => SizedBox(height: toDouble());
  Widget get sbw => SizedBox(width: toDouble());

  // Original from my_cm
  SizedBox get hSizedBox => SizedBox(height: toDouble());
  SizedBox get wSizedBox => SizedBox(width: toDouble());
}

extension NavigatorHelpers on BuildContext {
  void push(Widget widget) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => widget));

  Future<dynamic> pushAndResult(Widget widget) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => widget));

  void pushAndRemoveUntil(Widget widget) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(builder: (context) => widget),
        (route) => false,
      );
}

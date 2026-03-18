//Container Decorations

import 'dart:io';

import 'package:{{project_name}}/utils/global_state.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:{{project_name}}/utils/import.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

enum ApiCallState { none, busy, success, failure }

enum LeaveStatus {
  pending('pending', 'Pending'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected'),
  cancelled('cancelled', 'Cancelled');

  final String key;
  final String value;
  
  const LeaveStatus(this.key, this.value);
  
  static LeaveStatus fromString(String? status) {
    if (status == null) return LeaveStatus.pending;
    return LeaveStatus.values.firstWhere(
      (e) => e.key == status.toLowerCase(),
      orElse: () => LeaveStatus.pending,
    );
  }
  
  Color get color {
    switch (this) {
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.cancelled:
        return Colors.grey;
    }
  }
}

// Helper methods
Color getLeaveStatusColor(String status) {
  return LeaveStatus.fromString(status).color;
}

String getLeaveText(String status) {
  return LeaveStatus.fromString(status).value;
}


enum ProjectStatus {
  planning('planning', 'Planning'),
  inProgress('in_progress', 'In Progress'),
  completed('completed', 'Completed'),
  onHold('on_hold', 'On Hold'),
  cancelled('cancelled', 'Cancelled');

  final String key;
  final String value;
  
  const ProjectStatus(this.key, this.value);
  
  static ProjectStatus fromString(String? status) {
    if (status == null) return ProjectStatus.inProgress;
    
    // Normalize the status string
    final normalizedStatus = status.toLowerCase().replaceAll(' ', '_');
    
    return ProjectStatus.values.firstWhere(
      (e) => e.key == normalizedStatus,
      orElse: () => ProjectStatus.inProgress,
    );
  }
  
  Color get color {
    switch (this) {
      case ProjectStatus.planning:
        return AppColors.blueColor;
      case ProjectStatus.inProgress:
        return AppColors.orange;
      case ProjectStatus.completed:
        return AppColors.greenColor;
      case ProjectStatus.onHold:
        return Colors.grey;
      case ProjectStatus.cancelled:
        return Colors.red;
    }
  }
}

printLog(dynamic strText) {
  if (!kReleaseMode) {
    debugPrint(strText.toString());
  }
}

void unFocusTextBox() {
  FocusManager.instance.primaryFocus?.unfocus();
}

/// Formats an amount/budget or any numeric value for display in Indian number format.
String formatAmountForDisplay(dynamic value) {
  if (value == null) return '';
  num? n;
  if (value is num) {
    n = value;
  } else if (value is String) {
    final trimmed = value.trim().replaceAll(',', '');
    if (trimmed.isEmpty) return '';
    n = num.tryParse(trimmed);
  }
  if (n == null) return value is String ? value : '';
  if (n.isNaN || n.isInfinite) return '';
  final isNegative = n < 0;
  n = n.abs();
  final intPart = n.truncate();
  final hasDecimal = n != intPart;
  final s = intPart.toString();
  if (s.length <= 3) {
    final result = hasDecimal ? '$s${(n - intPart).toString().substring(1)}' : s;
    return isNegative ? '-$result' : result;
  }
  final last3 = s.substring(s.length - 3);
  String rest = s.substring(0, s.length - 3);
  final groups = <String>[];
  while (rest.isNotEmpty) {
    if (rest.length <= 2) {
      groups.insert(0, rest);
      break;
    }
    groups.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  final formatted = '${groups.join(',')},$last3';
  final withDec = hasDecimal ? formatted + (n - intPart).toString().substring(1) : formatted;
  return isNegative ? '-$withDec' : withDec;
}

BorderRadius radius(double dblRadius) {
  return BorderRadius.circular(dblRadius);
}

//Add sizebox with height
Widget sb(double dblSize) {
  return SizedBox(height: dblSize);
}

//Add sizebox with width
Widget sbw(double dblSize) {
  return SizedBox(width: dblSize);
}



BoxDecoration radiusWithborder({Color? color}) {
  return BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: AppColors.borderColor, width: 1),
  );
}

bool isCommonDialodAlreadyDisplay = false;

void showCommonDialog(
  BuildContext context,
  String strTitle,
  String strMessage,
  String strPositiveButtonText,
  String strNegativeButtonText,
  bool isError, {
  Function()? onPositiveClick,
  Function()? onNegativeClick,
  bool? isDismiss,
}) {
  if (isCommonDialodAlreadyDisplay == false) {
    isCommonDialodAlreadyDisplay = true;

    showDialog(
      context: context,
      barrierDismissible: isDismiss ?? false,
      builder: (ctx) => ShowCustomDialog(
        strTitle,
        strMessage.replaceAll('<br>', '\n'),
        strPositiveButtonText,
        onPositivePressed: () {
          isCommonDialodAlreadyDisplay = false;
          if (onPositiveClick == null) {
          } else {
            onPositiveClick();
          }
        },
        strNegativeTitle: strNegativeButtonText,
        onNegativePressed: () {
          isCommonDialodAlreadyDisplay = false;
          if (onNegativeClick == null) {
          } else {
            onNegativeClick();
          }
        },
      ),
    );
  }
}

Future<dynamic> loginExpiredDialog({
  bool isError = false,
  Function()? onPositiveClick,
  Function()? onNegativeClick,
}) async {
  if (isCommonDialodAlreadyDisplay == false) {
    isCommonDialodAlreadyDisplay = true;

    return await showDialog(
      context: GlobalVariable.navState.currentContext!,
      barrierDismissible: false,
      builder: (ctx) => ShowCustomDialog(
        MyStrings.appName,
        MyStrings.sessionTimeOut,
        MyStrings.ok,
        onPositivePressed: () {
          isCommonDialodAlreadyDisplay = false;
          Navigator.of(ctx).pop(true);
        },
        strNegativeTitle: "",
        onNegativePressed: () {
          isCommonDialodAlreadyDisplay = false;
          if (onNegativeClick == null) {
            if (isError) {
              Navigator.of(ctx).pop();
            } else {
              Navigator.of(ctx).pop();
            }
          } else {
            Navigator.of(ctx).pop();
            onNegativeClick();
          }
        },
      ),
    );
  }
}

Future getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  var intUdid = "";
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    intUdid = iosDeviceInfo.identifierForVendor!;
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    intUdid = androidDeviceInfo.id;
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(PreferenceKey.prefIntUDID, intUdid);
  String deviceID = sharedPreferences.get(PreferenceKey.prefIntUDID).toString();

  globalState.strDeviceId = deviceID;
  return deviceID;
}

String getStringValue(dynamic value) {
  if (value == null || value == 'null') {
    return '';
  } else if (value == "") {
    return "";
  } else {
    return value;
  }
}

//On Tap Extension
extension WidgetExtension on Widget {
  Widget onTapEvent({
    required VoidCallback onTap,
    Key? key,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return GestureDetector(key: key, onTap: onTap, child: this);
  }
}

getErrorMsg(id) {
  switch (id) {
    case "500":
      return "Internal server error";
    case "400":
      return "Bad request";
    case "1001":
      return "Current password is invalid";
    case "1009":
      return "Verification code is expired";
    case "1002":
      return "Password attempt limit reached, Please try again later after some times.";
    case "1003":
      return "User not found";
    case "1004":
      return "Invalid password";
    case "1005":
      return "User is unauthorized";
    case "1006":
      return "Your account has been flagged for a password reset";
    case "1007":
      return "Invalid verification code";
    case "1008":
      return "You are not authorized to update the password at this time";
    case "1010":
      return "Your profile is inactive, please contact admin!";
    case "1011":
      return "You don't have web app access";
    case "1012":
      return "You cannot delete this because there are existing members";
    case "401":
      return "Invalid email or password";
    default:
      return null;
  }
}

showToast(String message) {
  double keyboardHeight = MediaQuery.of(
    GlobalVariable.navState.currentContext!,
  ).viewInsets.bottom;
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: (keyboardHeight != 0) ? ToastGravity.TOP : ToastGravity.BOTTOM,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String convertString(String input) {
  return input
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) {
        if (word.isEmpty) return "";
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

String shortName(String? name) {
  if (name != null && name.isNotEmpty) {
    List<String> parts = name.split(' ');
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials;
  } else {
    return "";
  }
}

fileName(String filePath) {
  String basename = path.basename(filePath);
  return basename;
}

///Convert to Hours & Min String format - 1
String convertTimeToLoggedFormat1({String? time = ""}) {
  if (time == null || time.isEmpty) return "";
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);

  if (hours != 0) {
    return 'logged ${hours}h ${minutes}mins';
  } else {
    return 'logged ${minutes}mins';
  }
}

///Convert to Hours & Min String format - 2
String convertTimeToLoggedFormat2({int minutes = 0}) {
  if (minutes < 60) {
    return '$minutes Mins';
  } else {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return '$hours Hrs $remainingMinutes Mins';
  }
}

String convertDaysFormat(String? day) {
  if (day == null || day.isEmpty) return "-";
  return "$day Days";
}


shimmer({required Widget child}) {
  return Shimmer.fromColors(
    baseColor: AppColors.greyColor.withValues(alpha: 0.1),
    highlightColor: offWhiteColor,
    child: child,
  );
}

Widget shimmerContainer(double height, double width) {
  return shimmer(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: greyColor,
      ),
      height: height,
      width: width,
    ),
  );
}

shimmerContainerH(double height) {
  return shimmer(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: greyColor,
      ),
      height: height,
    ),
  );
}

/// Convert bytes to KB
double bytesToKB(int bytes) {
  return bytes / 1024;
}

/// Convert bytes to MB
double bytesToMB(int bytes) {
  return bytes / (1024 * 1024);
}

String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return "$bytes B";
  } else if (bytes < (1024 * 1024)) {
    return "${bytesToKB(bytes).toStringAsFixed(2)} KB";
  } else {
    return "${bytesToMB(bytes).toStringAsFixed(2)} MB";
  }
}

class DottedLinePainter extends CustomPainter {
  final double height;
  final Color color;

  DottedLinePainter({required this.height, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 2, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startY < height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

isNun(value) {
  return value != null && value.isNotEmpty;
}

String firstCaps(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String convertToTitleCase(String input) {
  List<String> words = input.split('_');
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) return "";
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();
  return capitalizedWords.join(' ');
}

Future<File> renameFile(File pickedFile, String newFileName) async {
  final directory = await getTemporaryDirectory();
  String newPath = path.join(directory.path, newFileName);
  File newFile = await File(pickedFile.path).copy(newPath);
  return newFile;
}

// Function to convert image at a given path to binary (Uint8List)
Future<Uint8List?> convertImageToBinary(String imagePath) async {
  try {
    File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      Uint8List imageBytes = await imageFile.readAsBytes();
      return imageBytes;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

bool containsNbspBetweenAtAndClosingTag(String html) {
  int lastAtIndex = html.lastIndexOf('@');
  if (lastAtIndex == -1) return false;
  String textAfterAt = html.substring(lastAtIndex + 1);
  RegExp closingTagRegExp = RegExp(r'</\w+>');
  Match? firstClosingTagMatch = closingTagRegExp.firstMatch(textAfterAt);
  if (firstClosingTagMatch != null) {
    String textBetweenAtAndClosingTag = textAfterAt.substring(
      0,
      firstClosingTagMatch.start,
    );
    return textBetweenAtAndClosingTag.contains('&nbsp;');
  }
  return textAfterAt.contains('&nbsp;');
}

String extractTextAfterAtAndBeforeClosingTag(String html) {
  int lastAtIndex = html.lastIndexOf('@');
  if (lastAtIndex == -1) return '';
  String textAfterAt = html.substring(lastAtIndex + 1);
  RegExp tagRegExp = RegExp(r'</?\w+[^>]*>');
  Match? firstClosingTagMatch = tagRegExp.firstMatch(textAfterAt);
  if (firstClosingTagMatch != null) {
    String textBetweenAtAndClosingTag = textAfterAt.substring(
      0,
      firstClosingTagMatch.start,
    );
    return textBetweenAtAndClosingTag.trim();
  }
  return textAfterAt.trim();
}

///Check last character is empty or not
bool isLastCharEmpty(String plainText) {
  return plainText.isNotEmpty && RegExp(r'\s$').hasMatch(plainText);
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}



///Get nearest value of 5
int getNearestPartition(int value) {
  int lowerMultiple = (value ~/ 5) * 5;
  int higherMultiple = lowerMultiple + 5;
  if ((value - lowerMultiple) <= (higherMultiple - value)) {
    return lowerMultiple;
  } else {
    return higherMultiple;
  }
}

String formatMinutesToHours(num minutes) {
  double hours = minutes / 60;
  if (hours == hours.toInt()) {
    return '${hours.toInt()}';
  } else {
    return hours.toStringAsFixed(2);
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;
  MaxValueInputFormatter({required this.maxValue});
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value <= maxValue) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

///Common Tab Bar TextStyle
tabTextStyle() {
  return TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: FontSize.s14,
  );
}

/// Convert minutes to HH:mm
String formatMinutesToHHMM(int minutes) {
  if (minutes < 0) return "00:00";
  int hours = minutes ~/ 60;
  int mins = minutes % 60;
  return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
}

/// Convert HH:mm to minutes
int formatHHMMToMinutes(String time) {
  List<String> parts = time.split(':');
  if (parts.length != 2) return 0;
  int hours = int.tryParse(parts[0]) ?? 0;
  int mins = int.tryParse(parts[1]) ?? 0;
  return (hours * 60) + mins;
}

/// Global variable class
class GlobalVariable {
  static GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

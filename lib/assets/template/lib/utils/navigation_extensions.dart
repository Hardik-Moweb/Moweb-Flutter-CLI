import 'package:{{project_name}}/utils/import.dart';
import 'dart:io';

/// Extension and helper methods for Navigation
void pop(BuildContext context) {
  Navigator.of(context).pop();
}

void pop1(BuildContext context, dynamic arg) {
  Navigator.pop(context, arg);
}

// Push to next screen
void callNextScreen(BuildContext context, Object nextScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen as Widget,
      settings: RouteSettings(name: nextScreen.runtimeType.toString()),
    ),
  );
}

Future callNextScreenWithResult(BuildContext context, Object nextScreen) async {
  var action = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen as Widget,
      settings: RouteSettings(name: nextScreen.runtimeType.toString()),
    ),
  );
  return action;
}

void callNextScreenFromBottom(BuildContext context, Object nextScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen as Widget,
      settings: RouteSettings(name: nextScreen.runtimeType.toString()),
    ),
  );
}

void callNextScreenFinishOld(BuildContext context, Object nextScreen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => nextScreen as Widget,
      settings: RouteSettings(name: nextScreen.runtimeType.toString()),
    ),
    (route) => false,
  );
}

void callNextScreenAndClearStack(BuildContext context, Object nextScreen) {
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => nextScreen as Widget,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
      settings: RouteSettings(name: nextScreen.runtimeType.toString()),
    ),
    (_) => false,
  );
}

void exitApp() {
  showDialog(
    context: GlobalVariable.navState.currentContext!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleTextView(MyStrings.appName, fontWeight: FontWeight.w600),
              const SizedBox(height: 16.0),
              TitleTextView(MyStrings.sureToExit),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: TitleTextView(
                      'No',
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: TitleTextView(
                      'Yes',
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

import Flutter
import UIKit
// import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FirebaseApp.configure()
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let flavorChannel = FlutterMethodChannel(name: "{{ios_bundle}}/flavor",
                                              binaryMessenger: controller.binaryMessenger)
    flavorChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getFlavor" {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        /* @REPEAT_FLAVOR_START */
        if bundleId.hasSuffix(".{{flavor}}") {
            result("{{flavor}}")
            return
        }
        /* @REPEAT_FLAVOR_END */
        result("prod")
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import 'package:{{project_name}}/config/flavor_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../utils/import.dart';

final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
const String prefSoftUpdateDenied = "soft_update_denied_version";

Future<dynamic> checkVersion(BuildContext context) async {
  // Only check for version updates in production flavor
  if (FlavorConfig.instance.buildFlavor != BuildFlavors.prod) {
    printLog(
      "Skipping version check for ${FlavorConfig.instance.buildFlavor.name} flavor",
    );
    return false;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(
        seconds: 0,
      ), // Set to low for dev, increase in prod
    ),
  );

  await _remoteConfig.fetchAndActivate();

  final latestVersion = _remoteConfig.getString('latest_version');
  final minVersion = _remoteConfig.getString('minimum_version');

  final updateRequired = _remoteConfig.getBool('update_required');
  final updateMessage = _remoteConfig.getString('update_message');

  final playStore = _remoteConfig.getString('play_store');

  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  // Check if user has previously denied this version's soft update
  final deniedVersion = prefs.getString(prefSoftUpdateDenied);

  printLog("minVersion version: $minVersion");
  printLog("latestVersion version: $latestVersion");
  printLog("Current version: $currentVersion");

  if (!context.mounted) return false;
  // Check if minVersion is valid and not empty
  if (minVersion.isNotEmpty && _isVersionLower(currentVersion, minVersion)) {
    return showUpdateDialog(
      url: playStore,
      title: MyStrings.updateReq,
      message: updateMessage,
      force: true,
      context: context,
      currentVersion: currentVersion,
      versionUpdate: minVersion,
    );
  } else if (latestVersion.isNotEmpty &&
      _isVersionLower(currentVersion, latestVersion) &&
      updateRequired &&
      deniedVersion != latestVersion) {
    return showUpdateDialog(
      url: playStore,
      title: MyStrings.updateAvail,
      message: updateMessage,
      force: false,
      context: context,
      currentVersion: latestVersion,
      versionUpdate: latestVersion,
    );
  } else {
    return false;
  }
}

bool _isVersionLower(String current, String target) {
  // Handle empty or invalid versions
  if (current.isEmpty || target.isEmpty) {
    return false;
  }

  try {
    final currentParts = current.split('.').map(int.parse).toList();
    final targetParts = target.split('.').map(int.parse).toList();

    for (int i = 0; i < targetParts.length; i++) {
      if (currentParts.length <= i || currentParts[i] < targetParts[i]) {
        return true;
      } else if (currentParts[i] > targetParts[i]) {
        return false;
      }
    }
    return false;
  } catch (e) {
    printLog("Error parsing version: $e");
    return false;
  }
}

showUpdateDialog({
  required String url,
  required String title,
  required String message,
  required bool force,
  required BuildContext context,
  required String currentVersion,
  required String versionUpdate,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withValues(alpha: 0.2),
    builder: (context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: TitleTextView(
            title,
            fontSize: FontSize.s20,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextView(
                force
                    ? MyStrings.newVersionTextForceUpdate
                    : MyStrings.newVersionTextSoftUpdate,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  SizedBox(width: 3),
                  Expanded(
                    child: Row(
                      children: [
                        TitleTextView(MyStrings.version, fontSize: 16),
                        TitleTextView(
                          versionUpdate, // You can customize this
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Button(
                      strTitle: MyStrings.updateNow,
                      ontap: () async {
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ),
                  if (!force) const SizedBox(width: 10),
                  if (!force)
                    Expanded(
                      child: Button(
                        strTitle: MyStrings.later,
                        ontap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          // Store the denied version
                          await prefs.setString(
                            prefSoftUpdateDenied,
                            currentVersion,
                          );
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
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

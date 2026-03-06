import 'dart:io';
import 'dart:convert';

class ProjectGenerator {
  Future<void> start() async {
    stdout.write("Project Name: ");
    String projectName = stdin.readLineSync()!;

    stdout.write("Android Package: ");
    String androidPackage = stdin.readLineSync()!;

    stdout.write("iOS Bundle ID: ");
    String iosBundle = stdin.readLineSync()!;

    stdout.write("App Display Name: ");
    String displayName = stdin.readLineSync()!;

    // Flavor selection
    stdout.write(
      "Which flavors you want to setup? (default: prod) [comma separated, e.g: dev, stag, uat]: ",
    );
    String flavorInput = stdin.readLineSync()!;
    List<String> selectedFlavors = flavorInput
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    // Always ensure 'prod' is included as a default/fallback
    if (!selectedFlavors.contains('prod')) {
      selectedFlavors.insert(0, 'prod');
    }

    print("\nCloning template project...\n");

    var gitResult = await Process.run("git", [
      "clone",
      "-b",
      "features/project_template",
      "https://github.com/Hardik-Moweb/Flutter-Code-Structure",
      projectName,
    ]);

    if (gitResult.exitCode != 0) {
      print("Failed to clone template:\n${gitResult.stderr}");
      exit(1);
    }

    Directory projectDir = Directory(projectName);

    // Convert Project Name to a safe package name for {{project_name}} (e.g., "Loan Calculator" -> "loan_calculator")
    String packageName = projectName
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');

    await applyFlavors(projectDir, selectedFlavors);

    await replaceValues(projectDir, {
      "{{project_name}}": packageName,
      "{{android_package}}": androidPackage,
      "{{ios_bundle}}": iosBundle,
      "{{app_display_name}}": displayName,
    });

    // Firebase Configuration
    stdout.write("Do you want to configure Firebase? (y/n): ");
    String firebaseChoice = stdin.readLineSync()!.toLowerCase();
    if (firebaseChoice == 'y' || firebaseChoice == 'yes') {
      await setupFirebase(projectName, androidPackage, iosBundle);
    }

    print("\nRunning flutter pub get...\n");

    await Process.start(
      "flutter",
      ["pub", "get"],
      workingDirectory: projectName,
      runInShell: true,
    ).then((p) => stdout.addStream(p.stdout));

    print("\nProject created successfully 🚀 at: ${projectDir.absolute.path}");
  }

  Future<void> setupFirebase(
    String projectName,
    String androidPackage,
    String iosBundle,
  ) async {
    print("\nSetting up Firebase...\n");

    try {
      // 1. Check if firebase CLI is installed
      var checkFirebase = await Process.run("firebase", ["--version"]);
      if (checkFirebase.exitCode != 0) {
        print("Error: Firebase CLI is not installed. Please install it first.");
        return;
      }

      // 2. Firebase Login (will open browser if not logged in)
      print("Checking Firebase authentication...");
      await Process.start(
        "firebase",
        ["login"],
        runInShell: true,
        mode: ProcessStartMode.inheritStdio,
      );

      // 3. Find or Create Firebase Project
      print("Checking for existing Firebase projects...");
      var listProj = await Process.run("firebase", ["projects:list", "--json"]);
      String? firebaseProjectId;

      if (listProj.exitCode == 0) {
        try {
          final dynamic decoded = jsonDecode(listProj.stdout);
          final List<dynamic> projects =
              (decoded is Map && decoded.containsKey('result'))
              ? decoded['result']
              : decoded;

          for (var proj in projects) {
            if (proj['displayName']?.toString().toLowerCase() ==
                projectName.toLowerCase()) {
              firebaseProjectId = proj['projectId'];
              print(
                "Found existing project with name '$projectName': $firebaseProjectId",
              );
              break;
            }
          }
        } catch (e) {
          print("Warning: Could not check for existing projects: $e");
        }
      }

      if (firebaseProjectId == null) {
        // Create new project
        firebaseProjectId =
            "app-${projectName.toLowerCase().replaceAll(RegExp(r'\s+'), '-')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}";
        print("Creating Firebase project: $firebaseProjectId...");
        var createProj = await Process.run("firebase", [
          "projects:create",
          firebaseProjectId,
          "--display-name",
          projectName,
        ]);

        if (createProj.exitCode != 0) {
          print("Failed to create Firebase project: ${createProj.stderr}");
          return;
        }
      }

      // 4. Find or Create Apps
      print("Checking for existing Firebase apps...");
      var listApps = await Process.run("firebase", [
        "apps:list",
        "--project",
        firebaseProjectId,
        "--json",
      ]);

      String? androidAppId;
      String? iosAppId;

      if (listApps.exitCode == 0) {
        try {
          final dynamic decoded = jsonDecode(listApps.stdout);
          final List<dynamic> apps =
              (decoded is Map && decoded.containsKey('result'))
              ? decoded['result']
              : decoded;

          print("Found ${apps.length} apps in project.");
          for (var app in apps) {
            String platform = app['platform']?.toString().toUpperCase() ?? "";
            String appId = app['appId']?.toString() ?? "";

            // Firebase JSON can use different keys (packageId, bundleId, or namespace)
            String identifier =
                (app['namespace'] ?? app['packageId'] ?? app['bundleId'] ?? "")
                    .toString()
                    .trim();

            if (platform == "ANDROID" && identifier == androidPackage.trim()) {
              androidAppId = appId;
              print("Matched existing Android app: $androidAppId");
            } else if (platform == "IOS" && identifier == iosBundle.trim()) {
              iosAppId = appId;
              print("Matched existing iOS app: $iosAppId");
            }
          }
        } catch (e) {
          print("Error parsing apps list: $e. Raw output: ${listApps.stdout}");
        }
      } else {
        print("Error listing apps: ${listApps.stderr}");
      }

      // 4a. Create Android App if not exists
      if (androidAppId == null) {
        print("Registering Android app ($androidPackage)...");
        var createAndroid = await Process.run("firebase", [
          "apps:create",
          "ANDROID",
          projectName,
          "--package-name",
          androidPackage,
          "--project",
          firebaseProjectId,
          "--json",
        ]);
        if (createAndroid.exitCode == 0) {
          try {
            final dynamic decoded = jsonDecode(createAndroid.stdout);
            final dynamic result =
                (decoded is Map && decoded.containsKey('result'))
                ? decoded['result']
                : decoded;
            androidAppId = result['appId'];
          } catch (e) {}
        }
      }

      // 5. Create iOS App if not exists
      if (iosAppId == null) {
        print("Registering iOS app ($iosBundle)...");
        var createIos = await Process.run("firebase", [
          "apps:create",
          "IOS",
          projectName,
          "--bundle-id",
          iosBundle,
          "--project",
          firebaseProjectId,
          "--json",
        ]);
        if (createIos.exitCode == 0) {
          try {
            final dynamic decoded = jsonDecode(createIos.stdout);
            final dynamic result =
                (decoded is Map && decoded.containsKey('result'))
                ? decoded['result']
                : decoded;
            iosAppId = result['appId'];
          } catch (e) {}
        }
      }

      // 6. Download google-services.json for Android
      if (androidAppId != null) {
        print("Downloading Android configuration for App ID: $androidAppId...");
        var androidConfig = await Process.run("firebase", [
          "apps:sdkconfig",
          "ANDROID",
          androidAppId,
          "--project",
          firebaseProjectId,
        ]);

        if (androidConfig.exitCode == 0) {
          String output = androidConfig.stdout.toString();
          if (output.contains("JSON for your app:")) {
            String androidPath =
                "$projectName/android/app/src/prod/google-services.json";
            await Directory(
              "$projectName/android/app/src/prod",
            ).create(recursive: true);
            await File(
              androidPath,
            ).writeAsString(output.split("JSON for your app:").last.trim());
            print("Android configuration placed at $androidPath");
          } else {
            print(
              "Error: Could not find JSON content in Android sdkconfig output.",
            );
            print("Output was: $output");
          }
        } else {
          print("Error downloading Android sdkconfig: ${androidConfig.stderr}");
        }
      } else {
        print("Skipping Android download because App ID is null.");
      }

      // 7. Download GoogleService-Info.plist for iOS
      if (iosAppId != null) {
        print("Downloading iOS configuration for App ID: $iosAppId...");
        var iosConfig = await Process.run("firebase", [
          "apps:sdkconfig",
          "IOS",
          iosAppId,
          "--project",
          firebaseProjectId,
        ]);

        if (iosConfig.exitCode == 0) {
          String output = iosConfig.stdout.toString();
          if (output.contains("PropertyList for your app:")) {
            String iosPath =
                "$projectName/ios/Runner/GoogleService-Info_prod.plist";
            await Directory("$projectName/ios/Runner").create(recursive: true);
            await File(iosPath).writeAsString(
              output.split("PropertyList for your app:").last.trim(),
            );
            print("iOS configuration placed at $iosPath");
          } else {
            print(
              "Error: Could not find PropertyList content in iOS sdkconfig output.",
            );
            print("Output was: $output");
          }
        } else {
          print("Error downloading iOS sdkconfig: ${iosConfig.stderr}");
        }
      } else {
        print("Skipping iOS download because App ID is null.");
      }

      print("\nFirebase setup completed successfully! 🔥");
    } catch (e) {
      print("An error occurred during Firebase setup: $e");
    }
  }

  Future<void> applyFlavors(Directory directory, List<String> flavors) async {
    // 1. Handle folder/file duplication for those containing {{flavor}}
    List<FileSystemEntity> entities = directory.listSync(recursive: true);
    // Sort deepest first to avoid path issues
    entities.sort((a, b) => b.path.length.compareTo(a.path.length));

    for (var entity in entities) {
      String path = entity.path;
      String name = path.split(Platform.pathSeparator).last;

      if (name.contains("{{flavor}}")) {
        // This is a template for flavor-specific files or directories
        for (var flavor in flavors) {
          String newName = name.replaceAll("{{flavor}}", flavor);
          String newPath = path.replaceRange(
            path.length - name.length,
            path.length,
            newName,
          );

          if (entity is Directory) {
            await Directory(newPath).create(recursive: true);
          } else if (entity is File) {
            await entity.copy(newPath);
          }
        }
        // Delete the original template entity
        await entity.delete(recursive: true);
      }
    }

    // 2. Handle block repetition inside files
    entities = directory.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File) {
        try {
          String content = await entity.readAsString();

          // Regex to find blocks like /* @REPEAT_FLAVOR_START */ ... /* @REPEAT_FLAVOR_END */
          final regex = RegExp(
            r'/\*\s*@REPEAT_FLAVOR_START\s*\*/([\s\S]*?)/\*\s*@REPEAT_FLAVOR_END\s*\*/',
            multiLine: true,
          );

          String newContent = content.replaceAllMapped(regex, (match) {
            String template = match.group(1) ?? "";
            String expanded = "";
            for (var flavor in flavors) {
              expanded += template.replaceAll("{{flavor}}", flavor);
            }
            return expanded;
          });

          if (newContent != content) {
            await entity.writeAsString(newContent);
          }
        } catch (_) {}
      }
    }
  }

  Future<void> replaceValues(
    Directory directory,
    Map<String, String> values,
  ) async {
    // 1. Replace content inside all files
    List<FileSystemEntity> entities = directory.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File) {
        try {
          String content = await entity.readAsString();
          bool changed = false;
          values.forEach((key, value) {
            String newContent = content.replaceAll(key, value);
            if (newContent != content) {
              content = newContent;
              changed = true;
            }
          });
          if (changed) {
            await entity.writeAsString(content);
          }
        } catch (_) {}
      }
    }

    // 2. Rename files and directories containing placeholders in their names
    // We re-list and sort by path length (deepest first) to avoid invalidating parent paths
    entities = directory.listSync(recursive: true);
    entities.sort((a, b) => b.path.length.compareTo(a.path.length));

    for (var entity in entities) {
      String path = entity.path;
      String name = path.split(Platform.pathSeparator).last;
      String parentDir = path.substring(0, path.length - name.length);

      String newName = name;
      bool nameChanged = false;

      values.forEach((key, value) {
        if (newName.contains(key)) {
          // For android_package in directory names, we typically want dots to become slashes for proper folder depth
          if (key == "{{android_package}}" && entity is Directory) {
            newName = newName.replaceAll(
              key,
              value.replaceAll('.', Platform.pathSeparator),
            );
          } else {
            newName = newName.replaceAll(key, value);
          }
          nameChanged = true;
        }
      });

      if (nameChanged) {
        String newPath = parentDir + newName;
        // Ensure parent directories exist (important for the android_package dot-to-slash replacement)
        await Directory(Directory(newPath).parent.path).create(recursive: true);
        await entity.rename(newPath);
      }
    }
  }
}

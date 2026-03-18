import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:convert';

class ProjectGenerator {
  Future<void> start() async {
    String projectName = "";
    while (projectName.isEmpty || projectName.contains(" ")) {
      stdout.write("Project Name (no spaces): ");
      projectName = stdin.readLineSync()!.trim();
      if (projectName.contains(" ")) {
        print("Error: Project name should not contain spaces.");
      }
    }

    String androidPackage = "";
    while (!_isValidPackage(androidPackage)) {
      stdout.write("Android Package (e.g., com.app.name): ");
      androidPackage = stdin.readLineSync()!.trim().toLowerCase();
      if (!_isValidPackage(androidPackage)) {
        print(
          "Error: Invalid format. Use small case and at least 2 dots (e.g., com.company.app).",
        );
      }
    }

    String iosBundle = "";
    while (!_isValidPackage(iosBundle)) {
      stdout.write("iOS Bundle ID (e.g., com.app.name): ");
      iosBundle = stdin.readLineSync()!.trim().toLowerCase();
      if (!_isValidPackage(iosBundle)) {
        print(
          "Error: Invalid format. Use small case and at least 2 dots (e.g., com.company.app).",
        );
      }
    }

    stdout.write("App Display Name: ");
    String displayName = stdin.readLineSync()!.trim();

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

    try {
      var gitResult = await Process.run("git", [
        "clone",
        "-b",
        "features/project_template",
        "https://github.com/Hardik-Moweb/Flutter-Code-Structure",
        projectName,
      ]);

      if (gitResult.exitCode != 0) {
        print("Failed to clone template:\n${gitResult.stderr}");
        return;
      }
    } catch (e) {
      print("Error during clone: $e");
      return;
    }

    Directory projectDir = Directory(projectName);

    // Convert Project Name to a safe package name for {{project_name}} (e.g., "LoanCalculator" -> "loan_calculator")
    String packageName = projectName.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_]'),
      '_',
    );

    try {
      await applyFlavors(projectDir, selectedFlavors);

      await replaceValues(projectDir, {
        "{{project_name}}": packageName,
        "{{android_package}}": androidPackage,
        "{{ios_bundle}}": iosBundle,
        "{{app_display_name}}": displayName,
      });
    } catch (e) {
      print("Warning: Error during value replacement: $e. Continuing...");
    }

    // Firebase Configuration
    stdout.write("Do you want to configure Firebase? (y/n): ");
    String firebaseChoice = stdin.readLineSync()!.toLowerCase();
    if (firebaseChoice == 'y' || firebaseChoice == 'yes') {
      try {
        await setupFirebase(projectName, androidPackage, iosBundle);
        await enableFirebaseCode(projectDir);
      } catch (e) {
        print(
          "\nFirebase setup failed ($e). Continuing with project generation without Firebase...",
        );
      }
    }

    print("\nRunning flutter pub get...\n");

    try {
      await Process.start(
        "flutter",
        ["pub", "get"],
        workingDirectory: projectName,
        runInShell: true,
      ).then((p) => stdout.addStream(p.stdout));
    } catch (e) {
      print(
        "Warning: 'flutter pub get' failed ($e). You may need to run it manually. Continuing...",
      );
    }

    // ── GitHub Repository Setup ──────────────────────────────────────────────
    await setupGitHub(projectName, projectDir);

    print("\nProject created successfully 🚀 at: ${projectDir.absolute.path}");
  }

  // ──────────────────────────────────────────────────────────────────────────
  // GitHub Setup
  // ──────────────────────────────────────────────────────────────────────────

  /// Handles the full GitHub repository creation and initial push flow.
  ///
  /// Flow:
  ///  1. Check gh CLI is installed & authenticated.
  ///  2. Try to create `Flutter-<ProjectName>` under `Moweb-Technologies-Pvt-Ltd` org.
  ///     - If the user has permission → create, push.
  ///  3. If the user lacks permission → ask for a manager-provided repo URL,
  ///     re-init git to point at that URL, push.
  Future<void> setupGitHub(String projectName, Directory projectDir) async {
    print("\n──────────────────────────────────────────────");
    stdout.write("Do you want to set up a GitHub repository? (y/n): ");
    String choice = stdin.readLineSync()!.toLowerCase();
    if (choice != 'y' && choice != 'yes') {
      print("Skipping GitHub setup.");
      return;
    }

    // 1. Check gh CLI
    print("\nChecking GitHub CLI (gh)...");
    var ghCheck = await Process.run("gh", ["--version"]);
    if (ghCheck.exitCode != 0) {
      print(
        "Error: GitHub CLI (gh) is not installed. Please install it from https://cli.github.com and try again.",
      );
      return;
    }

    // 2. Check gh auth status
    print("Checking GitHub authentication...");
    var authStatus = await Process.run("gh", ["auth", "status"]);
    if (authStatus.exitCode != 0) {
      print("Not logged in to GitHub. Attempting login...");
      var loginProc = await Process.start(
        "gh",
        ["auth", "login"],
        runInShell: true,
        mode: ProcessStartMode.inheritStdio,
      );
      int loginExit = await loginProc.exitCode;
      if (loginExit != 0) {
        print("GitHub login failed. Skipping GitHub setup.");
        return;
      }
    }

    // 3. Get the logged-in GitHub username
    var whoami = await Process.run("gh", ["api", "user", "--jq", ".login"]);
    String ghUser = whoami.stdout.toString().trim();
    print("Logged in as: $ghUser");

    // 4. Determine repo name (Flutter-<ProjectName>)
    const String org = "Moweb-Technologies-Pvt-Ltd";
    String repoName = "Flutter-$projectName";
    String repoFullName = "$org/$repoName";

    print("\nChecking if you have permission to create a repo in $org...");

    // Check membership/permission in the org
    bool hasOrgPermission = await _checkOrgCreatePermission(org, ghUser);

    String? repoUrl;

    if (hasOrgPermission) {
      // 5a. Create the repo under the org
      print("You have org access. Creating repository: $repoFullName ...");
      repoUrl = await _createGitHubRepo(repoName: repoName, org: org);

      if (repoUrl == null) {
        print(
          "Failed to create repository under $org. Falling back to asking for repo URL...",
        );
        repoUrl = await _askForRepoUrl();
      }
    } else {
      // 5b. No permission — ask for manager-provided URL
      print(
        "\n⚠️  You do not have permission to create repositories in the $org organisation.",
      );
      print(
        "Please ask your manager to:\n"
        "  • Create the repository (Flutter-$projectName) in the $org org\n"
        "  • Grant you push access to it",
      );
      repoUrl = await _askForRepoUrl();
    }

    if (repoUrl == null || repoUrl.isEmpty) {
      print("No repository URL provided. Skipping GitHub push.");
      return;
    }

    // 6. Re-initialise git inside the generated project and push
    await _initAndPush(projectDir, repoUrl);
  }

  /// Returns true if the user is a member of the org with create-repo rights.
  Future<bool> _checkOrgCreatePermission(String org, String ghUser) async {
    try {
      // Check membership
      var memberCheck = await Process.run("gh", [
        "api",
        "orgs/$org/members/$ghUser",
        "--silent",
      ]);
      if (memberCheck.exitCode != 0) {
        return false; // Not a member
      }

      // Check the user's org role (member vs admin — admins can always create)
      var roleCheck = await Process.run("gh", [
        "api",
        "orgs/$org/memberships/$ghUser",
        "--jq",
        ".role",
      ]);
      String role = roleCheck.stdout.toString().trim();
      if (role == "admin") return true;

      // Check org's member_allowed_repository_creation_type policy
      var orgInfo = await Process.run("gh", [
        "api",
        "orgs/$org",
        "--jq",
        ".members_can_create_repositories",
      ]);
      String canCreate = orgInfo.stdout.toString().trim();
      return canCreate == "true";
    } catch (_) {
      return false;
    }
  }

  /// Creates a GitHub repository under [org] named [repoName] (private).
  /// Returns the SSH clone URL on success, or null on failure.
  Future<String?> _createGitHubRepo({
    required String repoName,
    required String org,
  }) async {
    try {
      var result = await Process.run("gh", [
        "repo",
        "create",
        "$org/$repoName",
        "--private",
        "--confirm",
        "--description",
        "Flutter project generated by CompanyAppCLI",
      ]);

      if (result.exitCode == 0) {
        // gh repo create prints the URL on stdout
        String output = result.stdout.toString().trim();
        // Extract URL (last line usually contains it)
        String url = output.split('\n').last.trim();
        if (url.startsWith("https://") || url.startsWith("git@")) {
          return url;
        }
        // Fallback: construct https URL
        return "https://github.com/$org/$repoName.git";
      } else {
        print("gh repo create error: ${result.stderr}");
        return null;
      }
    } catch (e) {
      print("Exception creating repo: $e");
      return null;
    }
  }

  /// Prompts the user to enter the manager-provided repo URL.
  Future<String?> _askForRepoUrl() async {
    print(
      "\nEnter the repository URL provided by your manager (HTTPS or SSH):",
    );
    stdout.write("Repo URL: ");
    String url = stdin.readLineSync()?.trim() ?? "";
    if (url.isEmpty) return null;
    return url;
  }

  /// Removes the cloned .git folder, re-inits, and pushes with "Initial Commit".
  Future<void> _initAndPush(Directory projectDir, String repoUrl) async {
    String path = projectDir.path;
    print("\nSetting up git repository...");

    // Remove the template's .git history
    final dotGit = Directory("$path/.git");
    if (await dotGit.exists()) {
      await dotGit.delete(recursive: true);
    }

    // Init fresh repo
    await _runGit(path, ["init"]);
    await _runGit(path, ["remote", "add", "origin", repoUrl]);

    // Stage all files
    await _runGit(path, ["add", "."]);

    // Set user info if not already configured (best-effort)
    var nameCheck = await Process.run("git", ["config", "user.name"]);
    if (nameCheck.stdout.toString().trim().isEmpty) {
      await _runGit(path, ["config", "user.name", "CompanyAppCLI"]);
      await _runGit(path, ["config", "user.email", "cli@moweb.in"]);
    }

    // Commit
    var commitResult = await Process.run("git", [
      "commit",
      "-m",
      "Initial Commit",
    ], workingDirectory: path);
    if (commitResult.exitCode != 0) {
      print("Warning: git commit failed:\n${commitResult.stderr}");
      return;
    }

    // Rename branch to main (standard)
    await _runGit(path, ["branch", "-M", "main"]);

    // Push
    print("Pushing code to $repoUrl ...");
    var pushResult = await Process.run("git", [
      "push",
      "-u",
      "origin",
      "main",
    ], workingDirectory: path);

    if (pushResult.exitCode == 0) {
      print("✅  Code pushed successfully to: $repoUrl");
    } else {
      print(
        "⚠️  Push failed. You may need to push manually.\n${pushResult.stderr}",
      );
    }
  }

  /// Helper to run a git command with stdout inherited so the user sees progress.
  Future<void> _runGit(String workingDir, List<String> args) async {
    var result = await Process.run("git", args, workingDirectory: workingDir);
    if (result.exitCode != 0) {
      print("git ${args.join(' ')} failed: ${result.stderr}");
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Validation
  // ──────────────────────────────────────────────────────────────────────────

  bool _isValidPackage(String name) {
    if (name.isEmpty) return false;
    if (name != name.toLowerCase()) return false;
    int dots = ".".allMatches(name).length;
    if (dots < 2) return false;
    return RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$').hasMatch(name);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Firebase Setup
  // ──────────────────────────────────────────────────────────────────────────

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

      // 2. Firebase Login Check
      print("Checking Firebase authentication...");
      var loginCheck = await Process.run("firebase", ["projects:list"]);
      if (loginCheck.exitCode != 0) {
        print("Not logged in to Firebase. Attempting login...");
        var loginProc = await Process.start(
          "firebase",
          ["login"],
          runInShell: true,
          mode: ProcessStartMode.inheritStdio,
        );

        int exitCode = await loginProc.exitCode;
        if (exitCode != 0) {
          print(
            "Firebase login failed. Skipping Firebase setup and continuing with project creation...",
          );
          return;
        }
      }

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
          } catch (_) {
            // ignore: app ID parsing is best-effort
          }
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
          } catch (_) {
            // ignore: app ID parsing is best-effort
          }
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
          String output = androidConfig.stdout.toString().trim();
          Match? match = RegExp(r'({\s*[\s\S]*})').firstMatch(output);

          if (match != null) {
            String configContent = match.group(0)!;
            String androidPath =
                "$projectName/android/app/src/prod/google-services.json";
            await Directory(
              "$projectName/android/app/src/prod",
            ).create(recursive: true);
            await File(androidPath).writeAsString(configContent);
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
          String output = iosConfig.stdout.toString().trim();
          Match? match = RegExp(r'(<\?xml[\s\S]*<\/plist>)').firstMatch(output);

          if (match != null) {
            String configContent = match.group(0)!;
            String iosPath =
                "$projectName/ios/Runner/GoogleService-Info_prod.plist";
            await Directory("$projectName/ios/Runner").create(recursive: true);
            await File(iosPath).writeAsString(configContent);
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

  // ──────────────────────────────────────────────────────────────────────────
  // Flavor Expansion
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> _copyDirectory(
    Directory source,
    Directory destination,
    String flavor,
  ) async {
    await destination.create(recursive: true);
    await for (var entity in source.list(recursive: false)) {
      String name = entity.path.split(Platform.pathSeparator).last;
      String newPath = p.join(
        destination.path,
        name.replaceAll("{{flavor}}", flavor),
      );

      if (entity is Directory) {
        await _copyDirectory(entity, Directory(newPath), flavor);
      } else if (entity is File) {
        await entity.copy(newPath);
      }
    }
  }

  Future<void> applyFlavors(Directory directory, List<String> flavors) async {
    // 1. Handle folder/file duplication for those containing {{flavor}}
    List<FileSystemEntity> entities = directory.listSync(recursive: true);
    entities.sort((a, b) => b.path.length.compareTo(a.path.length));

    for (var entity in entities) {
      if (entity is Directory) {
        String path = entity.path;
        String name = path.split(Platform.pathSeparator).last;

        if (name.contains("{{flavor}}")) {
          for (var flavor in flavors) {
            String newPath = path.replaceAll("{{flavor}}", flavor);
            await _copyDirectory(entity, Directory(newPath), flavor);
          }
          await entity.delete(recursive: true);
        }
      } else if (entity is File) {
        String path = entity.path;
        String name = path.split(Platform.pathSeparator).last;

        // If the file itself contains {{flavor}} but isn't inside a {{flavor}} directory
        // (because we already handled directories above and deleted them)
        if (name.contains("{{flavor}}") && await entity.exists()) {
          for (var flavor in flavors) {
            String newPath = path.replaceAll("{{flavor}}", flavor);
            await entity.copy(newPath);
          }
          await entity.delete();
        }
      }
    }

    // 2. Handle block repetition inside files
    // Supports two marker styles:
    //   /* @REPEAT_FLAVOR_START */ ... /* @REPEAT_FLAVOR_END */  (for .kts / .json / etc.)
    //   // @REPEAT_FLAVOR_START   ... // @REPEAT_FLAVOR_END      (for .dart / .yaml / etc.)
    entities = directory.listSync(recursive: true);
    for (var entity in entities) {
      if (entity is File) {
        try {
          String content = await entity.readAsString();

          // Block-comment style (/* ... */)
          final blockRegex = RegExp(
            r'/\*\s*@REPEAT_FLAVOR_START\s*\*/([\s\S]*?)/\*\s*@REPEAT_FLAVOR_END\s*\*/',
            multiLine: true,
          );

          // Line-comment style (// @REPEAT_FLAVOR_START ... // @REPEAT_FLAVOR_END)
          final lineRegex = RegExp(
            r'//\s*@REPEAT_FLAVOR_START([\s\S]*?)//\s*@REPEAT_FLAVOR_END',
            multiLine: true,
          );

          String newContent = content.replaceAllMapped(blockRegex, (match) {
            String template = match.group(1) ?? "";
            List<String> parts = [];
            for (int i = 0; i < flavors.length; i++) {
              String expanded = template.replaceAll("{{flavor}}", flavors[i]);
              // For JSON arrays: add comma after each item except the last
              if (i < flavors.length - 1) {
                // Trim trailing whitespace then append comma before newline
                expanded = expanded.trimRight();
                expanded += ",";
              }
              parts.add(expanded);
            }
            return parts.join('\n');
          });

          newContent = newContent.replaceAllMapped(lineRegex, (match) {
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

  // ──────────────────────────────────────────────────────────────────────────
  // Value Replacement
  // ──────────────────────────────────────────────────────────────────────────

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
        await Directory(Directory(newPath).parent.path).create(recursive: true);
        await entity.rename(newPath);
      }
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Enable Firebase code (uncomment)
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> enableFirebaseCode(Directory projectDir) async {
    print("\nEnabling Firebase code in the project...");

    final path = projectDir.path;

    // 1. Uncomment dependencies in pubspec.yaml
    final pubspecFile = File('$path/pubspec.yaml');
    if (await pubspecFile.exists()) {
      String content = await pubspecFile.readAsString();
      content = content.replaceAll('# firebase_core:', 'firebase_core:');
      content = content.replaceAll('# firebase_auth:', 'firebase_auth:');
      content = content.replaceAll('# google_sign_in:', 'google_sign_in:');
      content = content.replaceAll(
        '# flutter_local_notifications:',
        'flutter_local_notifications:',
      );
      content = content.replaceAll(
        '# firebase_messaging:',
        'firebase_messaging:',
      );
      content = content.replaceAll(
        '# firebase_remote_config:',
        'firebase_remote_config:',
      );
      await pubspecFile.writeAsString(content);
    }

    // 2. Uncomment plugins in gradle files
    final appGradleFile = File('$path/android/app/build.gradle.kts');
    if (await appGradleFile.exists()) {
      String content = await appGradleFile.readAsString();
      content = content.replaceAll(
        '// id("com.google.gms.google-services")',
        'id("com.google.gms.google-services")',
      );
      await appGradleFile.writeAsString(content);
    }

    final settingsGradleFile = File('$path/android/settings.gradle.kts');
    if (await settingsGradleFile.exists()) {
      String content = await settingsGradleFile.readAsString();
      content = content.replaceAll(
        '//    id("com.google.gms.google-services")',
        '    id("com.google.gms.google-services")',
      );
      await settingsGradleFile.writeAsString(content);
    }

    // 3. Uncomment Firebase in AppDelegate.swift
    final appDelegateFile = File('$path/ios/Runner/AppDelegate.swift');
    if (await appDelegateFile.exists()) {
      String content = await appDelegateFile.readAsString();
      content = content.replaceAll(
        '// import FirebaseCore',
        'import FirebaseCore',
      );
      content = content.replaceAll(
        '// FirebaseApp.configure()',
        'FirebaseApp.configure()',
      );
      await appDelegateFile.writeAsString(content);
    }

    // 4. Uncomment imports and initialization in main.dart
    final mainFile = File('$path/lib/main.dart');
    if (await mainFile.exists()) {
      String content = await mainFile.readAsString();
      content = content.replaceAll(
        '// import \'package:firebase_core/firebase_core.dart\';',
        'import \'package:firebase_core/firebase_core.dart\';',
      );
      content = content.replaceAll(
        '// import \'firebase_options.dart\';',
        'import \'firebase_options.dart\';',
      );
      content = content.replaceAll(
        '// import \'notification_service.dart\';',
        'import \'notification_service.dart\';',
      );
      content = content.replaceAll(
        '  // await Firebase.initializeApp(',
        '  await Firebase.initializeApp(',
      );
      content = content.replaceAll(
        '  //   options: DefaultFirebaseOptions.currentPlatform,',
        '    options: DefaultFirebaseOptions.currentPlatform,',
      );
      content = content.replaceAll('  // );', '  );');
      content = content.replaceAll(
        '  // final notificationService = NotificationServiceNew();',
        '  final notificationService = NotificationServiceNew();',
      );
      content = content.replaceAll(
        '  // await notificationService.init();',
        '  await notificationService.init();',
      );
      content = content.replaceAll(
        '  // await notificationService.getToken();',
        '  await notificationService.getToken();',
      );
      await mainFile.writeAsString(content);
    }

    // 5. Remove block comments from specific Firebase files
    final firebaseFiles = [
      '$path/lib/notification_service.dart',
      '$path/lib/firebase_options.dart',
    ];

    for (var filePath in firebaseFiles) {
      final file = File(filePath);
      if (await file.exists()) {
        String content = await file.readAsString();
        if (content.trim().startsWith('/*') && content.trim().endsWith('*/')) {
          content = content.trim();
          content = content.substring(2, content.length - 2).trim();
          await file.writeAsString(content);
        }
      }
    }

    // 6. Uncomment FCM token methods in AppPreference.dart
    final appPrefFile = File('$path/lib/utils/app_preference.dart');
    if (await appPrefFile.exists()) {
      String content = await appPrefFile.readAsString();
      content = content.replaceAll(
        '// final String _fcmToken = "fcm-token";',
        'final String _fcmToken = "fcm-token";',
      );
      content = content.replaceAll(
        '  /*\n  Future<void> saveFCMToken',
        '  Future<void> saveFCMToken',
      );
      content = content.replaceAll('  return;\n  }\n  */', '  return;\n  }');
      content = content.replaceAll(
        '  /*\n  Future<String> getFCMToken',
        '  Future<String> getFCMToken',
      );
      content = content.replaceAll(
        'return preferences.getString(_fcmToken) ?? "";\n  }\n  */',
        'return preferences.getString(_fcmToken) ?? "";\n  }',
      );
      await appPrefFile.writeAsString(content);
    }

    print("Firebase code enabled successfully! ✅");
  }
}

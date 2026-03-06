import 'dart:io';

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

    print("\nRunning flutter pub get...\n");

    await Process.start(
      "flutter",
      ["pub", "get"],
      workingDirectory: projectName,
      runInShell: true,
    ).then((p) => stdout.addStream(p.stdout));

    print("\nProject created successfully 🚀 at: ${projectDir.absolute.path}");
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

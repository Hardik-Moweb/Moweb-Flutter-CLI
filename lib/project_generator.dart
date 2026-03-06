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

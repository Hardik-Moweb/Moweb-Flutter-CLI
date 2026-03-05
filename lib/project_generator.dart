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

    await Process.run("git", [
      "clone",
      "-b",
      "project_template",
      "https://github.com/Hardik-Moweb/Flutter-Code-Structure",
      projectName,
    ]);

    Directory projectDir = Directory(projectName);

    await replaceValues(projectDir, {
      "{{project_name}}": projectName,
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

    print("\nProject created successfully 🚀");
  }

  Future<void> replaceValues(
    Directory directory,
    Map<String, String> values,
  ) async {
    await for (var entity in directory.list(recursive: true)) {
      if (entity is File) {
        try {
          String content = await entity.readAsString();

          values.forEach((key, value) {
            content = content.replaceAll(key, value);
          });

          await entity.writeAsString(content);
        } catch (_) {}
      }
    }
  }
}

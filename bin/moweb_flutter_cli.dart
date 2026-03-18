import 'dart:io';
import 'package:moweb_flutter_cli/project_generator.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("Usage: moweb_flutter_cli create");
    exit(0);
  }

  if (arguments.first == "create") {
    await ProjectGenerator().start();
  }
}

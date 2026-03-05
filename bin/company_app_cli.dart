import 'dart:io';
import 'package:company_app_cli/project_generator.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("Usage: company_app create");
    exit(0);
  }

  if (arguments.first == "create") {
    await ProjectGenerator().start();
  }
}

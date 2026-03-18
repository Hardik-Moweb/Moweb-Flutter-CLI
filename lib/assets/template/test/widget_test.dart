import 'package:{{project_name}}/application_page.dart';
import 'package:{{project_name}}/config/flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize a dummy flavor for testing since ApplicationPage depends on it
    FlavorConfig.init(buildFlavor: BuildFlavors.prod, variables: {});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ApplicationPage());

    // Basic check to see if it builds
    expect(find.byType(ApplicationPage), findsOneWidget);
  });
}

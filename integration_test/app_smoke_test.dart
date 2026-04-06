import 'package:aps_mobile/injection_container.dart' as di;
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    // Avoid network font fetching in tests (fonts.gstatic.com).
    GoogleFonts.config.allowRuntimeFetching = false;
    await di.sl.reset();
    await di.init();
    LocaleSettings.useDeviceLocale();
  });

  testWidgets('App launches (smoke)', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(child: const MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });
}

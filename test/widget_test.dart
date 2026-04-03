import 'package:aps_mobile/injection_container.dart' as di;
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.sl.reset();
    await di.init();
    LocaleSettings.useDeviceLocale();
  });

  testWidgets('MyApp builds with TranslationProvider', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(child: const MyApp()),
    );
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}

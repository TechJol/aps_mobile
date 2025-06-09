import 'package:aps_ci_keys/aps_ci_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApsClient', () {
    test('can be instantiated', () {
      expect(ApsKeys(), isNotNull);
    });
  });
}

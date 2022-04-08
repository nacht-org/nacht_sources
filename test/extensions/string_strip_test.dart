import 'package:chapturn_sources/src/extensions/string_strip.dart';
import 'package:test/test.dart';

class _TestData {
  final String text;
  final String pattern;
  final String expected;
  const _TestData(this.text, this.pattern, this.expected);

  void run() => expect(text.stripRight(pattern), expected);
}

void main() {
  group('stripRight', () {
    test('should remove segment if it matches the end', () {
      const data = [
        _TestData('://site.me/', '/', '://site.me'),
        _TestData('lorem ipsum', 'ipsum', 'lorem '),
        _TestData('lorem ipsum', 'lorem', 'lorem ipsum'),
      ];

      for (final row in data) {
        row.run();
      }
    });
  });
}

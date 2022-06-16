import 'package:nacht_sources/nacht_sources.dart';
import 'package:test/test.dart';

void main() {
  test('crawlers should have atleast one base url', () {
    for (final crawlerFactory in crawlers.values) {
      final baseUrls = crawlerFactory.meta().baseUrls;
      expect(baseUrls.length, greaterThanOrEqualTo(1));
    }
  });

  test('key of crawlers map should match their id', () {
    for (final entry in crawlers.entries) {
      expect(entry.key, entry.value.meta().id);
    }
  });
}

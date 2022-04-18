import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:test/test.dart';

void main() {
  test('all crawlers should have atleast one base url', () {
    for (final crawlerFactory in crawlers) {
      final baseUrls = crawlerFactory.meta().baseUrls;
      expect(baseUrls.length, greaterThanOrEqualTo(1));
    }
  });
}

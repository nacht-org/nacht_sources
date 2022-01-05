import 'package:chapturn_sources/src/impls/impls.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Scribblehub',
    () {
      const novelUrl = 'https://www.scribblehub.com/series/299966/devourer/';
      final crawler = ScribbleHub.make();

      test('should be able to parse novel', () async {
        final novel = await crawler.parseNovel(novelUrl);
        expect(novel, isA<Novel>());
      });
    },
    skip: 'Network intensive and takes a along time.',
  );
}

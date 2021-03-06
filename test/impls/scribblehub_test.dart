import 'package:nacht_sources/src/impls/impls.dart';
import 'package:nacht_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Scribblehub',
    () {
      const novelUrl = 'https://www.scribblehub.com/series/299966/devourer/';
      final crawler = ScribbleHub.basic();

      test('should be able to search novel', () async {
        final novels = await crawler.search('solo', 1);
        expect(novels, isA<List<Novel>>());
      });

      test('should be able to parse novel', () async {
        final novel = await crawler.fetchNovel(novelUrl);
        expect(novel, isA<Novel>());
      });

      test('should be able to get popular novels', () async {
        final novels = await crawler.fetchPopular(1);
        expect(novels, isA<List<Novel>>());
      });
    },
    skip: 'Network intensive and takes a along time.',
  );
}

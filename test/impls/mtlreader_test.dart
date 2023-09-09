import 'package:nacht_sources/src/impls/impls.dart';
import 'package:nacht_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'MTLReader',
    () {
      const novelUrl = 'https://mtlreader.com/novels/90';
      const chapterUrl = 'https://mtlreader.com/novels/90/chapters/18438';
      final crawler = MTLReader.basic();

      test('should be able fetch popular', () async {
        final novels = await crawler.fetchPopular(1);
        expect(novels, isA<List<Novel>>());
      });

      test('should be able fetch search', () async {
        final novels = await crawler.search("ace", 1);
        expect(novels, isA<List<Novel>>());
      });

      test('should be able to parse novel', () async {
        final novel = await crawler.fetchNovel(novelUrl);
        expect(novel, isA<Novel>());
      });

      test('should be able to parse chapter', () async {
        final content = await crawler.fetchChapterContent(chapterUrl);
        expect(content, isA<String?>());
      });
    },
    skip: 'Network intensive and takes a along time.',
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

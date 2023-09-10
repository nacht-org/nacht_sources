import 'package:nacht_sources/src/impls/foxaholic.dart';
import 'package:nacht_sources/src/impls/impls.dart';
import 'package:nacht_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Foxaholic',
    () {
      const novelUrl =
          'https://www.foxaholic.com/novel/a-poem-of-eternal-love/';
      const chapterUrl =
          'https://www.foxaholic.com/novel/the-prestigious-familys-young-lady-and-the-farmer/chapter-14-part-2/';
      final crawler = Foxaholic.basic();

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

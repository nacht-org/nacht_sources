import 'package:chapturn_sources/src/impls/impls.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'RoyalRoad',
    () {
      const novelUrl = 'https://www.royalroad.com/fiction/52322/space-dork';
      const chapterUrl =
          'https://www.royalroad.com/fiction/52322/space-dork/chapter/865223/chapter-1';
      final crawler = RoyalRoad.make();

      test('should be able to parse novel', () async {
        final novel = await crawler.parseNovel(novelUrl);
        expect(novel, isA<Novel>());
      });

      test('should be able to parse chapter', () async {
        final chapter = Chapter(index: -1, title: '', url: chapterUrl);
        await crawler.parseChapter(chapter);
        expect(chapter, isA<Chapter>());
      });
    },
    skip: 'Network intensive and takes a along time.',
    timeout: const Timeout(Duration(minutes: 1)),
  );
}

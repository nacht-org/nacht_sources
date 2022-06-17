import 'package:nacht_sources/src/impls/impls.dart';
import 'package:nacht_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'RoyalRoad',
    () {
      const novelUrl = 'https://www.royalroad.com/fiction/52322/space-dork';
      const chapterUrl =
          'https://www.royalroad.com/fiction/52322/space-dork/chapter/865223/chapter-1';
      final crawler = RoyalRoad.basic();

      test('should be able to parse novel', () async {
        final novel = await crawler.parseNovel(novelUrl);
        expect(novel, isA<Novel>());
      });

      test('should be able to parse chapter', () async {
        final content = await crawler.fetchChapterContent(chapterUrl);
        expect(content, isA<String?>());
      });
    },
    skip: 'Network intensive and takes a along time.',
    timeout: const Timeout(Duration(minutes: 1)),
  );
}

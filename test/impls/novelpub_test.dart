import 'package:nacht_sources/src/impls/impls.dart';
import 'package:nacht_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'NovelPub',
    () {
      const novelUrl =
          'https://www.novelpub.com/novel/top-tier-providence-secretly-cultivate-for-a-thousand-years-12032016';
      const chapterUrl =
          'https://www.novelpub.com/novel/top-tier-providence-secretly-cultivate-for-a-thousand-years-12032016/1208-chapter-1';
      final crawler = NovelPub.basic();

      test('should be able to parse novel', () async {
        final novels = await crawler.parsePopular(1);
        expect(novels, isA<List<Novel>>());
      });

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
  );
}

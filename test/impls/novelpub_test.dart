import 'package:chapturn_sources/src/impls/impls.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group(
    'NovelPub',
    () {
      const novelUrl =
          'https://www.novelpub.com/novel/top-tier-providence-secretly-cultivate-for-a-thousand-years-12032016';
      const chapterUrl =
          'https://www.novelpub.com/novel/top-tier-providence-secretly-cultivate-for-a-thousand-years-12032016/1208-chapter-1';
      final crawler = NovelPub.make();

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
  );
}

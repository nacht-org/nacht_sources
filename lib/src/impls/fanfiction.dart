import 'package:annotations/annotations.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';

@RegisterCrawler('com.fanfiction')
class FanFiction extends Crawler with ParseNovel {
  FanFiction.basic() : super(client: Crawler.defaultClient(), meta: _meta);
  FanFiction.custom(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    id: 'com.fanfiction',
    name: 'FanFiction',
    lang: 'mixed',
    version: SemanticVersion(0, 1, 0),
    baseUrls: ['https://www.fanfiction.net/', 'https://m.fanfiction.net/'],
    support: Support.browserOnly,
    workTypes: [OriginalWork()],
    attributes: [Attribute.fanfiction],
  );

  static Meta getMeta() => _meta;

  @override
  Future<Novel> parseNovel(String url) async {
    final doc = await pullDoc(url);

    final attributes =
        doc.selectText('.xgray.xcontrast_txt')!.split(' - ').toList();

    String? thumbnail;
    final imageElement = doc.select('#profile_top img.cimage');
    if (imageElement != null) {
      thumbnail = 'https:${imageElement.attributes["src"]}';
    }

    final novel = Novel(
      title: doc.selectText('#profile_top b.xcontrast_txt, #content b') ?? '',
      thumbnailUrl: thumbnail,
      url: url,
      lang: attributes[1],
    );

    final id = Uri.parse(url).path.split('/')[2];
    final chapterSelect = doc.select('#chap_select, select#jump');

    final volume = novel.singleVolume();
    if (chapterSelect != null) {
      // multi chapter
      volume.chapters = chapterSelect
          .selectAll('option')
          .mapIndexed(
            (i, element) => Chapter(
              index: i,
              title: element.text.trim(),
              url:
                  'https://www.fanfiction.net/s/$id/${element.attributes["value"]}',
            ),
          )
          .toList();
    } else {
      // single chapter
      volume.chapters = [
        Chapter(
          index: 0,
          title: novel.title,
          url: url,
        ),
      ];
    }

    return novel;
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    final doc = await pullDoc(chapter.url);

    chapter.content = doc.select('#storytext, #storycontent')?.outerHtml;
  }
}

import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';

class FanFiction extends NovelCrawler {
  FanFiction.make() : super(client: Crawler.defaultClient(), meta: _meta);
  FanFiction.makeWith(Client client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: 'FanFiction',
    lang: 'mixed',
    updated: DateHolder(2022, 1, 8),
    baseUrls: {'https://www.fanfiction.net/', 'https://m.fanfiction.net/'},
    support: HasSupport.browserOnly,
    workTypes: [OriginalWork()],
    attributes: [Attribute.fanfiction],
  );

  static Meta constMeta() => _meta;

  @override
  Future<Novel> parseNovel(String url) async {
    final doc = await pullDoc(url);

    final attributes = doc
        .querySelector('.xgray.xcontrast_txt')!
        .text
        .trim()
        .split(' - ')
        .toList();

    String? thumbnail;
    final imageElement = doc.querySelector('#profile_top img.cimage');
    if (imageElement != null) {
      thumbnail = 'https:${imageElement.attributes["src"]}';
    }

    final novel = Novel(
      title: doc
              .querySelector('#profile_top b.xcontrast_txt, #content b')
              ?.text
              .trim() ??
          '',
      thumbnailUrl: thumbnail,
      url: url,
      lang: attributes[1],
    );

    final id = Uri.parse(url).path.split('/')[2];
    final chapterSelect = doc.querySelector('#chap_select, select#jump');

    final volume = novel.singleVolume();
    if (chapterSelect != null) {
      // multi chapter
      volume.chapters = chapterSelect
          .querySelectorAll('option')
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

    chapter.content = doc.querySelector('#storytext, #storycontent')?.outerHtml;
  }
}

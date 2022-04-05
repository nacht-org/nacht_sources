import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:chapturn_sources/src/mixins/mixins.dart';

import 'package:dio/dio.dart';

@registerCrawler
class RoyalRoad extends Crawler
    with HtmlParsing
    implements NovelParse, NovelSearch {
  RoyalRoad.make() : super(client: Crawler.defaultClient(), meta: _meta);
  RoyalRoad.makeWith(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: "RoyalRoad",
    lang: "en",
    updated: DateHolder(2022, 14, 03),
    baseUrls: ["https://www.royalroad.com/"],
  );

  static Meta constMeta() => _meta;

  @override
  Future<List<Novel>> search(String query) async {
    final url =
        "https://www.royalroad.com/fictions/search?title=$query&page={1}";
    final doc = await pullDoc(url);

    final novels = <Novel>[];
    for (final div in doc.querySelectorAll(".fiction-list-item")) {
      final a = div.querySelector(".fiction-title a");
      if (a == null) continue;

      var thumbnailUrl = div.querySelector("img")?.attributes['src'];
      if (thumbnailUrl != null) {
        thumbnailUrl = meta.absoluteUrl(thumbnailUrl);
      }

      final novel = Novel(
        title: a.text.trim(),
        url: meta.absoluteUrl(a.attributes['href']!),
        thumbnailUrl: thumbnailUrl,
        lang: 'en',
      );

      novels.add(novel);
    }

    return novels;
  }

  @override
  Future<Novel> parseNovel(String url) async {
    final doc = await pullDoc(url);

    final novel = Novel(
      title: doc.querySelector('h1[property="name"]')?.text.trim() ?? '',
      author: doc.querySelector('span[property="name"]')?.text.trim(),
      thumbnailUrl: doc
          .querySelector('.page-content-inner .thumbnail')
          ?.attributes['src'],
      description: doc
          .querySelectorAll('.description > [property="description"] > p')
          .map((e) => e.text.trim())
          .toList(),
      url: url,
      lang: 'en',
    );

    for (final a in doc.querySelectorAll('a.label[href*="tag"]')) {
      novel.addMeta("subject", a.text.trim());
    }

    final volume = novel.singleVolume();
    for (final tr in doc.querySelectorAll("tbody > tr")) {
      final a = tr.querySelector("a[href]");
      if (a == null) {
        continue;
      }

      final chapter = Chapter(
        index: volume.chapters.length,
        title: a.text.trim(),
        url: meta.absoluteUrl(a.attributes['href'] ?? ''),
      );

      volume.chapters.add(chapter);
    }

    return novel;
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    final doc = await pullDoc(chapter.url);

    final contentTree = doc.querySelector(".chapter-content");
    cleanNodeTree(contentTree);

    chapter.content = contentTree?.outerHtml;
  }
}

import 'package:annotations/annotations.dart';
import 'package:dio/dio.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/mixins/mixins.dart';

@registerCrawler
class RoyalRoad extends Crawler
    with HtmlParser
    implements ParseNovel, ParseSearch, ParsePopular {
  RoyalRoad.make() : super(client: Crawler.defaultClient(), meta: _meta);
  RoyalRoad.makeWith(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: "RoyalRoad",
    lang: "en",
    version: SemanticVersion(0, 2, 2),
    baseUrls: ["https://www.royalroad.com/"],
    features: {Feature.search, Feature.popular},
  );

  static Meta constMeta() => _meta;

  @override
  Future<List<Novel>> search(String query, int page) async {
    final url =
        "https://www.royalroad.com/fictions/search?title=$query&page=$page";
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

    final status = NovelStatus.parse(
      doc.querySelectorAll('.fiction-info .label')[1].text,
    );

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
      status: status,
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

      final unixtime = tr.querySelector('time')?.attributes['unixtime'];

      DateTime? updated;
      if (unixtime != null) {
        updated = DateTime.fromMillisecondsSinceEpoch(
          int.parse(unixtime) * 1000,
          isUtc: true,
        );
      }

      final chapter = Chapter(
        index: volume.chapters.length,
        title: a.text.trim(),
        url: meta.absoluteUrl(a.attributes['href'] ?? ''),
        updated: updated,
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

  @override
  String buildPopularUrl(int page) =>
      'https://www.royalroad.com/fictions/weekly-popular?page=$page';

  @override
  Future<List<Novel>> parsePopular(int page) async {
    final url = buildPopularUrl(page);
    final doc = await pullDoc(url);

    final novels = <Novel>[];
    for (final item in doc.querySelectorAll('.fiction-list-item')) {
      final novel = Novel(
        title: item.querySelector('.fiction-title')?.text.trim() ?? '',
        thumbnailUrl: item.querySelector('img')?.attributes['src'],
        url: meta.absoluteUrl(item.querySelector('a')!.attributes['href']!),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }
}

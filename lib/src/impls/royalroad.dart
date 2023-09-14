import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';

class RoyalRoad extends Crawler with CleanHtml, ParseNovel {
  RoyalRoad.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  RoyalRoad.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.royalroad',
    name: "RoyalRoad",
    lang: "en",
    version: SemanticVersion(0, 2, 2),
    baseUrls: ["https://www.royalroad.com/"],
    logo: Logo.github("com.royalroad.png", 0xfff4a814),
    features: {Feature.search, Feature.popular},
  );

  static Meta getMeta() => _meta;

  @override
  Future<List<Novel>> search(String query, int page) async {
    final url =
        "https://www.royalroad.com/fictions/search?title=$query&page=$page";
    final doc = await pullDoc(url);

    final novels = <Novel>[];
    for (final div in doc.selectAll(".fiction-list-item")) {
      final a = div.select(".fiction-title a");
      if (a == null) continue;

      var thumbnailUrl = div.select("img")?.attributes['src'];
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
  Future<Novel> fetchNovel(String url) async {
    final doc = await pullDoc(url);

    final statusSpans =
        doc.select(".fiction-info > .portlet.row")?.selectAll("span");
    final secondSpan =
        statusSpans != null && statusSpans.length > 2 ? statusSpans[1] : null;
    final status = NovelStatus.parse(secondSpan?.text.trim());

    final novel = Novel(
      title: doc.selectText('.fic-header h1') ?? '',
      author: doc.selectText('.fic-header h4 a'),
      thumbnailUrl:
          doc.select('.page-content-inner .thumbnail')?.attributes['src'],
      description: doc.selectAllText('.description > div > p'),
      status: status,
      url: url,
      lang: 'en',
    );

    for (final a in doc.selectAll('a.label[href*="tag"]')) {
      novel.addMeta("subject", a.text.trim());
    }

    final volume = novel.singleVolume();
    for (final tr in doc.selectAll("tbody > tr")) {
      final a = tr.select("a[href]");
      if (a == null) {
        continue;
      }

      final unixtime = tr.select('time')?.attributes['unixtime'];

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
  Future<String?> fetchChapterContent(String url) async {
    final doc = await pullDoc(url);

    final contentTree = doc.select(".chapter-content");
    cleanNodeTree(contentTree);

    return contentTree?.outerHtml;
  }

  @override
  String buildPopularUrl(int page) =>
      'https://www.royalroad.com/fictions/weekly-popular?page=$page';

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final url = buildPopularUrl(page);
    final doc = await pullDoc(url);

    final novels = <Novel>[];
    for (final item in doc.selectAll('.fiction-list-item')) {
      final novel = Novel(
        title: item.selectText('.fiction-title') ?? '',
        thumbnailUrl: item.select('img')?.attributes['src'],
        url: meta.absoluteUrl(item.select('a')!.attributes['href']!),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }
}

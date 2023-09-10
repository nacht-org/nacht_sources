import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';
import 'package:rechron/rechron.dart' as rechron;

final dateFormat = DateFormat("MMMM d, yyyy");

class Foxaholic extends Crawler with CleanHtml, ParseNovel {
  Foxaholic.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  Foxaholic.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.foxaholic',
    name: "Foxaholic",
    lang: "en",
    version: SemanticVersion(0, 1, 0),
    baseUrls: [
      "https://foxaholic.com/",
      "https://www.foxaholic.com/",
      "https://18.foxaholic.com/",
      "https://global.foxaholic.com/",
    ],
    features: {Feature.search, Feature.popular},
  );

  static Meta getMeta() => _meta;

  @override
  Future<Novel> fetchNovel(String url) async {
    Document doc = await pullDoc(url);

    final titleElement = doc.select('meta[property="og:title"]');
    if (titleElement == null) {
      throw CrawlerException("Title not found");
    }

    final thumbnailSrc =
        doc.select(".summary_image a img")?.attributes['data-src'];

    final author = doc
        .selectAll('.author-content a[href*="novel-author"]')
        .map((e) => e.text.clean())
        .join(" ");

    final novel = Novel(
      title: titleElement.attributes['content']!,
      author: author,
      description: doc.selectAllText(".summary__content > p"),
      thumbnailUrl:
          thumbnailSrc == null ? null : meta.absoluteUrl(thumbnailSrc, url),
      url: url,
      lang: meta.lang,
    );

    final genreElements = doc.selectAll("a[href*='/novel-genre/']");
    for (final element in genreElements) {
      novel.addMeta("subject", element.text.clean());
    }

    final statusElement = doc
        .selectAll('.post-status > .post-content_item')
        .where(
          (element) =>
              element.select(".summary-heading")?.text.trim() == "Novel",
        )
        .map((e) => e.select(".summary-content"))
        .firstOrNull;

    if (statusElement != null) {
      novel.status = NovelStatus.parse(statusElement.text);
    }

    if (url.contains("18.foxaholic.com") ||
        url.contains("global.foxaholic.com")) {
      final parsedUrl = Uri.parse(url);
      final baseUrl = "${parsedUrl.scheme}://${parsedUrl.host}";

      final novelId =
          doc.select("#manga-chapters-holder")!.attributes["data-id"]!;
      final payload = {"action": "manga_get_chapters", "manga": novelId};

      final response = await client.post(
        "$baseUrl/wp-admin/admin-ajax.php",
        data: FormData.fromMap(payload),
      );
      doc = parser.parse(response.data);
    }

    novel.volumes = volumes(doc);

    return novel;
  }

  List<Volume> volumes(Document doc) {
    final chapters = <Chapter>[];

    final chapterElements = doc.selectAll(".wp-manga-chapter");
    for (final element in chapterElements.reversed) {
      final a = element.select('a')!;

      final releaseDateText =
          element.select(".chapter-release-date")?.text.trim();

      DateTime? updatedAt;
      if (releaseDateText != null) {
        try {
          updatedAt = dateFormat.parse(releaseDateText);
        } on FormatException {
          updatedAt = rechron.tryParse(releaseDateText);
        }
      }

      final chapter = Chapter(
        index: chapters.length,
        title: a.text.trim(),
        url: meta.absoluteUrl(a.attributes['href']!),
        updated: updatedAt,
      );

      chapters.add(chapter);
    }

    return [Volume.def(chapters)];
  }

  @override
  Future<String?> fetchChapterContent(String url) async {
    Document doc = await pullDoc(url);

    final blocked = doc
        .selectAll("a.text-left")
        .where((element) => element.text.contains("Chapter"))
        .firstOrNull;

    if (blocked != null) {
      doc = await pullDoc(blocked.attributes['href']!);
    }

    final badSelectors = [
      '.foxaholic-publift-manga-chapter',
      "#text-chapter-toolbar",
      '.foxaholic-after-chapter-manga',
    ];

    for (final element in doc.selectAll(badSelectors.join(","))) {
      element.remove();
    }

    final contents = doc.select(".entry-content_wrap")!;
    cleanNodeTree(contents);

    final root = findRoot(contents);
    return root.outerHtml;
  }

  @override
  Future<List<Novel>> search(String query, int page) async {
    final url =
        "https://www.foxaholic.com/page/$page/?s=$query&post_type=wp-manga";
    final doc = await pullDoc(url);
    return parseSearch(doc);
  }

  List<Novel> parseSearch(Document doc) {
    final novels = <Novel>[];
    for (final tab in doc.selectAll(".c-tabs-item__content")) {
      final a = tab.select(".post-title h3 a");
      if (a == null) continue;

      final novel = Novel(
        title: a.text.clean(),
        url: meta.absoluteUrl(a.attributes['href']!),
        thumbnailUrl: tab.select("img")?.attributes['data-src'],
        lang: meta.lang,
      );

      novels.add(novel);
    }
    return novels;
  }

  @override
  String buildPopularUrl(int page) {
    return "https://www.foxaholic.com/page/$page/?s&post_type=wp-manga&m_orderby=trending";
  }

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final doc = await pullDoc(buildPopularUrl(page));
    return parseSearch(doc);
  }
}

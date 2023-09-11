import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';

class NovelFullTemplate extends Crawler with CleanHtml, ParseNovel {
  NovelFullTemplate({required super.options, required super.meta});

  @override
  Future<Novel> fetchNovel(String url) async {
    final response = await client.get<String>(
      url,
      options: Options(
        responseType: ResponseType.plain,
      ),
    );

    final hasChapterOptionsUrl =
        response.data!.contains("var ajaxChapterOptionUrl =");

    final doc = parser.parse(response.data);
    final thumbnailUrl = doc.select(".book img")?.attributes["src"];

    final novel = Novel(
      title: doc.selectText(".title") ?? '',
      author: parseAuthor(doc),
      thumbnailUrl:
          thumbnailUrl == null ? null : meta.absoluteUrl(thumbnailUrl),
      description: selectDescription(doc),
      url: url,
      lang: meta.lang,
      volumes: await parseVolumes(url, doc, hasChapterOptionsUrl),
    );

    final statusText = selectStatus(doc);
    if (statusText != null) {
      novel.status = NovelStatus.parse(statusText.trim());
    }

    final elements = doc.selectAll(".info a[href*='/genre']");
    for (final element in elements) {
      novel.addMeta("subject", element.text.trim());
    }

    return novel;
  }

  List<String> selectDescription(Document doc) {
    final paragraphs = doc.selectAllText(".desc-text > p");
    if (paragraphs.isNotEmpty) {
      return paragraphs;
    }

    final paragraph = doc.selectText(".desc-text");
    return [if (paragraph != null) paragraph];
  }

  String? selectStatus(Document doc) {
    return doc.selectText("a[href^='/status/']");
  }

  String? parseAuthor(Document doc) {
    const possibleSelectors = [
      "a[href*='/a/']",
      "a[href*='/au/']",
      "a[href*='/authors/']",
      "a[href*='/author/']",
      "a[href*='/novel-bin-author/']",
    ];

    return doc.selectAllText(possibleSelectors.join(",")).join(",");
  }

  String buildChapterListUrl(String novelId, bool hasChapterOptionsUrl) {
    return hasChapterOptionsUrl
        ? "${meta.baseUrl}/ajax-chapter-option?novelId=$novelId"
        : "${meta.baseUrl}/ajax-chapter-archive?novelId=$novelId";
  }

  Future<List<Volume>> parseVolumes(
    String novelUrl,
    Document novelDoc,
    bool hasChapterOptionsUrl,
  ) async {
    final chapters = <Chapter>[];
    final novelId =
        novelDoc.select("#rating[data-novel-id]")!.attributes["data-novel-id"];

    final url = buildChapterListUrl(novelId!, hasChapterOptionsUrl);

    final doc = await pullDoc(url);
    final elements =
        doc.selectAll("ul.list-chapter > li > a[href], select > option[value]");
    for (final element in elements) {
      final url = element.attributes["href"] ?? element.attributes["value"];
      if (url == null) continue;

      final chapter = Chapter(
        index: chapters.length,
        title: element.text.trim(),
        url: meta.absoluteUrl(url),
      );

      chapters.add(chapter);
    }

    return [Volume.def(chapters)];
  }

  @override
  Future<String?> fetchChapterContent(String url) async {
    final doc = await pullDoc(url);
    final content = doc.select("#chr-content, #chapter-content");

    final badSelectors = [
      ".ads, .ads-holder, .ads-middle",
      "div[align='left']",
      "img[src*='proxy?container=focus']",
      "div[id^='pf-']",
    ];

    for (final selector in badSelectors) {
      for (final element in doc.selectAll(selector)) {
        element.remove();
      }
    }

    cleanNodeTree(content);

    for (final element in content!.selectAll("p, div")) {
      if (element.text.trim().isEmpty) {
        element.remove();
      }
    }

    return content.outerHtml;
  }

  String buildSearchUrl(String query, int page) {
    return "${meta.baseUrl}/search?keyword=$query&page=$page";
  }

  @override
  Future<List<Novel>> search(String query, int page) async {
    final url = buildSearchUrl(query, page);
    final doc = await pullDoc(url);
    return parseSearch(url, doc);
  }

  // Popular

  @override
  String buildPopularUrl(int page) => '${meta.baseUrl}/most-popular?page=$page';

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final url = buildPopularUrl(page);
    final doc = await pullDoc(url);
    return parseSearch(url, doc);
  }

  Future<List<Novel>> parseSearch(String url, Document doc) async {
    final novels = <Novel>[];

    for (final element in doc.selectAll("#list-page .row")) {
      final titleElement = element.select("h3[class*='title'] > a");
      final href = titleElement?.attributes["href"];
      if (titleElement == null || href == null) continue;

      final thumbnail = element.select(".cover")?.attributes["src"];

      final novel = Novel(
        title: titleElement.text.trim(),
        thumbnailUrl:
            thumbnail == null ? null : meta.absoluteUrl(thumbnail, url),
        url: meta.absoluteUrl(href),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }
}

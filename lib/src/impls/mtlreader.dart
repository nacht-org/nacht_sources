import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';

class MTLReader extends Crawler with CleanHtml, ParseNovel {
  MTLReader.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  MTLReader.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.mtlreader',
    name: "MTL Reader",
    lang: "en",
    version: SemanticVersion(0, 1, 0),
    baseUrls: [
      "https://mtlreader.com",
      "https://www.mtlreader.com",
    ],
    features: {Feature.search, Feature.popular},
    attributes: [Attribute.fanfiction],
  );

  static Meta getMeta() => _meta;

  @override
  Future<Novel> fetchNovel(String url) async {
    final doc = await pullDoc(url);

    final thumbnailUrl =
        doc.select('meta[property="og:image"]')?.attributes["content"];

    final novel = Novel(
      title: doc.selectText(".agent-title") ?? '',
      thumbnailUrl:
          thumbnailUrl == null ? null : meta.absoluteUrl(thumbnailUrl),
      description: doc.selectAllText("#editdescription > p"),
      url: url,
      lang: _meta.lang,
      volumes: await volumes(url, doc),
    );

    final possibleAuthor = doc.select(".agent-p-contact .fa.fa-user");
    if (possibleAuthor is Element && possibleAuthor.parent is Element) {
      novel.author = possibleAuthor.parent!.text.trim();
      novel.author = novel.author!.replaceAll(RegExp("Author[: ]+"), "");
    }

    return novel;
  }

  Future<List<Volume>> volumes(
    String novelUrl,
    Document novelDoc,
  ) async {
    final chapters = <Chapter>[];

    final elements = novelDoc.selectAll("table td a[href*='/chapters/']");
    for (final element in elements) {
      final title = element.text.trim().replaceAll(RegExp(r"^\d+[\s:\-]+"), "");
      final chapter = Chapter(
        index: chapters.length,
        title: title,
        url: meta.absoluteUrl(element.attributes["href"]!),
      );
      chapters.add(chapter);
    }

    return [Volume.def(chapters)];
  }

  @override
  Future<String?> fetchChapterContent(String url) async {
    final response = await client.get(url);

    final cookies = <Cookie>[];
    for (final value in response.headers['set-cookie']!) {
      cookies.add(Cookie.fromSetCookieValue(value));
    }
    final token =
        cookies.where((element) => element.name == 'XSRF-TOKEN').first;

    final chapterId = int.parse(Uri.parse(url).pathSegments[3]);
    final detailApi =
        "https://www.mtlreader.com/api/chapter-content/$chapterId";

    final detailResponse = await client.get<String>(
      detailApi,
      options: Options(
        headers: {
          "referer": url,
          "x-xsrf-token": token,
          "accept": "application/json, text/plain, */*",
        },
      ),
    );

    final paragraphs = detailResponse.data!
        .replaceAll(RegExp(r"([\r\n]?<br>[\r\n]?)+"), "\n\n")
        .replaceAll(r"\u3000", "")
        .split("\n\n")
        .map((x) => x.replaceAll(r"\n", ""))
        .map((x) => "<p>${x.trim()}</p>")
        .whereNot((element) => element == "<p></p>")
        .whereNot((element) => element == '<p>"</p>');

    return paragraphs.join();
  }

  @override
  Future<List<Novel>> search(String query, int page) async {
    final url = "${meta.baseUrl}/search?input=$query&page=$page";
    final doc = await pullDoc(url);
    return parseSearch(url, doc);
  }

  // Popular

  @override
  String buildPopularUrl(int page) => '${meta.baseUrl}/novels?page=$page';

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final url = buildPopularUrl(page);
    final doc = await pullDoc(url);
    return parseSearch(url, doc);
  }

  Future<List<Novel>> parseSearch(String url, Document doc) async {
    final novels = <Novel>[];

    for (final element in doc.selectAll(".property_item")) {
      final thumbnail = element.select("img")?.attributes["src"];
      final a = element.select("a:not([class*='fa'])");
      if (a == null) continue;

      final novel = Novel(
        title: a.text.trim(),
        thumbnailUrl:
            thumbnail == null ? null : meta.absoluteUrl(thumbnail, url),
        url: meta.absoluteUrl(a.attributes['href']!),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }
}

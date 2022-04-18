import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/src/exceptions.dart';
import 'package:chapturn_sources/src/extensions/string_strip.dart';
import 'package:chapturn_sources/src/interfaces/interfaces.dart';
import 'package:chapturn_sources/src/mixins/html_parsing.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';

@registerCrawler
class NovelPub extends Crawler with HtmlParsing implements NovelParse {
  NovelPub.make() : super(client: Crawler.defaultClient(), meta: _meta);
  NovelPub.makeWith(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: 'NovelPub',
    lang: 'en',
    updated: DateHolder(2022, 04, 08),
    baseUrls: ['https://www.novelpub.com'],
  );

  static Meta constMeta() => _meta;

  @override
  Future<Novel> parseNovel(String url) async {
    var doc = await pullDoc(url);

    final novel = Novel(
      title: doc.querySelector('.novel-title')?.text.trim() ?? '',
      author: doc.querySelector('.author a')?.text.trim(),
      thumbnailUrl: doc.querySelector('.cover img')?.attributes['data-src'],
      description: doc
          .querySelectorAll('.summary .content p')
          .map((element) => element.text.trim())
          .where((text) => text.isNotEmpty)
          .toList(),
      url: url,
      lang: 'en',
    );

    final altTitle = doc.querySelector('.alternative-title')?.text.trim();
    if (altTitle != null && altTitle.isNotEmpty) {
      novel.addMeta('title', altTitle, {'role': 'alt'});
    }

    for (final li in doc.querySelectorAll('.categories > ul > li')) {
      novel.addMeta('subject', li.text.trim());
    }

    for (final a in doc.querySelectorAll('.content .tag')) {
      novel.addMeta('tag', a.text.trim());
    }

    for (final span in doc.querySelectorAll('.header-stats span')) {
      final label = span.querySelector('small')?.text.trim().toLowerCase();
      if (label == 'status') {
        final value = span.querySelector('strong')?.text.trim();
        novel.status = parseNovelStatus(value);
      }
    }

    final volume = novel.singleVolume();
    doc = await pullDoc(tocUrl(url, 1));
    await extractToc(doc, volume);

    final pages = doc.querySelectorAll(
      ".pagenav .pagination > li:not(.PagedList-skipToNext)",
    );

    int start = 0;
    int end = 0;
    if (pages.length > 1) {
      start = 2;
      end = int.parse(
            pages.last
                .querySelector('a')!
                .attributes['href']!
                .split('-')
                .last
                .trim(),
          ) +
          1;
    }

    for (var i = start; i < end; i++) {
      await extractToc(await pullDoc(tocUrl(url, i)), volume);
    }

    return novel;
  }

  String tocUrl(String url, int page) {
    return '${url.stripRight("/")}/chapters/page-$page';
  }

  Future<void> extractToc(Document doc, Volume volume) async {
    for (final li in doc.querySelectorAll('.chapter-list > li')) {
      final a = li.querySelector('a');
      if (a == null) {
        return;
      }

      final updated = li.querySelector('time')?.attributes['datetime'];

      final chapter = Chapter(
        index: int.parse(li.attributes['data-orderno']!),
        title: a.querySelector('.chapter-title')?.text.trim() ?? '',
        url: meta.absoluteUrl(a.attributes['href']!),
        updated: updated == null ? null : DateTime.parse(updated),
      );

      volume.chapters.add(chapter);
    }
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    final doc = await pullDoc(chapter.url);
    final content = doc.querySelector("#chapter-container");
    if (content == null) {
      throw CrawlerException("Unable to find main chapter content.");
    }

    for (final element in doc.querySelectorAll('.adsbox, .adsbygoogle')) {
      element.remove();
    }

    cleanNodeTree(content);

    chapter.content = content.outerHtml;
  }
}

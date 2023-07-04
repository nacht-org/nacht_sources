import 'package:html/dom.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';

class NovelPub extends Crawler with CleanHtml, ParseNovel {
  NovelPub.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  NovelPub.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.novelpub',
    name: 'NovelPub',
    lang: 'en',
    version: SemanticVersion(0, 1, 2),
    baseUrls: ['https://www.novelpub.com'],
    features: {Feature.popular},
  );

  static Meta getMeta() => _meta;

  @override
  String buildPopularUrl(int page) =>
      'https://www.novelpub.com/genre/all/popular/all/$page';

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final doc = await pullDoc(buildPopularUrl(page));

    final novels = <Novel>[];
    for (final li in doc.selectAll('.novel-list > .novel-item')) {
      final a = li.select('.novel-title a')!;
      final thumbnailUrl =
          li.select('.novel-cover img')?.attributes['data-src'];

      final novel = Novel(
        title: a.attributes['title']!,
        thumbnailUrl:
            thumbnailUrl != null ? meta.absoluteUrl(thumbnailUrl) : null,
        url: meta.absoluteUrl(a.attributes['href']!),
        lang: 'en',
        status: NovelStatus.parse(
          li.selectText('.novel-stats .status'),
        ),
      );

      novels.add(novel);
    }

    return novels;
  }

  @override
  Future<Novel> fetchNovel(String url) async {
    var doc = await pullDoc(url);

    final novel = Novel(
      title: doc.selectText('.novel-title') ?? '',
      author: doc.selectText('.author a'),
      thumbnailUrl: doc.select('.cover img')?.attributes['data-src'],
      description: doc.selectAllText('.summary .content p'),
      url: url,
      lang: 'en',
    );

    final altTitle = doc.selectText('.alternative-title');
    if (altTitle != null && altTitle.isNotEmpty) {
      novel.addMeta('title', altTitle, {'role': 'alt'});
    }

    for (final li in doc.selectAll('.categories > ul > li')) {
      novel.addMeta('subject', li.text.trim());
    }

    for (final a in doc.selectAll('.content .tag')) {
      novel.addMeta('tag', a.text.trim());
    }

    for (final span in doc.selectAll('.header-stats span')) {
      final label = span.selectText('small')?.toLowerCase();
      if (label == 'status') {
        final value = span.selectText('strong');
        novel.status = NovelStatus.parse(value);
      }
    }

    final volume = novel.singleVolume();
    doc = await pullDoc(tocUrl(url, 1));
    await extractToc(doc, volume);

    final pages = doc.selectAll(
      ".pagenav .pagination > li:not(.PagedList-skipToNext)",
    );

    int start = 0;
    int end = 0;
    if (pages.length > 1) {
      start = 2;
      end = int.parse(
            pages.last.select('a')!.attributes['href']!.split('=').last.trim(),
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
    for (final li in doc.selectAll('.chapter-list > li')) {
      final a = li.select('a');
      if (a == null) {
        return;
      }

      final updated = li.select('time')?.attributes['datetime'];

      final chapter = Chapter(
        index: int.parse(li.attributes['data-orderno']!),
        title: a.selectText('.chapter-title') ?? '',
        url: meta.absoluteUrl(a.attributes['href']!),
        updated: updated == null ? null : DateTime.parse(updated),
      );

      volume.chapters.add(chapter);
    }
  }

  @override
  Future<String?> fetchChapterContent(String url) async {
    final doc = await pullDoc(url);
    final content = doc.select("#chapter-container");
    if (content == null) {
      throw CrawlerException("Unable to find main chapter content.");
    }

    for (final element in doc.selectAll('.adsbox, .adsbygoogle')) {
      element.remove();
    }

    for (final element in doc.selectAll('strong > strong')) {
      element.remove();
    }

    for (final element in doc.selectAll('strong i i')) {
      element.remove();
    }

    for (final element in doc.selectAll('p > sub')) {
      element.remove();
    }

    cleanNodeTree(content);

    return content.outerHtml;
  }
}

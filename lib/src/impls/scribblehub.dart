import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/misc.dart';
import 'package:rechron/rechron.dart' as rechron;

class ScribbleHub extends Crawler with ParseNovel {
  ScribbleHub.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  ScribbleHub.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.scribblehub',
    name: 'ScribbleHub',
    lang: 'en',
    version: SemanticVersion(0, 1, 0),
    baseUrls: ['https://www.scribblehub.com'],
    workTypes: [OriginalWork()],
    features: {Feature.popular, Feature.search},
  );

  static Meta getMeta() => _meta;

  DateFormat formatter = DateFormat('MMM d, y hh:mm a');

  @override
  Future<List<Novel>> search(String query, int page) async {
    if (page > 1) {
      throw PageException('Does not support multi-page searches');
    }

    final url = 'https://www.scribblehub.com/?s=$query&post_type=fictionposts';
    final doc = await pullDoc(url);

    final novels = <Novel>[];
    for (final div in doc.selectAll('.search_main_box')) {
      final a = div.select('.search_title a')!;

      final novel = Novel(
        title: a.text.trim(),
        url: a.attributes['href']!,
        lang: 'en',
        thumbnailUrl: div.select('.search_img img')?.attributes['src'],
        workType: const OriginalWork(),
      );

      novels.add(novel);
    }

    return novels;
  }

  @override
  String buildPopularUrl(int page) =>
      'https://www.scribblehub.com/series-ranking/?sort=1&order=3&pg=$page';

  @override
  Future<List<Novel>> fetchPopular(int page) async {
    final novels = <Novel>[];

    final doc = await pullDoc(buildPopularUrl(page));

    for (final div in doc.selectAll('div.search_main_box')) {
      final a = div.select(".search_title a");
      if (a == null) {
        continue;
      }

      final novel = Novel(
        title: a.text.trim(),
        thumbnailUrl: div.select('.search_img img')?.attributes['src'],
        author: div.select('.search_stats span[title="Author"]')?.text.trim(),
        url: meta.absoluteUrl(a.attributes['href']!),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }

  @override
  Future<Novel> fetchNovel(String url) async {
    final doc = await pullDoc(url);

    final statusElement =
        doc.select('.widget_fic_similar > li:last-child > span:last-child');

    final novel = Novel(
      title: doc.selectText('div.fic_title') ?? '',
      author: doc.selectText('span.auth_name_fic'),
      url: url,
      lang: meta.lang,
      thumbnailUrl: doc.select('.fic_image img')?.attributes['src'],
      description: doc.selectAllText('.wi_fic_desc > p'),
      status: NovelStatus.parse(statusElement?.text.split('-').first),
      workType: const OriginalWork(),
    );

    // Genre
    for (final a in doc.selectAll("a.fic_genre")) {
      novel.addMeta('subject', a.text.trim());
    }

    // Tags
    for (final a in doc.selectAll('a.stag')) {
      novel.addMeta('tag', a.text.trim());
    }

    // Content Warning
    for (final a in doc.selectAll('.mature_contains > a')) {
      novel.addMeta('warning', a.text.trim());
    }

    // Rating
    final ratingElement = doc.select('#ratefic_user > span');
    if (ratingElement != null) {
      novel.addMeta('rating', ratingElement.text.trim());
    }

    final id = url.split('/')[4];
    novel.volumes.add(await toc(id));

    return novel;
  }

  @override
  Future<String?> fetchChapterContent(String url) async {
    final doc = await pullDoc(url);

    // final titleNode = doc.select('.chapter-title');
    // if (titleNode == null) {
    //   chapter.title = titleNode!.text.trim();
    // }

    return doc.select('#chp_raw')?.outerHtml;
  }

  Future<Volume> toc(String id) async {
    final response = await client.post<String>(
      "https://www.scribblehub.com/wp-admin/admin-ajax.php",
      data: FormData.fromMap({
        "action": "wi_getreleases_pagination",
        "pagenum": '-1',
        "mypostid": id,
      }),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );

    final fragment = parseFragment(response.data);

    final volume = Volume.def();
    var index = 0;
    for (final li in fragment.selectAll('li.toc_w').reversed) {
      final a = li.select('a');
      if (a == null || a.attributes['href'] == null) {
        continue;
      }

      final time = li.select('.fic_date_pub')?.attributes['title'];

      DateTime? updated;
      try {
        updated = time != null ? formatter.parse(time) : null;
      } on FormatException {
        try {
          updated = rechron.parse(time!);
        } catch (_) {}
      }

      volume.chapters.add(
        Chapter(
          index: index,
          title: a.text.trim(),
          url: a.attributes['href']!,
          updated: updated,
        ),
      );

      index++;
    }

    return volume;
  }
}

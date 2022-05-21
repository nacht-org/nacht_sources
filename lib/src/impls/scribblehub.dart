import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/src/interfaces/interfaces.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

@registerCrawler
class ScribbleHub extends Crawler implements ParseNovel, ParsePopular {
  ScribbleHub.make() : super(client: Crawler.defaultClient(), meta: _meta);
  ScribbleHub.makeWith(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: 'ScribbleHub',
    lang: 'en',
    updated: DateHolder(2021, 12, 18),
    baseUrls: ['https://www.scribblehub.com'],
    workTypes: [OriginalWork()],
    features: {Feature.popular},
  );

  static Meta constMeta() => _meta;

  DateFormat formatter = DateFormat('MMM d, y hh:mm a');

  @override
  String buildPopularUrl(int page) =>
      'https://www.scribblehub.com/series-ranking/?sort=1&order=3&pg=$page';

  @override
  Future<List<Novel>> parsePopular(int page) async {
    final novels = <Novel>[];

    final doc = await pullDoc(buildPopularUrl(page));

    for (final div in doc.querySelectorAll('div.search_main_box')) {
      final a = div.querySelector(".search_title a");
      if (a == null) {
        continue;
      }

      final novel = Novel(
        title: a.text.trim(),
        thumbnailUrl: div.querySelector('.search_img img')?.attributes['src'],
        author: div
            .querySelector('.search_stats span[title="Author"]')
            ?.text
            .trim(),
        url: meta.absoluteUrl(a.attributes['href']!),
        lang: meta.lang,
      );

      novels.add(novel);
    }

    return novels;
  }

  @override
  Future<Novel> parseNovel(String url) async {
    final doc = await pullDoc(url);

    final statusElement = doc
        .querySelector('.widget_fic_similar > li:last-child > span:last-child');

    final novel = Novel(
      title: doc.querySelector('div.fic_title')?.text.trim() ?? '',
      author: doc.querySelector('span.auth_name_fic')?.text.trim(),
      url: url,
      lang: meta.lang,
      thumbnailUrl: doc.querySelector('.fic_image img')?.attributes['src'],
      description: doc
          .querySelectorAll('.wi_fic_desc > p')
          .map((e) => e.text.trim())
          .toList(),
      status: parseNovelStatus(statusElement?.text.split('-').first),
      workType: const OriginalWork(),
    );

    // Genre
    for (final a in doc.querySelectorAll("a.fic_genre")) {
      novel.addMeta('subject', a.text.trim());
    }

    // Tags
    for (final a in doc.querySelectorAll('a.stag')) {
      novel.addMeta('tag', a.text.trim());
    }

    // Content Warning
    for (final a in doc.querySelectorAll('.mature_contains > a')) {
      novel.addMeta('warning', a.text.trim());
    }

    // Rating
    final ratingElement = doc.querySelector('#ratefic_user > span');
    if (ratingElement != null) {
      novel.addMeta('rating', ratingElement.text.trim());
    }

    final id = url.split('/')[4];
    novel.volumes.add(await toc(id));

    return novel;
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    final doc = await pullDoc(chapter.url);

    final titleNode = doc.querySelector('.chapter-title');
    if (titleNode == null) {
      chapter.title = titleNode!.text.trim();
    }

    chapter.content = doc.querySelector('#chp_raw')?.outerHtml;
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
    for (final li in fragment.querySelectorAll('li.toc_w').reversed) {
      final a = li.querySelector('a');
      if (a == null || a.attributes['href'] == null) {
        continue;
      }

      final time = li.querySelector('.fic_date_pub')?.attributes['title'];

      // TODO add support to parse relative time ex: 20 hours ago
      DateTime? updated;
      try {
        updated = time != null ? formatter.parse(time) : null;
      } on FormatException {
        updated = null;
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

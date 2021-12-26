import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../interfaces/interfaces.dart';
import '../models/models.dart';

class ScribbleHub extends NovelCrawler {
  ScribbleHub.make() : super(client: Crawler.defaultClient(), meta: _meta);
  ScribbleHub.makeWith(Client client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: 'ScribbleHub',
    lang: 'en',
    updated: DateHolder(2021, 12, 18),
    baseUrls: {'https://www.scribblehub.com'},
  );

  static Meta constMeta() => _meta;

  DateFormat formatter = DateFormat('MMM d, y hh:mm a');

  @override
  Future<Novel> parseNovel(String url) async {
    var doc = await pullDoc(url);

    var novel = Novel(
      title: doc.querySelector('div.fic_title')?.text.trim() ?? '',
      author: doc.querySelector('span.auth_name_fic')?.text.trim(),
      url: url,
      lang: meta.lang,
      thumbnailUrl: doc.querySelector('.fic_image img')?.attributes['src'],
      description: doc
          .querySelectorAll('.wi_fic_desc > p')
          .map((e) => e.text.trim())
          .toList(),
    );

    for (var a in doc.querySelectorAll("a.fic_genre")) {
      novel.addMeta('subject', a.text.trim());
    }

    for (var a in doc.querySelectorAll('a.stag')) {
      novel.addMeta('tag', a.text.trim());
    }

    var id = url.split('/')[4];
    novel.volumes.add(await toc(id));

    return novel;
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    var doc = await pullDoc(chapter.url);

    var titleNode = doc.querySelector('.chapter-title');
    if (titleNode == null) {
      chapter.title = titleNode!.text.trim();
    }

    chapter.content = doc.querySelector('#chp_raw')?.outerHtml;
  }

  Future<Volume> toc(String id) async {
    var response = await client.post(
      Uri.parse("https://www.scribblehub.com/wp-admin/admin-ajax.php"),
      body: {
        "action": "wi_getreleases_pagination",
        "pagenum": '-1',
        "mypostid": id,
      },
    );

    var fragment = parseFragment(response.body);

    var volume = Volume.def();
    var index = 0;
    for (var li in fragment.querySelectorAll('li.toc_w').reversed) {
      var a = li.querySelector('a');
      if (a == null || a.attributes['href'] == null) {
        continue;
      }

      var time = li.querySelector('.fic_date_pub')?.attributes['title'];

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

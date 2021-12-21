import 'package:chapturn_sources/models/chapter.dart';
import 'package:chapturn_sources/models/meta.dart';
import 'package:chapturn_sources/models/metadata.dart';
import 'package:chapturn_sources/models/novel.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:collection/collection.dart';

import '../interfaces/interfaces.dart';

class ScribbleHub extends NovelCrawler {
  ScribbleHub.make() : super(client: Crawler.defaultClient(), meta: _meta);
  ScribbleHub.makeWith(Client client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: 'ScribbleHub',
    lang: 'en',
    updated: [2021, 12, 18],
    baseUrls: {'https://www.scribblehub.com'},
  );

  static Meta constMeta() {
    return _meta;
  }

  @override
  Future<Novel> parseNovel(String url) async {
    var doc = await pullDoc(url);
    doc.querySelector("");

    var novel = Novel(
      title: doc.querySelector('div.fic_title')?.text.trim() ?? '',
      url: url,
      lang: meta.lang,
      thumbnailUrl: doc.querySelector('.fic_image img')?.attributes['src'],
      description: doc
          .querySelectorAll('.wi_fic_desc > p')
          .map((e) => e.text.trim())
          .toList(),
    );

    for (var a in doc.querySelectorAll("a.fic_genre")) {
      novel.meta('subject', a.text.trim());
    }

    return novel;
  }

  @override
  Future<void> parseChapter(Chapter chapter) async {
    // TODO: implement parseChapter
  }

  Future<List<Chapter>> toc(int id) async {
    var response = await client.post(
      Uri.https(
        "www.scribblehub.com",
        "/wp-admin/admin-ajax.php",
        {
          "action": "wi_getreleases_pagination",
          "pagenum": -1,
          "mypostid": id,
        },
      ),
    );

    var fragment = parseFragment(response.body);

    var chapters =
        fragment.querySelectorAll('li.toc_w').reversed.mapIndexed((i, li) {
      var a = li.querySelector("a");

      return Chapter(
        index: i,
        title: a?.text.trim() ?? 'Chapter $i',
        url: a?.attributes['href'] ?? '',
      );
    }).toList();

    return chapters;
  }
}

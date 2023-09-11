import 'package:html/dom.dart';
import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/misc/html_utils.dart';
import 'package:nacht_sources/src/templates/templates.dart';

class NovelBin extends NovelFullTemplate {
  NovelBin.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  NovelBin.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.novel-bin',
    name: "Novel Bin",
    lang: "en",
    version: SemanticVersion(0, 1, 0),
    baseUrls: ["https://novel-bin.com"],
    features: {Feature.search, Feature.popular},
  );

  static Meta getMeta() => _meta;

  @override
  String? selectStatus(Document doc) {
    return doc.selectText(".info .text-primary");
  }

  @override
  String buildChapterListUrl(String novelId, bool hasChapterOptionsUrl) {
    return "${meta.baseUrl}/ajax/chapter-archive?novelId=$novelId";
  }

  @override
  String buildPopularUrl(int page) {
    return "${meta.baseUrl}/sort/popular-novel-bin?page=$page";
  }
}

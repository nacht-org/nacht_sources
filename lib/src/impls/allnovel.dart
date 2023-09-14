import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/templates/templates.dart';

class AllNovel extends NovelFullTemplate {
  AllNovel.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  AllNovel.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'org.allnovel',
    name: "All Novel",
    lang: "en",
    version: SemanticVersion(0, 1, 0),
    baseUrls: ["https://allnovel.org", "http://allnovel.org"],
    logo: Logo.github("org.allnovel.png", 0xffa63077),
    features: {Feature.search, Feature.popular},
  );

  static Meta getMeta() => _meta;
}

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/templates/templates.dart';

class NovelFull extends NovelFullTemplate {
  NovelFull.basic() : super(options: CrawlerOptions.basic(), meta: _meta);
  NovelFull.custom(CrawlerOptions options)
      : super(options: options, meta: _meta);

  static const _meta = Meta(
    id: 'com.novelfull',
    name: "NovelFull",
    lang: "en",
    version: SemanticVersion(0, 1, 0),
    baseUrls: ["https://novelfull.com", "http://novelfull.com"],
    logo: Logo.github("com.novelfull.png", 0xffcfd4d2),
    features: {Feature.search, Feature.popular},
  );

  static Meta getMeta() => _meta;
}

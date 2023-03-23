import 'package:nacht_sources/src/crawlers.dart';
import 'package:nacht_sources/src/interfaces/crawler.dart';
import 'package:nacht_sources/src/models/models.dart';

/// A crawler factory class used to hold crawler helper methods
class CrawlerFactory {
  final Meta Function() meta;
  final Crawler Function() basic;
  final Crawler Function(CrawlerOptions) custom;

  const CrawlerFactory(this.meta, this.basic, this.custom);
}

CrawlerFactory? crawlerFactoryFor(String url) {
  for (final factory in crawlers.values) {
    if (factory.meta().of(url)) {
      return factory;
    }
  }

  return null;
}

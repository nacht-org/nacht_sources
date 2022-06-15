import 'package:annotations/annotations.dart';
import 'package:dio/dio.dart';
import 'package:nacht_sources/generated/crawlers.g.dart';
import 'package:nacht_sources/src/interfaces/crawler.dart';
import 'package:nacht_sources/src/models/meta.dart';

/// A crawler factory class used to hold crawler
/// helper methods
@registerFactory
class CrawlerFactory {
  final Meta Function() meta;
  final Crawler Function() basic;
  final Crawler Function(Dio) custom;

  const CrawlerFactory(this.meta, this.basic, this.custom);
}

CrawlerFactory? crawlerFactoryFor(String url, [Dio? client]) {
  for (final tuple in crawlers) {
    if (tuple.meta().of(url)) {
      return tuple;
    }
  }

  return null;
}

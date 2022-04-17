library chapturn_sources;

import 'package:chapturn_sources/generated/crawlers.g.dart';
import 'package:chapturn_sources/src/utils.dart';
import 'package:dio/dio.dart';

export './generated/crawlers.g.dart';
export './src/impls/impls.dart';
export './src/interfaces/interfaces.dart';
export './src/models/models.dart';
export './src/utils.dart';

CrawlerFactory? crawlerFactoryFor(String url, [Dio? client]) {
  for (final tuple in crawlers) {
    if (tuple.meta().of(url)) {
      return tuple;
    }
  }

  return null;
}

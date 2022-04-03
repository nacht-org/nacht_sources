library chapturn_sources;

import 'package:chapturn_sources/src/crawlers.dart';
import 'package:chapturn_sources/src/utils.dart';
import 'package:dio/dio.dart';

export './src/crawlers.dart';
export './src/impls/impls.dart';
export './src/interfaces/interfaces.dart';
export './src/models/models.dart';
export './src/utils.dart';

CrawlerFactory? getCrawlerFactoryWithUrl(String url, [Dio? client]) {
  for (final tuple in crawlers) {
    if (tuple.meta().of(url)) {
      return tuple;
    }
  }
}

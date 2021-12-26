library chapturn_sources;

import 'package:chapturn_sources/src/interfaces/novel.dart';
import 'package:chapturn_sources/src/models/meta.dart';
import 'package:http/http.dart';
import './src/impls/impls.dart';

export './src/models/models.dart';
export './src/interfaces/interfaces.dart';
export './src/impls/impls.dart';

/// A crawler factory class used to hold crawler
/// helper methods
class CrawlerFactory {
  final Meta Function() meta;
  final NovelCrawler Function() create;
  final NovelCrawler Function(Client) createWith;

  const CrawlerFactory(this.meta, this.create, this.createWith);
}

const sources = [
  CrawlerFactory(ScribbleHub.constMeta, ScribbleHub.make, ScribbleHub.makeWith)
];

CrawlerFactory? crawlerByUrl(String url, [Client? client]) {
  for (var tuple in sources) {
    if (tuple.meta().of(url)) {
      return tuple;
    }
  }
}

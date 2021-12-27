library chapturn_sources;

import 'package:http/http.dart';

import './src/impls/impls.dart';
import './src/utils.dart';

export './src/impls/impls.dart';
export './src/interfaces/interfaces.dart';
export './src/models/models.dart';
export './src/utils.dart';

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

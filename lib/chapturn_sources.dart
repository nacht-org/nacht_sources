library chapturn_sources;

import 'package:chapturn_sources/impls/scribblehub.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import './impls/impls.dart';
import './models/models.dart';
import './interfaces/interfaces.dart';

List<
    Tuple3<Meta Function(), NovelCrawler Function(),
        NovelCrawler Function(Client)>> sources = [
  Tuple3(ScribbleHub.constMeta, ScribbleHub.make, ScribbleHub.makeWith)
];

NovelCrawler? crawlerByUrl(String url, [Client? client]) {
  for (var tuple in sources) {
    if (tuple.item1().of(url)) {
      return client == null ? tuple.item2() : tuple.item3(client);
    }
  }
}

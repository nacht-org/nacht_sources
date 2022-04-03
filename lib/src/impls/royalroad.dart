import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/chapturn_sources.dart';

import 'package:dio/dio.dart';

@registerCrawler
class RoyalRoad extends NovelCrawler {
  RoyalRoad.make() : super(client: Crawler.defaultClient(), meta: _meta);
  RoyalRoad.makeWith(Dio client) : super(client: client, meta: _meta);

  static const _meta = Meta(
    name: "RoyalRoad",
    lang: "en",
    updated: DateHolder(2022, 14, 03),
    baseUrls: {"https://www.royalroad.com/"},
  );

  static Meta constMeta() => _meta;

  @override
  Future<Novel> parseNovel(String url) {
    // TODO: implement parseNovel
    throw UnimplementedError();
  }

  @override
  Future<void> parseChapter(Chapter chapter) {
    // TODO: implement parseChapter
    throw UnimplementedError();
  }
}

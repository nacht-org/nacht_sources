import "package:nacht_sources/src/impls/impls.dart";
import "package:nacht_sources/src/utils.dart";

const crawlers = {
  "com.fanfiction": CrawlerFactory(
    FanFiction.getMeta,
    FanFiction.basic,
    FanFiction.custom,
  ),
  "com.novelpub": CrawlerFactory(
    NovelPub.getMeta,
    NovelPub.basic,
    NovelPub.custom,
  ),
  "com.royalroad": CrawlerFactory(
    RoyalRoad.getMeta,
    RoyalRoad.basic,
    RoyalRoad.custom,
  ),
  "com.scribblehub": CrawlerFactory(
    ScribbleHub.getMeta,
    ScribbleHub.basic,
    ScribbleHub.custom,
  ),
};

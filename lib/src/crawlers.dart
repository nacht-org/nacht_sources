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
  "com.novelfull": CrawlerFactory(
    NovelFull.getMeta,
    NovelFull.basic,
    NovelFull.custom,
  ),
  "com.mtlreader": CrawlerFactory(
    MTLReader.getMeta,
    MTLReader.basic,
    MTLReader.custom,
  ),
  "com.foxaholic": CrawlerFactory(
    Foxaholic.getMeta,
    Foxaholic.basic,
    Foxaholic.custom,
  ),
  "org.allnovel": CrawlerFactory(
    AllNovel.getMeta,
    AllNovel.basic,
    AllNovel.custom,
  ),
  "com.novel-bin": CrawlerFactory(
    NovelBin.getMeta,
    NovelBin.basic,
    NovelBin.custom,
  ),
};

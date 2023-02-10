// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering

import "package:nacht_sources/src/utils.dart";
import "package:nacht_sources/src/impls/fanfiction.dart";
import "package:nacht_sources/src/impls/novelpub.dart";
import "package:nacht_sources/src/impls/royalroad.dart";
import "package:nacht_sources/src/impls/scribblehub.dart";

const crawlers = {
  "com.fanfiction": CrawlerFactory(FanFiction.getMeta, FanFiction.basic, FanFiction.custom),
  "com.novelpub": CrawlerFactory(NovelPub.getMeta, NovelPub.basic, NovelPub.custom),
  "com.royalroad": CrawlerFactory(RoyalRoad.getMeta, RoyalRoad.basic, RoyalRoad.custom),
  "com.scribblehub": CrawlerFactory(ScribbleHub.getMeta, ScribbleHub.basic, ScribbleHub.custom),
};

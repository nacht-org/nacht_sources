// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering

import "package:nacht_sources/src/utils.dart";
import "package:nacht_sources/src/impls/fanfiction.dart";
import "package:nacht_sources/src/impls/novelpub.dart";
import "package:nacht_sources/src/impls/royalroad.dart";
import "package:nacht_sources/src/impls/scribblehub.dart";

const crawlers = [
CrawlerFactory(FanFiction.constMeta, FanFiction.make, FanFiction.makeWith),
CrawlerFactory(NovelPub.constMeta, NovelPub.make, NovelPub.makeWith),
CrawlerFactory(RoyalRoad.constMeta, RoyalRoad.make, RoyalRoad.makeWith),
CrawlerFactory(ScribbleHub.constMeta, ScribbleHub.make, ScribbleHub.makeWith),
];

import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/chapturn_sources.dart';

import 'package:chapturn_sources/src/models/models.dart';

part 'royalroad.g.dart';

@novelCrawler
class RoyalRoad extends _$RoyalRoad {
  static const meta = Meta(
    name: "RoyalRoad",
    lang: "en",
    updated: DateHolder(2022, 14, 03),
    baseUrls: {"https://www.royalroad.com/"},
  );
}

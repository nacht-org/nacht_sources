import 'package:chapturn_sources/src/interfaces/novel.dart';
import 'package:chapturn_sources/src/models/meta.dart';
import 'package:dio/dio.dart';

/// A crawler factory class used to hold crawler
/// helper methods
class CrawlerFactory {
  final Meta Function() meta;
  final NovelCrawler Function() create;
  final NovelCrawler Function(Dio) createWith;

  const CrawlerFactory(this.meta, this.create, this.createWith);
}

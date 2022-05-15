import 'package:annotations/annotations.dart';
import 'package:chapturn_sources/src/interfaces/crawler.dart';
import 'package:chapturn_sources/src/models/meta.dart';
import 'package:dio/dio.dart';

/// A crawler factory class used to hold crawler
/// helper methods
@registerFactory
class CrawlerFactory {
  final Meta Function() meta;
  final Crawler Function() basic;
  final Crawler Function(Dio) custom;

  const CrawlerFactory(this.meta, this.basic, this.custom);
}

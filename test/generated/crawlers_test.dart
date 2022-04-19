import 'package:chapturn_sources/chapturn_sources.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  test('crawlers should have atleast one base url', () {
    for (final crawlerFactory in crawlers) {
      final baseUrls = crawlerFactory.meta().baseUrls;
      expect(baseUrls.length, greaterThanOrEqualTo(1));
    }
  });

  test('crawlers should identify features implemented', () {
    final dio = Dio();
    for (final crawlerFactory in crawlers) {
      final meta = crawlerFactory.meta();
      final crawler = crawlerFactory.createWith(dio);

      expect(
        crawler is NovelSearch,
        meta.features.contains(Feature.search),
        reason: "'search' feature not synced in '${meta.name}'",
      );

      expect(
        crawler is NovelLogin,
        meta.features.contains(Feature.login),
        reason: "'login' feature not synced in '${meta.name}'",
      );

      expect(
        crawler is NovelPopular,
        meta.features.contains(Feature.popular),
        reason: "'popular' feature not synced in '${meta.name}'",
      );
    }
  });
}

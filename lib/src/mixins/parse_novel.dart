import 'package:nacht_sources/src/exceptions.dart';
import 'package:nacht_sources/src/models/models.dart';

/// Base class for parsing novels.
///
/// implementations for [parseNovel] and [fetchChapterContent] are mandatory.
mixin ParseNovel {
  /// Parse the novel by following the url
  ///
  /// Does not check if the url matches this crawler
  Future<Novel> parseNovel(String url);

  /// Parse the chapter and populate the content field
  ///
  /// [Chapter] must have the [url] field populated
  Future<String?> fetchChapterContent(String url);

  /// Search the website for novels with the given [query]
  Future<List<Novel>> search(String query, int page) {
    throw FeatureException('Search not supported');
  }

  /// Build the url pointing to the [page] showing popular novels.
  String buildPopularUrl(int page) {
    throw FeatureException('Popular not supported');
  }

  /// Acquire the most popular novels from the source.
  Future<List<Novel>> parsePopular(int page) {
    throw FeatureException('Popular not supported');
  }
}

import 'package:nacht_sources/src/exceptions.dart';
import 'package:nacht_sources/src/models/models.dart';

/// Base class for parsing novels.
///
/// implementations for [fetchNovel] and [fetchChapterContent] are mandatory.
mixin ParseNovel {
  /// Fetch the novel by following the [url]
  ///
  /// Does not check if the url matches this crawler
  Future<Novel> fetchNovel(String url);

  /// Fetch and parse the chapter content
  ///
  /// [Chapter] must have the [url] field populated
  Future<String?> fetchChapterContent(String url);

  /// Search the website for novels with the given [query]
  Future<List<Novel>> search(String query, int page) {
    throw FeatureException('Search not supported');
  }

  /// Build the url pointing to the [page] showing popular novels.
  ///
  /// See also:
  /// [fetchPopular] for fetching popular novels from source.
  String buildPopularUrl(int page) {
    throw FeatureException('Popular not supported');
  }

  /// Fetch the most popular novels from the source.
  ///
  /// The content is segmented using [page].
  Future<List<Novel>> fetchPopular(int page) {
    throw FeatureException('Popular not supported');
  }
}

import 'package:nacht_sources/src/models/models.dart';

abstract class ParseNovel {
  /// Parse the novel by following the url
  ///
  /// Does not check if the url matches this crawler
  Future<Novel> parseNovel(String url);

  /// Parse the chapter and populate the content field
  ///
  /// [Chapter] must have the [url] field populated
  Future<void> parseChapter(Chapter chapter);
}

abstract class ParseSearch {
  /// Search the website for novels with the given [query]
  Future<List<Novel>> search(String query, int page);
}

abstract class ParsePopular {
  /// Build the url pointing to the [page] showing popular novels.
  String buildPopularUrl(int page);

  /// Acquire the most popular novels from the source.
  Future<List<Novel>> parsePopular(int page);
}

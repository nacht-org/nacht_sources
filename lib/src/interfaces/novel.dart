import 'package:chapturn_sources/src/interfaces/crawler.dart';
import 'package:chapturn_sources/src/models/models.dart';
import 'package:http/http.dart';

abstract class NovelCrawler extends Crawler {
  NovelCrawler({
    required Client client,
    required Meta meta,
  }) : super(client: client, meta: meta);

  /// Parse the novel by following the url
  ///
  /// Does not check if the url matches this crawler
  Future<Novel> parseNovel(String url);

  /// Parse the chapter and populate the content field
  ///
  /// [Chapter] must have the [url] field populated
  Future<void> parseChapter(Chapter chapter);

  /// helper method that takes just the url and returns
  /// the parsed chapter
  Future<Chapter> parseChapterWithUrl(String url) async {
    final chapter = Chapter.withUrl(url);
    await parseChapter(chapter);
    return chapter;
  }
}

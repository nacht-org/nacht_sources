import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class ChapterContentRequest extends RequestEvent<String?> {
  ChapterContentRequest(super.key, this.url);

  final String url;

  @override
  Future<String?> handle(Crawler crawler) async {
    if (crawler is! ParseNovel) {
      throw FeatureException("Chapter parsing is not supported.");
    }

    final chapter = Chapter.withUrl(url);
    await (crawler as ParseNovel).parseChapter(chapter);
    return chapter.content;
  }
}

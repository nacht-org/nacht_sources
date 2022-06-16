import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class NovelRequest extends RequestEvent<Novel> {
  NovelRequest(super.key, this.url);

  final String url;

  @override
  Future<Novel> handle(Crawler crawler) async {
    if (crawler is! ParseNovel) {
      throw FeatureException("Novel parsing is not supported.");
    }

    final novel = await (crawler as ParseNovel).parseNovel(url);
    return novel;
  }
}

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class BuildPopularUrlRequest extends RequestEvent<String> {
  BuildPopularUrlRequest(super.key, this.page);

  final int page;

  @override
  Future<String> handle(Crawler crawler) async {
    if (crawler is! ParsePopular) {
      throw FeatureException('Popular parsing is not supported');
    }

    return (crawler as ParsePopular).buildPopularUrl(page);
  }
}

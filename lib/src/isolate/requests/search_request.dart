import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class SearchRequest extends RequestEvent<List<Novel>> {
  SearchRequest(super.key, this.query, this.page);

  final String query;
  final int page;

  @override
  Future<List<Novel>> handle(Crawler crawler) async {
    if (crawler is! ParseSearch) {
      throw FeatureException('Search is not supported');
    }

    final novels = await (crawler as ParseSearch).search(query, page);
    return novels;
  }
}

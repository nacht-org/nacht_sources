import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class SearchRequest extends RequestEvent<List<Novel>> {
  SearchRequest(super.key, this.query, this.page);

  final String query;
  final int page;
}

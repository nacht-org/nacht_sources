import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/abstract_event.dart';

class SearchRequest extends Event {
  SearchRequest(super.key, this.query, this.page);

  final String query;
  final int page;

  SearchResponse response(List<Novel> novels) => SearchResponse(key, novels);
}

class SearchResponse extends Event {
  SearchResponse(super.key, this.novels);

  final List<Novel> novels;
}

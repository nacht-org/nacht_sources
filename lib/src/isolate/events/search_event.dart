import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/event.dart';

class SearchRequest extends Event {
  SearchRequest(super.key, this.query, this.page);

  final String query;
  final int page;
}

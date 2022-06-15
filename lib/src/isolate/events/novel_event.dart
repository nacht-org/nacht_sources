import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';

class NovelRequest extends Event {
  const NovelRequest(super.key, this.url);
  final String url;
}

class NovelResponse extends Event {
  const NovelResponse(super.key, this.novel);
  final Novel novel;
}

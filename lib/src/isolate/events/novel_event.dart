import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';

class NovelRequest extends Event {
  const NovelRequest(super.key, this.url);
  final String url;
}

abstract class NovelResponse extends Event {
  const NovelResponse(super.key);
}

class NovelDataEvent extends NovelResponse {
  const NovelDataEvent(super.key, this.novel);
  final Novel novel;
}

class NovelErrorEvent extends NovelResponse {
  const NovelErrorEvent(super.key, this.exception);
  final Object exception;
}

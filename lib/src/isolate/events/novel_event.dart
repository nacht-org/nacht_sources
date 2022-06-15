import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';

class NovelRequest extends Event {
  const NovelRequest(this.url);
  final String url;
}

abstract class NovelResponse extends Event {
  const NovelResponse();
}

class NovelDataEvent extends NovelResponse {
  const NovelDataEvent(this.novel);
  final Novel novel;
}

class NovelErrorEvent extends NovelResponse {
  const NovelErrorEvent(this.exception);
  final Object exception;
}

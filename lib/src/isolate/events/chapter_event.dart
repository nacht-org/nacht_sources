import 'package:nacht_sources/src/isolate/events/abstract_event.dart';

class ChapterRequest extends Event {
  ChapterRequest(super.key, this.url);

  final String url;

  ChapterResponse response(String? content) => ChapterResponse(key, content);
}

class ChapterResponse extends Event {
  ChapterResponse(super.key, this.content);

  final String? content;
}

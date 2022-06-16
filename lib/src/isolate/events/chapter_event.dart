import 'package:nacht_sources/src/isolate/events/event.dart';

class ChapterRequest extends Event {
  ChapterRequest(super.key, this.url);

  final String url;
}

import 'package:nacht_sources/src/isolate/events/events.dart';

class NovelRequest extends Event {
  const NovelRequest(super.key, this.url);

  final String url;
}

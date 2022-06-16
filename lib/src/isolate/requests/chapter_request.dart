import 'package:nacht_sources/src/isolate/events/event.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';

class ChapterContentRequest extends Request<String?> {
  ChapterContentRequest(super.key, this.url);

  final String url;
}

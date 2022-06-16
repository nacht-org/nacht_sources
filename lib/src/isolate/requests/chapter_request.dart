import 'package:nacht_sources/src/isolate/isolate.dart';

class ChapterContentRequest extends RequestEvent<String?> {
  ChapterContentRequest(super.key, this.url);

  final String url;
}

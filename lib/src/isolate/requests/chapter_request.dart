import 'package:nacht_sources/src/isolate/isolate.dart';

class ChapterContentRequest extends Request<String?> {
  ChapterContentRequest(super.key, this.url);

  final String url;
}

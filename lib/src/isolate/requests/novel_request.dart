import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class NovelRequest extends Request<Novel> {
  NovelRequest(super.key, this.url);

  final String url;
}

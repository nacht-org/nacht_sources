import 'package:nacht_sources/src/isolate/events/events.dart';

class BuildPopularUrlRequest extends Request<String> {
  BuildPopularUrlRequest(super.key, this.page);

  final int page;
}

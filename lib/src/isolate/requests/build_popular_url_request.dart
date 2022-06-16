import 'package:nacht_sources/src/isolate/isolate.dart';

class BuildPopularUrlRequest extends Request<String> {
  BuildPopularUrlRequest(super.key, this.page);

  final int page;
}

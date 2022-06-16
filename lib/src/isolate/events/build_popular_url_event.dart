import 'package:nacht_sources/src/isolate/events/events.dart';

class BuildPopularUrlRequest extends Event {
  BuildPopularUrlRequest(super.key, this.page);

  final int page;

  BuildPopularUrlResponse response(String url) =>
      BuildPopularUrlResponse(key, url);
}

class BuildPopularUrlResponse extends Event {
  BuildPopularUrlResponse(super.key, this.url);

  final String url;
}

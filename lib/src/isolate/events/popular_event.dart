import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/abstract_event.dart';

class PopularRequest extends Event {
  PopularRequest(super.key, this.page);

  final int page;

  PopularResponse response(List<Novel> novels) => PopularResponse(key, novels);
}

class PopularResponse extends Event {
  PopularResponse(super.key, this.novels);

  final List<Novel> novels;
}

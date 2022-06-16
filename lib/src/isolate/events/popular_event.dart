import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/event.dart';

class PopularRequest extends Event {
  PopularRequest(super.key, this.page);

  final int page;
}

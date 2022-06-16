import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/event.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';

class PopularRequest extends Request<List<Novel>> {
  PopularRequest(super.key, this.page);

  final int page;
}

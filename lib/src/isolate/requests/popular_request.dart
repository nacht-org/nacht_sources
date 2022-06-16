import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

class PopularRequest extends RequestEvent<List<Novel>> {
  PopularRequest(super.key, this.page);

  final int page;
}

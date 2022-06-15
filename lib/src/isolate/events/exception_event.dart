import 'package:nacht_sources/src/isolate/events/abstract_event.dart';

/// Event used by isolate to indicate that an error has occured
class ExceptionEvent extends Event {
  const ExceptionEvent(super.key, this.exception);
  final Object exception;
}

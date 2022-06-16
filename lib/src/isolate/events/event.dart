import 'package:nacht_sources/src/isolate/events/exception_event.dart';

/// The base event for communication between [IsolatedHandler] and [IsolatedRunner]
///
/// [key] is used to determine the corresponding response from
/// the isolate to the request event.
///
/// Set key to a negetive number if no response is expected.
///
/// See also:
/// - [IsolateRequest] base class for events that expect a response
abstract class Event {
  const Event(this.key);

  /// Links requests from main to isolate to responses from isolate to main.
  final int key;

  /// Create an exception event with this events key.
  ExceptionEvent error(Object exception) => ExceptionEvent(key, exception);

  /// Create a reply event with this events key.
  ReplyEvent reply<T>(T value) => ReplyEvent<T>(key, value);
}

/// Signal that the isolate must be closed.
class ExitEvent extends Event {
  const ExitEvent() : super(-1);
}

/// Return a [value] from the isolate to the main thread.
class ReplyEvent<T> extends Event {
  ReplyEvent(super.key, this.value);

  /// The value being sent from the isolate thread.
  final T value;
}

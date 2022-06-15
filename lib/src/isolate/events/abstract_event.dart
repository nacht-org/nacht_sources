/// The base event for communication between [IsolatedHandler] and [IsolatedRunner]
///
/// [key] is used to determine the corresponding response from
/// the isolate to the request event.
///
/// See also:
/// - [IsolateRequest] base class for events that expect a response
abstract class Event {
  const Event(this.key);

  /// Links requests from main to isolate to responses from isolate to main
  final int key;
}

/// Signal that the isolate must be closed.
class ExitEvent extends Event {
  const ExitEvent() : super(-1);
}

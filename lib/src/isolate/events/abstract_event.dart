/// The base event for communication between [IsolatedHandler] and [IsolatedRunner]
///
/// These event do no expect a response from the isolate.
///
/// See also:
/// - [IsolateRequest] base class for events that expect a response
abstract class Event {
  const Event();
}

/// Signal that the isolate must be closed.
class ExitEvent extends Event {
  const ExitEvent();
}

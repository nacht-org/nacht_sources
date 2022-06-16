import 'package:nacht_sources/src/isolate/isolate.dart';

/// A [Request] is an event that expects a [reply] from the isolate
///
/// [T] indicates the expected return type.
class Request<T> extends Event {
  const Request(super.key);

  /// Create a reply event with this events key.
  ReplyEvent reply(T value) => ReplyEvent<T>(key, value);
}

/// Return a [value] from the isolate to the main thread.
class ReplyEvent<T> extends Event {
  ReplyEvent(super.key, this.value);

  /// The value being sent from the isolate thread.
  final T value;
}

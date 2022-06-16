import 'package:nacht_sources/src/isolate/events/events.dart';

/// A [Request] is an event that expects a [reply] from the isolate
///
/// [T] indicates the expected return type.
class Request<T> extends Event {
  const Request(super.key);

  /// Create a reply event with this events key.
  ReplyEvent reply(T value) => ReplyEvent<T>(key, value);
}

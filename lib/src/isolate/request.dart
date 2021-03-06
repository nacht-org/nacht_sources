import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';

/// A [RequestEvent] is an event that expects a [respond] from the isolate
///
/// [T] indicates the expected return type.
abstract class RequestEvent<T> extends Event {
  const RequestEvent(super.key);

  /// Create a response event with this events key.
  ResponseEvent respond(T value) => ResponseEvent<T>(key, value);

  /// Produce a response [T] from this request.
  Future<T> handle(Crawler crawler);
}

/// Return a [value] of type [T] from the isolate to the main thread.
class ResponseEvent<T> extends Event {
  ResponseEvent(super.key, this.value);

  /// The value being sent from the isolate thread.
  final T value;
}

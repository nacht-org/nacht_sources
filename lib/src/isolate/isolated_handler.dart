import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';
import 'package:stream_channel/isolate_channel.dart';

class IsolatedHandler {
  IsolatedHandler({
    required this.factory,
  }) {
    _receivePort = ReceivePort();
    _channel = IsolateChannel.connectReceive(_receivePort);
  }

  final CrawlerFactory factory;

  Isolate? _isolate;
  int count = 0;

  late final ReceivePort _receivePort;
  late final IsolateChannel<Event> _channel;

  Future<Isolate> get _ensureInitialized async {
    return _isolate ??= await Isolate.spawn(
      IsolatedRunner.start,
      IsolatedInput(
        sendPort: _receivePort.sendPort,
        factory: factory,
      ),
    );
  }

  /// Throws
  Future<Novel> parseNovel(String url) async {
    final response =
        await _send<NovelRequest, NovelResponse>(NovelRequest(count++, url));

    if (response is NovelDataEvent) {
      return response.novel;
    } else if (response is NovelErrorEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  /// Helper method to send a [request] and wait for an response
  Future<R> _send<T extends Event, R>(T request) async {
    await _ensureInitialized;
    _channel.sink.add(request);
    return await _channel.stream.firstWhere((event) => event.key == request.key)
        as R;
  }

  /// Closes the handler and the corresponding isolate.
  void close() {
    /// Send exit event to isolate if initialized.
    if (_isolate != null) {
      _channel.sink.add(const ExitEvent());
      _isolate!.kill();
    }

    _channel.sink.close();
    _receivePort.close();
  }
}

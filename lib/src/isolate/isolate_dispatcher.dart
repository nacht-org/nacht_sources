import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';
import 'package:stream_channel/isolate_channel.dart';

class IsolateDispatcher {
  IsolateDispatcher({
    required this.factory,
  }) {
    _receivePort = ReceivePort();
    _channel = IsolateChannel.connectReceive(_receivePort);
    _stream = _channel.stream.asBroadcastStream();
  }

  final CrawlerFactory factory;

  late final ReceivePort _receivePort;
  late final IsolateChannel<Event> _channel;
  late final Stream<Event> _stream;

  Isolate? _isolate;
  int count = 0;

  Future<Isolate> _ensureInitialized() async {
    return _isolate ??= await Isolate.spawn(
      IsolateHandler.start,
      IsolateInput(
        sendPort: _receivePort.sendPort,
        factory: factory,
      ),
    );
  }

  Future<Novel> fetchNovel(String url) async {
    final response = await _send(NovelRequest(count++, url));

    if (response is NovelResponse) {
      return response.novel;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  Future<String?> fetchChapterContent(String url) async {
    final response = await _send(ChapterRequest(count++, url));

    if (response is ChapterResponse) {
      return response.content;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  Future<String> buildPopularUrl(int page) async {
    final response = await _send(BuildPopularUrlRequest(count++, page));

    if (response is BuildPopularUrlResponse) {
      return response.url;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  Future<List<Novel>> fetchPopular(int page) async {
    final response = await _send(PopularRequest(count++, page));

    if (response is PopularResponse) {
      return response.novels;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  Future<List<Novel>> fetchSearch(String query, int page) async {
    final response = await _send(SearchRequest(count++, query, page));

    if (response is SearchResponse) {
      return response.novels;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  /// Helper method to send a [request] and wait for an response
  Future<R> _send<T extends Event, R>(T request) async {
    await _ensureInitialized();
    _channel.sink.add(request);
    return await _stream.firstWhere((event) => event.key == request.key) as R;
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

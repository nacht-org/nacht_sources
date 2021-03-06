import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';
import 'package:stream_channel/isolate_channel.dart';

class CrawlerIsolate {
  CrawlerIsolate({
    String? debugName,
    required this.factory,
  }) : debugName = debugName ?? 'Crawler(${factory.meta().id})' {
    _receivePort = ReceivePort();
    _channel = IsolateChannel.connectReceive(_receivePort);
    _stream = _channel.stream.asBroadcastStream();
  }

  final String debugName;
  final CrawlerFactory factory;

  late final ReceivePort _receivePort;
  late final IsolateChannel<Event> _channel;
  late final Stream<Event> _stream;

  Isolate? _isolate;
  int count = 0;

  Future<Isolate> _ensureInitialized() async {
    return _isolate ??= await Isolate.spawn(
      IsolateWorker.start,
      IsolateInput(
        sendPort: _receivePort.sendPort,
        factory: factory,
      ),
      debugName: debugName,
    );
  }

  /// Equivalent to [ParseNovel.fetchNovel]
  Future<Novel> fetchNovel(String url) {
    return _request<NovelRequest, Novel>(
      NovelRequest(count++, url),
    );
  }

  /// Equivalent to [ParseNovel.fetchChapterContent]
  Future<String?> fetchChapterContent(String url) {
    return _request<ChapterContentRequest, String?>(
      ChapterContentRequest(count++, url),
    );
  }

  /// Equivalent to [ParsePopular.buildPopularUrl]
  Future<String> buildPopularUrl(int page) {
    return _request<BuildPopularUrlRequest, String>(
      BuildPopularUrlRequest(count++, page),
    );
  }

  /// Equivalent to [ParsePopular.fetchPopular]
  Future<List<Novel>> fetchPopular(int page) {
    return _request<PopularRequest, List<Novel>>(
      PopularRequest(count++, page),
    );
  }

  /// Equivalent to [ParseSearch.search]
  Future<List<Novel>> fetchSearch(String query, int page) {
    return _request<SearchRequest, List<Novel>>(
      SearchRequest(count++, query, page),
    );
  }

  /// Helper method that combines [_send] and [_expect]
  Future<R> _request<T extends RequestEvent<R>, R>(T request) async {
    final response = await _send<T>(request);
    return _expect<R>(response);
  }

  /// Helper method to send a [request] and wait for an response
  Future<Event> _send<T extends Event>(T request) async {
    await _ensureInitialized();
    _channel.sink.add(request);
    return _stream.firstWhere((event) => event.key == request.key);
  }

  /// Helper method to extract a [value] from a [response] of type [ReplyEvent<R>]
  R _expect<R>(Event response) {
    if (response is ResponseEvent<R>) {
      return response.value;
    } else if (response is ExceptionEvent) {
      throw response.exception;
    }

    throw Exception(); // Unreachable.
  }

  /// Closes the handler and the corresponding isolate.
  void close() {
    /// Send exit event to isolate if initialized.
    if (_isolate != null) {
      _channel.sink.add(const ExitEvent());
    }

    _channel.sink.close();
    _receivePort.close();
  }
}

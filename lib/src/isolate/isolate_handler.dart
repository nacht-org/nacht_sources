import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/isolate/isolate.dart';
import 'package:stream_channel/isolate_channel.dart';

class IsolateInput {
  const IsolateInput({
    required this.sendPort,
    required this.factory,
  });

  final SendPort sendPort;
  final CrawlerFactory factory;
}

class IsolateHandler {
  IsolateHandler(IsolateInput input) {
    _channel = IsolateChannel.connectSend(input.sendPort);
    _crawler = input.factory.basic();
  }

  static void start(IsolateInput input) => IsolateHandler(input).handle();

  late final IsolateChannel<Event> _channel;
  late final Crawler _crawler;

  void handle() {
    _channel.stream.listen((event) {
      if (event is RequestEvent) {
        handleRequest(event);
      } else if (event is ExitEvent) {
        close();
      }
    });
  }

  void _send(Event event) => _channel.sink.add(event);
  void _error(Event event, Object exception) => _send(event.error(exception));

  Future<void> handleRequest<T>(RequestEvent<T> event) async {
    try {
      final response = await event.handle(_crawler);
      return _send(event.respond(response));
    } catch (e) {
      return _error(event, e);
    }
  }

  void close() {
    _channel.sink.close();
    Isolate.current.kill();
  }
}

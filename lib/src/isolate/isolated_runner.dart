import 'dart:io';
import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/exceptions.dart';
import 'package:nacht_sources/src/isolate/events/novel_event.dart';
import 'package:stream_channel/isolate_channel.dart';

import 'events/events.dart';

class IsolatedInput {
  const IsolatedInput({
    required this.sendPort,
    required this.factory,
  });

  final SendPort sendPort;
  final CrawlerFactory factory;
}

class IsolatedRunner {
  IsolatedRunner(IsolatedInput input) {
    _channel = IsolateChannel.connectSend(input.sendPort);
    _meta = input.factory.meta();
    _crawler = input.factory.basic();
  }

  static void start(IsolatedInput input) => IsolatedRunner(input).listen();

  late final IsolateChannel<Event> _channel;
  late final Meta _meta;
  late final Crawler _crawler;

  void listen() {
    _channel.stream.listen((event) {
      if (event is NovelRequest) {
        parseNovel(event);
      } else if (event is ExitEvent) {
        _channel.sink.close();
      }
    });
  }

  void _send(Event event) => _channel.sink.add(event);

  Future<void> parseNovel(NovelRequest request) async {
    if (_crawler is! ParseNovel) {
      return _send(
        NovelErrorEvent(FeatureException("Novel parsing is not supported.")),
      );
    }

    try {
      final novel = await (_crawler as ParseNovel).parseNovel(request.url);
      return _send(NovelDataEvent(novel));
    } catch (e) {
      return _send(NovelErrorEvent(e));
    }
  }
}

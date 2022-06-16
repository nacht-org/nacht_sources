import 'dart:isolate';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/exceptions.dart';
import 'package:nacht_sources/src/isolate/events/events.dart';
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
      if (event is NovelRequest) {
        parseNovel(event);
      } else if (event is ChapterRequest) {
        parseChapter(event);
      } else if (event is BuildPopularUrlRequest) {
        buildPopularUrl(event);
      } else if (event is PopularRequest) {
        parsePopular(event);
      } else if (event is SearchRequest) {
        parseSearch(event);
      } else if (event is ExitEvent) {
        _channel.sink.close();
      }
    });
  }

  void _send(Event event) => _channel.sink.add(event);
  void _error(Event event, Object exception) => _send(event.error(exception));

  Future<void> parseNovel(NovelRequest request) async {
    if (_crawler is! ParseNovel) {
      return _error(
        request,
        FeatureException("Novel parsing is not supported."),
      );
    }

    try {
      final novel = await (_crawler as ParseNovel).parseNovel(request.url);
      return _send(request.reply<Novel>(novel));
    } catch (e) {
      return _error(request, e);
    }
  }

  Future<void> parseChapter(ChapterRequest request) async {
    if (_crawler is! ParseNovel) {
      return _error(
        request,
        FeatureException("Chapter parsing is not supported."),
      );
    }

    try {
      final chapter = Chapter.withUrl(request.url);
      await (_crawler as ParseNovel).parseChapter(chapter);
      return _send(request.reply<String?>(chapter.content));
    } catch (e) {
      return _error(request, e);
    }
  }

  Future<void> buildPopularUrl(BuildPopularUrlRequest request) async {
    if (_crawler is! ParsePopular) {
      return _error(
        request,
        FeatureException('Popular parsing is not supported'),
      );
    }

    try {
      final url = (_crawler as ParsePopular).buildPopularUrl(request.page);
      return _send(request.reply<String>(url));
    } catch (e) {
      return _error(request, e);
    }
  }

  Future<void> parsePopular(PopularRequest request) async {
    if (_crawler is! ParsePopular) {
      return _error(
        request,
        FeatureException('Popular parsing is not supported'),
      );
    }

    try {
      final novels =
          await (_crawler as ParsePopular).parsePopular(request.page);
      return _send(request.reply<List<Novel>>(novels));
    } catch (e) {
      return _error(request, e);
    }
  }

  Future<void> parseSearch(SearchRequest request) async {
    if (_crawler is! ParseSearch) {
      return _error(request, FeatureException('Search is not supported'));
    }

    try {
      final novels =
          await (_crawler as ParseSearch).search(request.query, request.page);
      return _send(request.reply<List<Novel>>(novels));
    } catch (e) {
      return _error(request, e);
    }
  }
}

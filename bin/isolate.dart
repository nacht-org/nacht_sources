// ignore_for_file: avoid_print

import 'dart:math';

import 'package:nacht_sources/nacht_sources.dart';

void main() async {
  final handler = CrawlerIsolate(factory: crawlers.values.elementAt(3));

  // await novel(
  //   handler,
  //   'https://www.scribblehub.com/series/255716/the-great-cores-paradox-monster-mc-litrpg/',
  // );

  await content(
    handler,
    'https://www.scribblehub.com/read/383775-weaponsmith--a-crafting-litrpg/chapter/507614/',
  );
  await content(
    handler,
    'https://www.scribblehub.com/read/397857-stealing-spotlight-of-protagonist/chapter/493208/',
  );

  // await popularUrl(handler, 1);
  // await popular(handler, 1);

  // await search(handler, 'solo', 1);

  handler.close();
}

Future<void> novel(CrawlerIsolate dispatcher, String url) async {
  return scope(() async {
    final data = await dispatcher.fetchNovel(url);
    print('url: $url,\n  title: ${data.title}\n  author: ${data.author}');
    print('');
  });
}

Future<void> content(CrawlerIsolate handler, String url) async {
  return scope(() async {
    final data = await handler.fetchChapterContent(url);
    print('url: $url,\n  content: ${data?.substring(0, 75)}');
    print('');
  });
}

Future<void> popular(CrawlerIsolate handler, int page) {
  return scope(() async {
    final data = await handler.fetchPopular(page);
    print('page: $page,');
    printNovels(data);
    print('');
  });
}

Future<void> popularUrl(CrawlerIsolate handler, int page) {
  return scope(() async {
    final data = await handler.buildPopularUrl(page);
    print('page: $page,\n  url: $data');
    print('');
  });
}

Future<void> search(CrawlerIsolate handler, String query, int page) {
  return scope(() async {
    final data = await handler.fetchSearch(query, page);
    print('query: $query, page: $page,');
    printNovels(data);
    print('');
  });
}

void printNovels(List<Novel> data) {
  for (var i = 0; i < min(5, data.length); i++) {
    print('  $i: ${data[i].title}');
  }
}

Future<void> scope(Future<void> Function() callback) async {
  try {
    await callback();
  } catch (e) {
    print(e);
  }
}

// ignore_for_file: avoid_print

import 'dart:math';

import 'package:nacht_sources/nacht_sources.dart';

void main() async {
  final handler = IsolatedHandler(factory: crawlers[3]);
  await content(
    handler,
    'https://www.scribblehub.com/read/383775-weaponsmith--a-crafting-litrpg/chapter/507614/',
  );
  await content(
    handler,
    'https://www.scribblehub.com/read/397857-stealing-spotlight-of-protagonist/chapter/493208/',
  );
  await popularUrl(handler, 1);
  await popular(handler, 1);

  handler.close();
}

Future<void> content(IsolatedHandler handler, String url) async {
  return scope(() async {
    final data = await handler.fetchChapterContent(url);
    print('url: $url,\n  content: ${data?.substring(0, 75)}');
    print('');
  });
}

Future<void> popular(IsolatedHandler handler, int page) {
  return scope(() async {
    final data = await handler.fetchPopular(page);
    print('page: $page,');
    printNovels(data);
    print('');
  });
}

Future<void> popularUrl(IsolatedHandler handler, int page) {
  return scope(() async {
    final data = await handler.buildPopularUrl(page);
    print('page: $page,\n  url: $data');
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

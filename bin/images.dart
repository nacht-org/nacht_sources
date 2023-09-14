// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:nacht_sources/src/misc/html_utils.dart';

void main(List<String> args) async {
  final url = args.single;

  final client = Dio();
  await for (final link in scrape(client, url)) {
    print(link);
  }
}

Stream<String> scrape(Dio client, String url) async* {
  final response = await client.get(url);
  final doc = parse(response.data);

  final ogImages = doc.selectAll("meta[name='og:image']");
  for (final element in ogImages) {
    final href = element.attributes['content'];
    if (href != null) {
      yield href;
    }
  }

  final twitterImages = doc.selectAll("meta[name='twitter:image']");
  for (final element in twitterImages) {
    final href = element.attributes['content'];
    if (href != null) {
      yield href;
    }
  }

  final links = doc.selectAll("link[rel*='icon']");
  for (final link in links) {
    final href = link.attributes['href'];
    if (href != null) {
      yield href;
    }
  }

  final imgs = doc.selectAll("img");
  element:
  for (final img in imgs) {
    final srcAttributes = ['src', 'data-src'];

    for (final key in srcAttributes) {
      final value = img.attributes[key];
      if (value != null) {
        yield value;
        continue element;
      }
    }
  }
}

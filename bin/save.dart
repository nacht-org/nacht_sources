// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:nacht_sources/nacht_sources.dart';
import 'package:path/path.dart' as path;

const temp = 'temp/';

void main(List<String> args) async {
  assert(
    args.length == 1,
    "missing argument <url> at 1st position",
  );

  final url = args.first;
  final crawler = crawlerFactoryFor(url)!.basic();

  final content = await (crawler as ParseNovel).fetchChapterContent(url);

  await Directory(temp).create();
  await File(path.join(temp, 'save.html')).writeAsString(content!);
}

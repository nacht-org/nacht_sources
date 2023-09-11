// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:nacht_sources/nacht_sources.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('novel', abbr: 'n')
    ..addOption('chapter', abbr: 'c')
    ..addFlag('popular', abbr: 'p')
    ..addOption('search', abbr: 's')
    ..addOption('page', defaultsTo: '1');

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    error(e);
    exit(1);
  }

  final novel = results['novel'] as String?;
  final chapter = results['chapter'] as String?;
  final popular = results['popular'] as bool;
  final search = results['search'] as String?;
  final page = int.parse(results['page'] as String);

  if (novel != null && !popular && search == null) {
    final data = await getParser(novel).fetchNovel(novel);
    print(data);
  }

  if (chapter != null) {
    final data = await getParser(chapter).fetchChapterContent(chapter);
    print(data);
  }

  if (popular) {
    final data = await getParser(novel!).fetchPopular(page);
    print(data);
  }

  if (search != null) {
    final data = await getParser(novel!).search(search, page);
    print(data);
  }
}

ParseNovel getParser(String url) {
  final factory = crawlerFactoryFor(url);
  if (factory == null) {
    error("Crawler factory not found for $url");
    exit(1);
  }

  final crawler = factory.basic();
  final parser = crawler as ParseNovel;

  return parser;
}

void error(Object value) {
  stderr.writeln("ERROR: $value");
}

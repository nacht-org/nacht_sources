import 'package:chapturn_sources/chapturn_sources.dart';

void parseNovel(String url, int rangeFrom, int rangeTo) async {
  final crawlerFactory = crawlerFactoryFor(url);
  if (crawlerFactory == null) {
    return;
  }

  final crawler = crawlerFactory.basic();
  if (crawler is! ParseNovel) {
    print("${crawler.meta.name} does not support novel parsing");
    return;
  }

  final novelParser = crawler as ParseNovel;

  final novel = await novelParser.parseNovel(url);
  print("Novel(title='${novel.title}', chapters=${novel.chapterCount()})");

  final chapters = <Chapter>[];
  for (var volume in novel.volumes) {
    chapters.addAll(volume.chapters);
  }

  final chaptersRange = chapters.sublist(rangeFrom, rangeTo);
  for (var chapter in chaptersRange) {
    await novelParser.parseChapter(chapter);
    print(
      "Chapter(index=${chapter.index}, title='${chapter.title}', content='${chapter.content?.length ?? 0}')",
    );
  }
}

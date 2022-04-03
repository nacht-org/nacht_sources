import 'package:chapturn_sources/chapturn_sources.dart';

void parseNovel(String url, int rangeFrom, int rangeTo) async {
  final crawlerFactory = getCrawlerFactoryWithUrl(url);
  if (crawlerFactory == null) {
    return;
  }

  final crawler = crawlerFactory.create();

  final novel = await crawler.parseNovel(url);
  print("Novel(title='${novel.title}', chapters=${novel.chapterCount()})");

  final chapters = <Chapter>[];
  for (var volume in novel.volumes) {
    chapters.addAll(volume.chapters);
  }

  final chaptersRange = chapters.sublist(rangeFrom, rangeTo);
  for (var chapter in chaptersRange) {
    await crawler.parseChapter(chapter);
    print(
      "Chapter(index=${chapter.index}, title='${chapter.title}', content='${chapter.content?.length ?? 0}')",
    );
  }
}

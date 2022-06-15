import 'package:nacht_sources/nacht_sources.dart';

void main() async {
  final handler = IsolatedHandler(factory: crawlers[3]);

  final url =
      'https://www.scribblehub.com/series/511379/i-am-just-a-dclass-hunter/';
  try {
    final novel = await handler.parseNovel(
        'https://www.novelupdates.com/series/good-man-operation-guide-quick-wear/');
    print(novel.title);
  } catch (e) {}

  handler.close();
}

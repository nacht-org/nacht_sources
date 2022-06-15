import 'package:nacht_sources/nacht_sources.dart';

void main() async {
  final handler = IsolatedHandler(factory: crawlers[3]);

  final url =
      'https://www.scribblehub.com/read/383775-weaponsmith--a-crafting-litrpg/chapter/507614/';
  try {
    final data = await handler.fetchChapterContent(url);
    print(data);
  } catch (e) {
    print(e.runtimeType);
  }

  handler.close();
}

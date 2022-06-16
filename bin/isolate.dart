import 'package:nacht_sources/nacht_sources.dart';

Future<void> fetch(IsolatedHandler handler, String url) async {
  try {
    final data = await handler.fetchChapterContent(url);
    print('url: $url,    \n content: ${data?.substring(0, 75)}');
    print('');
  } catch (e) {
    print(e);
  }
}

void main() async {
  final handler = IsolatedHandler(factory: crawlers[3]);
  await fetch(
    handler,
    'https://www.scribblehub.com/read/383775-weaponsmith--a-crafting-litrpg/chapter/507614/',
  );
  await fetch(
    handler,
    'https://www.scribblehub.com/read/397857-stealing-spotlight-of-protagonist/chapter/493208/',
  );

  handler.close();
}

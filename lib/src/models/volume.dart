import 'package:chapturn_sources/src/models/chapter.dart';

class Volume {
  int index;
  String name;
  List<Chapter> chapters;

  Volume({
    required this.index,
    required this.name,
    List<Chapter>? chapters,
  }) : chapters = chapters ?? [];

  Volume.def([List<Chapter>? chapters])
      : this(
          index: -1,
          name: '_default',
          chapters: chapters,
        );
}

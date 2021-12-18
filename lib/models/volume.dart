import 'package:chapturn_sources/models/chapter.dart';

class Volume {
  int index;
  String name;
  List<Chapter> chapters;

  Volume({
    required this.index,
    required this.name,
    this.chapters = const [],
  });

  Volume.def() : this(index: -1, name: '_default');
}

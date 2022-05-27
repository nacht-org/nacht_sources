import 'package:nacht_sources/src/models/meta.dart';
import 'package:nacht_sources/src/models/metadata.dart';
import 'package:nacht_sources/src/models/status.dart';
import 'package:nacht_sources/src/models/volume.dart';
import 'package:nacht_sources/src/models/work_type.dart';
import 'package:collection/collection.dart';

class Novel {
  String title;
  String url;
  String? author;
  List<String> description;
  String? thumbnailUrl;
  NovelStatus status;
  String lang;
  List<Volume> volumes;
  List<MetaData> metadata;
  WorkType workType;
  ReadingDirection readingDirection;

  Novel({
    required this.title,
    required this.url,
    this.author,
    List<String>? description,
    this.thumbnailUrl,
    this.status = NovelStatus.unknown,
    required this.lang,
    List<Volume>? volumes,
    List<MetaData>? metadata,
    this.workType = const UnknownWorkType(),
    this.readingDirection = ReadingDirection.ltr,
  })  : description = description ?? [],
        volumes = volumes ?? [],
        metadata = metadata ?? [];

  /// Add new metadata to the novel
  void addMeta(
    String name,
    String value, [
    Map<String, String> others = const {},
  ]) {
    metadata.add(MetaData(name, value, others));
  }

  /// Single default volume configuration
  /// to be used when novel has no defined
  /// volumes
  Volume singleVolume() {
    Volume volume;
    if (volumes.isEmpty) {
      volume = Volume.def();
      volumes.add(volume);
    } else {
      volume = volumes.first;
    }

    return volume;
  }

  int chapterCount() {
    return volumes.map((v) => v.chapters.length).sum;
  }
}

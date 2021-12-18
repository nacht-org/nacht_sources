import './volume.dart';
import './metadata.dart';

class Novel {
  String title;
  String url;
  String? author;
  List<String> description;
  String? thumbnailUrl;
  String? status;
  String lang;
  List<Volume> volumes;
  List<MetaData> metadata;

  Novel({
    required this.title,
    required this.url,
    this.author,
    this.description = const [],
    this.thumbnailUrl,
    this.status,
    required this.lang,
    this.volumes = const [],
    this.metadata = const [],
  });
}

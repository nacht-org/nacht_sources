abstract class CrawlerVersion implements Comparable<CrawlerVersion> {
  const CrawlerVersion();

  String get version;

  @override
  int compareTo(CrawlerVersion other) => version.compareTo(other.version);

  @override
  String toString() => '$runtimeType($version)';
}

/// Version type that uses the updated date to keep track
class SemanticVersion extends CrawlerVersion {
  final int major;
  final int minor;
  final int patch;

  const SemanticVersion(this.major, this.minor, this.patch);

  @override
  String get version => '$major.$minor.$patch';
}

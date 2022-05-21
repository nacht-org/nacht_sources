abstract class CrawlerVersion implements Comparable<CrawlerVersion> {
  const CrawlerVersion();

  String get version;

  @override
  int compareTo(CrawlerVersion other) => version.compareTo(other.version);

  @override
  String toString() => '$runtimeType($version)';
}

/// Version type that uses the updated date to keep track
class DateVersion extends CrawlerVersion {
  final int year;
  final int month;
  final int day;

  const DateVersion(this.year, this.month, this.day);

  DateTime get datetime => DateTime(year, month, day);

  @override
  String get version => '$year.$month.$day';
}

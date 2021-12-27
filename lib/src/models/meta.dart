import './support.dart';
import './work_type.dart';

/// Defines the optional features of a crawler
enum Feature {
  search,
  login,
}

/// Defines the reading direction of crawler
enum ReadingDirection {
  ltr,
  rtl,

  /// Identifies that a source [Meta] has mixed reading direction
  /// and the reading direction of [Novel] is not known
  mixed,
}

/// Constant date holder class, because DateTime
/// does not have a constant constructor
///
/// use [datetime] method to convert to [DateTime] equivalent
class DateHolder {
  final int year;
  final int month;
  final int day;

  const DateHolder(this.year, this.month, this.day);

  DateTime datetime() => DateTime(year, month, day);
}

class Meta {
  final String name;
  final String lang;
  final DateHolder updated;
  final Set<String> baseUrls;
  final Set<Feature> features;
  final Support support;

  /// Identifies the type of work provided by this source
  ///
  /// [UnknownWorkType] identifies either mixed or unknown
  final WorkType workType;

  /// Identifies the reading direction of novels
  /// offered by this source
  final ReadingDirection readingDirection;

  const Meta({
    required this.name,
    required this.lang,
    required this.updated,
    required this.baseUrls,
    this.features = const {},
    this.support = HasSupport.full,
    this.workType = const UnknownWorkType(),
    this.readingDirection = ReadingDirection.ltr,
  });

  /// Check whether the url is from the this source
  ///
  /// This implementation checks if the hostname of the
  /// url matches any of the base urls of the source.
  bool of(String url) {
    for (String baseUrl in baseUrls) {
      if (url.startsWith(baseUrl)) {
        return true;
      }
    }

    return false;
  }
}

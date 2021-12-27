import './support.dart';
import './work_type.dart';

/// Defines the optional features of a crawler
enum Feature {
  /// Ability to search for novels
  search,

  /// Ability to login into the source to
  /// otherwise forbidden content
  login,
}

/// Defines the reading direction of crawler
enum ReadingDirection {
  /// Left to right
  ltr,

  /// Right to left
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

/// Defines the metadata of a crawler
class Meta {
  /// The name of the source. Usually equivalent to the
  /// name of the crawler class
  final String name;

  /// The languages of the novels offered by the source
  ///
  /// Use abbreviations of languages. ex: 'en' for English
  /// and 'de' for German
  ///
  /// Use comma-separated values for multiple specific
  /// values. ex: 'en,de'
  ///
  /// Use 'mixed' if source offers novels in
  /// multiple languages
  final String lang;

  /// The last time the source was updated
  final DateHolder updated;

  /// The base urls / host urls of the target site
  ///
  /// Must include the scheme (http:,https:)
  ///
  /// ex: 'https://www.webnovel.com/', 'https://www.scribblehub.com/'
  final Set<String> baseUrls;

  /// Optional features supported by the crawler
  ///
  /// ex: search, login
  final Set<Feature> features;

  /// Identifies the support for this crawler
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

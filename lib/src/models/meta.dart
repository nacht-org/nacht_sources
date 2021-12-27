import './support.dart';

/// Defines the optional features of a crawler
enum Feature {
  search,
  login,
}

/// Defines the reading direction of crawler
enum ReadingDirection {
  ltr,
  rtl,
  mixed,
}

/// Defines the translation types
enum TranslationType {
  original,
  mtl,
  human,
  mixed,
  unknown,
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
  final TranslationType translationType;
  final ReadingDirection readingDirection;

  const Meta({
    required this.name,
    required this.lang,
    required this.updated,
    required this.baseUrls,
    this.features = const {},
    this.support = HasSupport.full,
    this.translationType = TranslationType.original,
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

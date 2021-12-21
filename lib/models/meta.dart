/// Defines the optional features of a crawler
enum Feature {
  search,
  login,
}

/// Defines the support of a crawler
enum Support {
  full,
  browserOnly,
  discontinued,
  rejected,
}

/// Defines the reading direction of crawler
enum ReadingDirection {
  right,
  left,
  mixed,
}

/// Defines the translation types
enum TranslationType {
  original,
  mtl,
  human,
  mixed,
}

class Meta {
  final String name;
  final String lang;

  /// list is used as a stop gap measure since
  /// [DateTime] does not have a const constructor
  final List<int> updated;
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
    this.support = Support.full,
    this.translationType = TranslationType.original,
    this.readingDirection = ReadingDirection.left,
  });

  DateTime get updatedDate {
    return DateTime(updated[0], updated[1], updated[2]);
  }

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

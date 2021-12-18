/// Defines the optional features of a crawler
enum Feature {
  search,
  login,
}

// Defines the support of a crawler
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
  final List<int> lastUpdated;
  final Set<String> baseUrls;
  final Set<Feature> features;
  final Support support;
  final bool mtl;
  final ReadingDirection readingDirection;

  const Meta({
    required this.name,
    required this.lang,
    required this.lastUpdated,
    required this.baseUrls,
    this.features = const {},
    this.support = Support.full,
    this.mtl = false,
    this.readingDirection = ReadingDirection.left,
  });

  DateTime get updated {
    return DateTime(lastUpdated[0], lastUpdated[1], lastUpdated[2]);
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

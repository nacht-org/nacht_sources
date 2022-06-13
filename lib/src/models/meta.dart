import 'package:nacht_sources/nacht_sources.dart';
import 'package:nacht_sources/src/extensions/string_strip.dart';

/// Defines the optional features of a crawler
enum Feature {
  /// Ability to search for novels
  search,

  /// Ability to login into the source to
  /// otherwise forbidden content
  login,

  /// Ability to acquire the most popular novels.
  popular,

  /// Ability to acquire the latest updated novels.
  latest,
}

/// Defines the reading direction of crawler
enum ReadingDirection {
  /// Left to right
  ltr,

  /// Right to left
  rtl,
}

/// Special attributes that can be used to define
/// a source or a novel
enum Attribute {
  /// Identifies that the source offers fanfiction novels
  fanfiction
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
  final CrawlerVersion version;

  /// The base urls / host urls of the target site
  ///
  /// Must include the scheme (http:,https:)
  ///
  /// ex: 'https://www.webnovel.com/', 'https://www.scribblehub.com/'
  final List<String> baseUrls;

  /// Optional features supported by the crawler
  ///
  /// ex: search, login
  final Set<Feature> features;

  /// Identifies the support for this crawler
  final Support support;

  /// Identifies the type of work provided by this source
  ///
  /// [UnknownWorkType] identifies either mixed or unknown
  final List<WorkType> workTypes;

  /// Identifies the reading directions of novels
  /// offered by this source
  final List<ReadingDirection> readingDirections;

  /// Identifies special attributes about the source
  ///
  /// ex: fanfiction sites
  final List<Attribute> attributes;

  const Meta({
    required this.name,
    required this.lang,
    required this.version,
    required this.baseUrls,
    this.features = const {},
    this.support = Support.all,
    List<WorkType>? workTypes,
    List<ReadingDirection>? readingDirections,
    List<Attribute>? attributes,
  })  : workTypes = workTypes ?? const [UnknownWorkType()],
        readingDirections = readingDirections ?? const [ReadingDirection.ltr],
        attributes = attributes ?? const [];

  /// The consistent part or the root of your website's address
  ///
  /// For example, http://www.YourDomain.com
  ///
  /// Must include the scheme (http:,https:)
  String get baseUrl => baseUrls[0];

  /// Check whether the url is from the this source
  ///
  /// This implementation checks if the hostname of the
  /// url matches any of the base urls of the source.
  bool of(String url) {
    for (final baseUrl in baseUrls) {
      if (url.startsWith(baseUrl)) {
        return true;
      }
    }

    return false;
  }

  /// Detects the url state and converts it into the appropriate absolute url
  ///
  /// There are several relevant states the url could be in:
  ///
  /// - absolute: starts with either 'https://' or 'http://', in this the url
  ///   is returned as it without any changes.
  ///
  /// - missing schema: schema is missing and the url starts with '//', in this
  ///   case the appropriate schema from either current url or base url is prefixed.
  ///
  /// - relative absolute: the url is relative to the website and starts with '/', in
  ///   this case the base website location (netloc) is prefixed to the url:
  ///
  /// - relative current: the url is relative to the current webpage and does not match
  ///   any of the above conditions, in this case the url is added to the current url provided.
  String absoluteUrl(String url, [String? current]) {
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    } else if (url.startsWith("//")) {
      return '${Uri.parse(current ?? baseUrls[0]).scheme}:$url';
    } else if (url.startsWith("/")) {
      return baseUrls[0].stripRight("/") + url;
    }

    if (current != null) {
      return current.stripRight("/") + url;
    } else {
      return url;
    }
  }
}

import 'package:equatable/equatable.dart';

/// Defines platform categories
enum SupportPlatform {
  /// windows, linux, and macos
  desktop,

  /// android and ios
  mobile,

  /// chrome, firefox, edge, etc
  browser,

  /// web hosted (not tested)
  web,
}

/// Base class that defines support for a crawler
abstract class Support extends Equatable {
  const Support();
}

/// Defines that a crawler is supported
///
/// See [platforms] for more information
class HasSupport extends Support {
  /// Identifies all the platforms that
  /// are supported
  final List<SupportPlatform> platforms;

  const HasSupport(this.platforms);

  static const HasSupport full = HasSupport(SupportPlatform.values);
  static const HasSupport browserOnly = HasSupport([SupportPlatform.browser]);

  @override
  List<Object?> get props => [platforms];
}

/// Defines that support for crawler has either
/// been discontinued or rejected
///
/// See [reason] for more information
class NoSupport extends Support {
  /// The reason why there is no support
  final String reason;

  const NoSupport(this.reason);

  @override
  List<Object?> get props => [reason];
}

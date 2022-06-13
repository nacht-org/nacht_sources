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

/// Base class that defines support for a crawler.
///
/// See also:
/// - [_PlatformsSupport], subclass that defines support for platforms.
/// - [_NoneSupport], subclass that indicates no support.
abstract class Support extends Equatable {
  const Support();

  /// Defines that a crawler is supported by the [platforms]
  ///
  /// See also:
  /// - [Support.all]
  /// - [Support.browserOnly]
  const factory Support.platforms(List<SupportPlatform> platforms) =
      _PlatformsSupport;

  /// Defines that support for crawler has either
  /// been discontinued or rejected due to [reason]
  const factory Support.none(String reason) = _NoneSupport;

  /// Support with all [SupportPlatform]s supported
  static const Support all = Support.platforms(SupportPlatform.values);

  /// Support with only [SupportPlatform.browser] supported
  static const Support browserOnly =
      Support.platforms([SupportPlatform.browser]);

  /// Check if a specific platform is supported.
  bool isPlatformSupported(SupportPlatform platform) {
    return this is _PlatformsSupport &&
        (this as _PlatformsSupport).platforms.contains(platform);
  }

  /// Union helper to distinguish between support types
  T when<T>({
    required T Function(List<SupportPlatform> platforms) platforms,
    required T Function(String reason) none,
  }) {
    if (this is _PlatformsSupport) {
      return platforms((this as _PlatformsSupport).platforms);
    } else {
      return none((this as _NoneSupport).reason);
    }
  }
}

class _PlatformsSupport extends Support {
  /// Identifies all the platforms that are supported
  final List<SupportPlatform> platforms;

  const _PlatformsSupport(this.platforms);

  @override
  List<Object?> get props => [platforms];
}

///
/// See [reason] for more information
class _NoneSupport extends Support {
  /// The reason why there is no support
  final String reason;

  const _NoneSupport(this.reason);

  @override
  List<Object?> get props => [reason];
}

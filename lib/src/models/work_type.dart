import 'package:equatable/equatable.dart';

/// Defines translation type
enum TranslationType {
  mtl,
  human,
  unknown,
}

/// Base class that defines the writing type of novel,
/// original, translated, etc
abstract class WorkType extends Equatable {
  const WorkType();

  const factory WorkType.original() = OriginalWork;
  const factory WorkType.translation(TranslationType type) = TranslatedWork;
  const factory WorkType.unknown() = UnknownWorkType;
}

/// Defines an original work
class OriginalWork extends WorkType {
  const OriginalWork();

  @override
  List<Object?> get props => [];
}

/// Defines a work that is translated from another
class TranslatedWork extends WorkType {
  /// Identifies the type of translation
  final TranslationType type;

  const TranslatedWork(this.type);

  const TranslatedWork.human() : this(TranslationType.human);
  const TranslatedWork.mtl() : this(TranslationType.mtl);
  const TranslatedWork.unknown() : this(TranslationType.unknown);

  @override
  List<Object?> get props => [type];
}

/// Defines a work that is unknown
class UnknownWorkType extends WorkType {
  const UnknownWorkType();

  @override
  List<Object?> get props => [];
}

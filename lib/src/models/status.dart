/// Defines the status of the novel
enum NovelStatus {
  /// The novel is being updated regularly
  ongoing,

  /// The updates have stopped until a certain
  /// (determinate or indeterminate) time.
  hiatus,

  /// The novel has been completed.
  completed,

  /// Parts of the novel has been removed by author.
  /// Most commonly due to third-party contracts.
  stub,

  /// The novel has been discontinued and further content
  /// is not expected.
  dropped,

  /// The novel status is unknown.
  unknown;

  /// Acquire the novel status from a suitable string.
  ///
  /// The [value] is trimmed and converted to lowercase
  /// then matched to strings listed below:
  ///
  /// - [NovelStatus.ongoing] : "ongoing"
  /// - [NovelStatus.hiatus] : "hiatus"
  /// - [NovelStatus.stub] : "stub"
  /// - [NovelStatus.completed] : "completed"
  ///
  /// If none of the above matches [NovelStatus.unknown]
  static NovelStatus parse(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'ongoing':
        return NovelStatus.ongoing;
      case 'hiatus':
        return NovelStatus.hiatus;
      case 'stub':
        return NovelStatus.stub;
      case 'completed':
        return NovelStatus.completed;
      case 'dropped':
      case 'discontinued':
        return NovelStatus.dropped;
      default:
        return NovelStatus.unknown;
    }
  }
}

class Chapter {
  int index;
  String title;
  String? content;
  String url;
  DateTime? updated;

  Chapter({
    required this.index,
    required this.title,
    required this.url,
    this.content,
    this.updated,
  });

  Chapter.withUrl(String url) : this(index: -1, title: '', url: url);
}

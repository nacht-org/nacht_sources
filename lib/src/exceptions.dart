class CrawlerException implements Exception {
  final String message;
  CrawlerException(this.message);
}

class PageException extends CrawlerException {
  PageException(String message) : super(message);
}

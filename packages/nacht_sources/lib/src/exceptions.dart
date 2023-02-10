class CrawlerException implements Exception {
  final String message;
  CrawlerException(this.message);
}

class PageException extends CrawlerException {
  PageException(super.message);
}

class FeatureException extends CrawlerException {
  FeatureException(super.message);
}

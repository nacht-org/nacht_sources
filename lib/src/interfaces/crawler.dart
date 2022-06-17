import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:nacht_sources/nacht_sources.dart';

abstract class Crawler {
  final Meta meta;
  late final Dio client;

  Crawler({
    required CrawlerOptions options,
    required this.meta,
  }) : client = options.client;

  /// Check whether the url is supported by this crawler
  ///
  /// The source implementations may override this method to provide
  /// custom matching functionality.
  bool of(String url) {
    return meta.of(url);
  }

  // -- client request helper methods --

  Future<Document> pullDoc(
    String url, {
    String method = 'GET',
    bool fragment = false,
  }) async {
    final response = await client.fetch<String>(
      RequestOptions(
        path: url,
        method: method,
        responseType: ResponseType.plain,
      ),
    );

    if (response.statusCode != 200) {
      throw CrawlerException(
        "Did not get a valid response: ${response.statusCode}: $url",
      );
    }

    return parser.parse(response.data);
  }
}

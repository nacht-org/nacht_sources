import 'package:chapturn_sources/src/exceptions.dart';
import 'package:chapturn_sources/src/models/meta.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

abstract class Crawler {
  final Meta meta;
  final Dio client;

  Crawler({
    required this.client,
    required this.meta,
  });

  static Dio defaultClient() {
    return Dio();
  }

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

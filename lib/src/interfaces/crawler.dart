import 'package:chapturn_sources/src/models/meta.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

abstract class Crawler {
  final Meta meta;
  http.Client client;

  Crawler({
    required this.client,
    required this.meta,
  });

  static http.Client defaultClient() {
    return http.Client();
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
    final uri = Uri.parse(url);
    final response = await client.send(http.Request(method, uri));

    if (response.statusCode != 200) {
      throw http.ClientException(
        "Did not get a valid response: ${response.statusCode}",
        uri,
      );
    }
    final content = await response.stream.bytesToString();
    return parser.parse(content);
  }
}

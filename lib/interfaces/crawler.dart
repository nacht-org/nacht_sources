import '../models/meta.dart';
import 'package:http/http.dart';

abstract class Crawler {
  final Meta meta;
  final Client client;

  Crawler({
    required this.client,
    required this.meta,
  });

  static Client defaultClient() {
    return Client();
  }

  /// Check whether the url is supported by this crawler
  ///
  /// The source implementations may override this method to provide
  /// custom matching functionality.
  bool of(String url) {
    return meta.of(url);
  }
}

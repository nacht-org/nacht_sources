import 'package:dio/dio.dart';

class CrawlerOptions {
  CrawlerOptions({
    required this.client,
  });

  CrawlerOptions.basic() : this(client: Dio());

  final Dio client;
}

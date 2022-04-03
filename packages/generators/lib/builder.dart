import 'package:build/build.dart';
import 'package:generators/src/crawler_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateCrawler(BuilderOptions options) =>
    SharedPartBuilder([CrawlerGenerator()], "crawler_generator");

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:annotations/annotations.dart';

import 'model_visitor.dart';

class CrawlerGenerator extends GeneratorForAnnotation<NovelCrawler> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final className = '_\$${visitor.className}';

    final classBuffer = StringBuffer();
    classBuffer.writeln('class $className extends NovelCrawler {');
    classBuffer.writeln(
        '$className.make() : super(client: Crawler.defaultClient(), meta: _meta);');
    classBuffer.writeln(
        '$className.makeWith(Dio client) : super(client: client, meta: _meta);');
    classBuffer.writeln('}');

    return classBuffer.toString();
  }
}

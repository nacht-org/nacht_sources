import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:nacht_sources/src/minify/extensions.dart';

class RemoveVisitor extends TreeVisitor {
  RemoveVisitor({
    required this.removeTags,
  });

  final Set<String> removeTags;

  @override
  void visitElement(Element node) {
    super.visitElement(node);
    if (removeTags.contains(node.localName)) {
      node.replaceWithChildren(safe: true);
    }
  }
}

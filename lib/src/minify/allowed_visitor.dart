import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';

import 'package:nacht_sources/src/minify/extensions.dart';

/// Removes disallowed nodes from the html tree.
///
/// These include comments, empty elements not in [allowedEmptyTags],
/// tags specified by [allowedTags] and
/// attributes specified by [allowedAttributes].
class AllowedVisitor extends TreeVisitor {
  AllowedVisitor({
    required this.allowedTags,
    required this.allowedAttributes,
  });

  /// Remove all tags except these specified
  final Set<String> allowedTags;

  /// Remove all attributes except these specified
  final Map<String, Set<String>> allowedAttributes;

  @override
  void visitComment(Comment node) {
    super.visitComment(node);
    node.remove();
  }

  @override
  void visitElement(Element node) {
    super.visitElement(node);

    if (isElementEmpty(node)) {
      node.remove();
    } else if (!allowedTags.contains(node.localName)) {
      node.replaceWithChildren(safe: true);
    } else {
      final keep = allowedAttributes[node.localName] ?? const {};
      node.keepAttributes(keep);
    }
  }

  /// The element is empty if all children are [Text] where [Node.text] is empty
  /// and node does not have any [allowedAttributes]
  bool isElementEmpty(Element element) {
    final textEmpty =
        element.nodes.every((node) => node.nodeType == Node.TEXT_NODE) &&
            element.text.trim().isEmpty;

    bool attributesEmpty = true;
    if (allowedAttributes.containsKey(element.localName)) {
      final allowedAttributeNames = allowedAttributes[element.localName]!;
      final containsAllowed = element.attributes.keys
          .any((key) => allowedAttributeNames.contains(key));
      attributesEmpty = !containsAllowed;
    }

    return textEmpty && attributesEmpty;
  }
}

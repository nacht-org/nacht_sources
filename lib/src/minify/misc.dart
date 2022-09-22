import 'package:html/dom.dart';

String normalize(String source) {
  return source.replaceAll('&nbsp;', '');
}

Node deepestRoot(Node node) {
  Node root = node;
  while (root.children.length == 1 && !hasTextChild(root)) {
    root = root.children.single;
  }

  return root;
}

bool hasTextChild(Node node) {
  return node.nodes
      .where(
        (element) =>
            element.nodeType == Node.TEXT_NODE &&
            (element as Text).text.trim().isNotEmpty,
      )
      .isNotEmpty;
}

/// Wraps all [Text] tags and all [Element] tags which is not a [baseTags]
/// with a new [wrapWith] node.
void ensureBaseTags(
  Node parent,
  String wrapWith,
  Set<String> baseTags,
) {
  final childNodes = parent.nodes.toList();
  for (var i = 0; i < childNodes.length; i++) {
    final node = childNodes[i];
    if (node.nodeType == Node.TEXT_NODE) {
      wrapNode(parent, i, node, wrapWith);
    } else if (node.nodeType == Node.ELEMENT_NODE) {
      if (!baseTags.contains((node as Element).localName)) {
        wrapNode(parent, i, node, wrapWith);
      }
    }
  }
}

/// Wrap [node] with new [wrapWith] node in [parent] at [index].
void wrapNode(Node parent, int index, Node node, String wrapWith) {
  final replacement = Element.tag(wrapWith);
  parent.nodes[index] = replacement;
  replacement.append(node);
}

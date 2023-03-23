import 'dart:collection';

import 'package:html/dom.dart';

extension NodeReplaceWithChildren on Node {
  /// Replace this node with its children preserving order.
  void replaceWithChildren({bool safe = false}) {
    // add child nodes to parent preserving order
    if (parentNode != null) {
      final index = parentNode!.nodes.indexOf(this);
      for (final childNode in nodes.toList()) {
        parentNode!.nodes.insert(index, childNode);
      }
    }

    // remove node itself
    if (parentNode != null || !safe) {
      remove();
    }
  }
}

extension ElementKeepAttributes on Element {
  void keepAttributes(Set<String> attributeNames) {
    if (attributeNames.isEmpty) {
      attributes.clear();
      return;
    }

    final keep = <Object, String>{};
    for (final name in attributeNames) {
      final value = attributes[name];
      if (value != null) {
        keep[name] = value;
      }
    }

    attributes = LinkedHashMap.from(keep);
  }
}

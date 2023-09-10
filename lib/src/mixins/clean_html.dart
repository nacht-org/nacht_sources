import 'package:html/dom.dart' as dom;
import 'package:nacht_sources/src/constants.dart' as constants;
import 'package:nacht_sources/src/misc/misc.dart';

/// A mixin that provides functionality to clean a html tree
mixin CleanHtml {
  /// List of names of tags that should be removed from
  /// chapter content for this specific crawler.
  List<String> get badTags {
    return constants.badTags;
  }

  /// List of names of tags that even if there is no
  /// text should not be removed from chapter content
  ///
  /// Elements with no text are usually removed from the chapter content,
  /// unless the element is specified in this list.
  List<String> get notextTags {
    return constants.notextTags;
  }

  /// Element attributes that contain meaningful content
  /// and should be kept with in the element during attribute cleanup.
  List<String> get preserveAttrs {
    return constants.preserveAttrs;
  }

  /// List of regex patterns denoting text that
  /// should be removed from chapter content.
  List<String> get blacklistPatterns {
    return constants.blacklistPatterns;
  }

  /// [RegExp] objects of [blacklistPatterns]
  ///
  /// Instantiating regex can be expensive, so this limits
  /// blacklist pattern instantation to once per crawler instance
  List<RegExp>? _cachedPatterns;

  /// [_cachedPatterns] should be accessed through this getter
  List<RegExp> get cachedPatterns {
    _cachedPatterns ??= blacklistPatterns.map((p) => RegExp(p)).toList();
    return _cachedPatterns!;
  }

  /// Whether the [input] is blacklisted
  bool isBlacklisted(String input) {
    for (final pattern in cachedPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  // Remove empty wrappers
  dom.Element findRoot(dom.Element element) {
    dom.Element root = element;
    while (root.children.length == 1 &&
        root.firstChild!.nodeType == dom.Node.ELEMENT_NODE &&
        (root.firstChild! as dom.Element).localName == 'div') {
      root = root.firstChild! as dom.Element;
    }

    return root;
  }

  /// Remove unnecessary elements and attributes
  dom.Node? cleanNodeTree(dom.Node? tree) {
    if (tree == null) {
      return tree;
    }

    tree.attributes.clear();

    final nodes = [tree];
    while (nodes.isNotEmpty) {
      final node = nodes.removeAt(0);
      nodes.addAll(node.children);
      cleanNode(node);
    }

    return tree;
  }

  /// If the [element] does not add any meaningful content the element
  /// is removed, this can happen on either of below conditions.
  ///
  /// - Element is a comment
  /// - Element is part of the bad tags (undesired tags that dont add content)
  /// - The element has no text, has no children and is not part of notext_tags
  ///   (elements that doesnt need text to be meaningful)
  /// - The text of the element matches one of the blacklisted patterns
  ///   (undesirable text such as ads and watermarks)
  ///
  /// If none of the conditions are met, all the attributes except those marked
  /// important [preserveAttrs] are removed from this element
  void cleanNode(dom.Node node) {
    if (node.nodeType == dom.Node.COMMENT_NODE) {
      node.remove();
      return;
    }

    if (node.nodeType != dom.Node.ELEMENT_NODE) {
      return;
    }
    final element = node as dom.Element;

    // bad tag
    if (badTags.contains(element.localName)) {
      node.remove();

      // empty text
    } else if (element.text.clean().isEmpty) {
      // if not a notext tag and has no content
      if (!notextTags.contains(element.localName) && !element.hasContent()) {
        element.remove();
      }

      // blacklisted
    } else if (isBlacklisted(element.text.trim())) {
      element.remove();
    } else {
      // remove useless tags
      element.attributes.removeWhere(
        (key, value) => !preserveAttrs.contains(key),
      );
    }
  }
}

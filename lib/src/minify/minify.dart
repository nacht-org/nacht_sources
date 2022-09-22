library minify;

import 'package:html/parser.dart';
import 'package:nacht_sources/src/minify/allowed_visitor.dart';
import 'package:nacht_sources/src/minify/constants.dart';
import 'package:nacht_sources/src/minify/misc.dart';
import 'package:nacht_sources/src/minify/remove_visitor.dart';

String minify(String source) {
  final document = parseFragment(source);
  final root = deepestRoot(document);

  final allowedVisitor = AllowedVisitor(
    allowedTags: kAllowedTags,
    allowedAttributes: kAllowedAttributes,
  );

  allowedVisitor.visit(root);
  ensureBaseTags(root, "p", kBaseTags);

  // Remove divs inside paragraphs.
  final removeVisitor = RemoveVisitor(removeTags: {"div"});
  for (final element in root.children) {
    removeVisitor.visitElement(element);
  }

  return root.children.map((element) => element.outerHtml).join("\u2561");
}

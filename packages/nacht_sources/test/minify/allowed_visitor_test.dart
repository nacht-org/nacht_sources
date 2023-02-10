import 'package:html/parser.dart';
import 'package:nacht_sources/src/minify/allowed_visitor.dart';
import 'package:test/test.dart';

void main() {
  group("AllowedVisitor", () {
    test("should remove comments", () {
      final doc = parseFragment("<!-- comment -->");
      final visitor = AllowedVisitor(
        allowedTags: {},
        allowedAttributes: {},
      );

      visitor.visit(doc);
      expect(doc.outerHtml, "");
    });

    test("should remove unallowed tags by replacing with children", () {
      final doc = parseFragment(
          "<div><p><strong>strong</strong></p><div><b>div</b></div></div>");
      final visitor = AllowedVisitor(
        allowedTags: {"div", "strong"},
        allowedAttributes: {},
      );

      visitor.visit(doc);
      expect(doc.outerHtml, "<div><strong>strong</strong><div>div</div></div>");
    });
  });

  test("should remove unallowed attributes", () {
    final doc = parseFragment("<div><img src='#' /></div>");
    final visitor = AllowedVisitor(
      allowedTags: {"img"},
      allowedAttributes: {
        "img": {"src"}
      },
    );

    visitor.visit(doc);
    expect(doc.outerHtml, '<img src="#">');
  });
}

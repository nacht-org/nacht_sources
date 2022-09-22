import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:nacht_sources/src/minify/misc.dart';
import 'package:test/test.dart';

void main() {
  group("deepestRoot", () {
    test("should find the deepest root node", () {
      final document = parseFragment("<div><div><div>root</div></div></div>");
      final root = deepestRoot(document);

      expect(root, isA<Element>());
      expect((root as Element).outerHtml, "<div>root</div>");
    });

    test("should halt if found more than one child", () {
      final document = parseFragment(
        "<div><div><span></span><div>false root</div></div></div>",
      );
      final root = deepestRoot(document);

      expect(root, isA<Element>());
      expect(
        (root as Element).outerHtml,
        "<div><span></span><div>false root</div></div>",
      );
    });

    test("should halt if found adjacent text", () {
      final document =
          parseFragment("<div><div><span></span>false root</div></div>");
      final root = deepestRoot(document);

      expect(root, isA<Element>());
      expect((root as Element).outerHtml, "<div><span></span>false root</div>");
    });
  });

  group("ensureBaseTags", () {
    test("should add wrapper when base is text", () {
      final document = parseFragment("<div>First line</div>");
      ensureBaseTags(document.children.single, 'p', {});

      expect(document.outerHtml, "<div><p>First line</p></div>");
    });

    test("should add wrapper when base is valid", () {
      final document = parseFragment("<div><span>First line</span></div>");
      ensureBaseTags(document.children.single, 'p', {});

      expect(document.outerHtml, "<div><p><span>First line</span></p></div>");
    });

    test("should not add wrapper when base is valid", () {
      final document = parseFragment("<div><span>First line</span></div>");
      ensureBaseTags(document.children.single, 'p', {"span"});

      expect(document.outerHtml, "<div><span>First line</span></div>");
    });

    test("should add wrapper for all child nodes", () {
      final document =
          parseFragment("<div><span>First line</span>Second line</div>");
      ensureBaseTags(document.children.single, 'p', {});

      expect(
        document.outerHtml,
        "<div><p><span>First line</span></p><p>Second line</p></div>",
      );
    });
  });
}

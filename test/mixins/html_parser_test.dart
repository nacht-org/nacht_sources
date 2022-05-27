import 'package:nacht_sources/src/mixins/html_parser.dart';
import 'package:html/parser.dart' as p;
import 'package:test/test.dart';

class Parser with HtmlParser {}

void main() {
  group("HtmlParsing", () {
    final parser = Parser();

    test("should remove root attributes", () {
      const html = '<div style="height: 2rem;">lorem ipsum</div>';
      const expected = '<div>lorem ipsum</div>';

      final doc = p.parseFragment(html);

      parser.cleanNodeTree(doc);

      expect(doc.outerHtml, expected);
    });

    test("should remove nested element attributes", () {
      const html =
          '<div style="height: 2rem;">lorem ipsum<span class="text">urom</span></div>';
      const expected = '<div>lorem ipsum<span>urom</span></div>';

      final doc = p.parseFragment(html);

      parser.cleanNodeTree(doc);

      expect(doc.outerHtml, expected);
    });
  });
}

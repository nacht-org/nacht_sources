import 'package:html/dom.dart';

extension DocumentSelect on Document {
  Element? select(String selector) => querySelector(selector);
  List<Element> selectAll(String selector) => querySelectorAll(selector);
}

extension DocumentSelectText on Document {
  String? selectText(String selector) => querySelector(selector)?.text.trim();
  List<String> selectAllText(String selector) => querySelectorAll(selector)
      .map((element) => element.text.trim())
      .where((text) => text.isNotEmpty)
      .toList();
}

extension DocumentFragmentSelect on DocumentFragment {
  Element? select(String selector) => querySelector(selector);
  List<Element> selectAll(String selector) => querySelectorAll(selector);
}

extension DocumentFragmentSelectText on DocumentFragment {
  String? selectText(String selector) => querySelector(selector)?.text.trim();
  List<String> selectAllText(String selector) => querySelectorAll(selector)
      .map((element) => element.text.trim())
      .where((text) => text.isNotEmpty)
      .toList();
}

extension ElementSelect on Element {
  Element? select(String selector) => querySelector(selector);
  List<Element> selectAll(String selector) => querySelectorAll(selector);
}

extension ElementSelectText on Element {
  String? selectText(String selector) => querySelector(selector)?.text.trim();
  List<String> selectAllText(String selector) => querySelectorAll(selector)
      .map((element) => element.text.trim())
      .where((text) => text.isNotEmpty)
      .toList();
}

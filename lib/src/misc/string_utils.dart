extension StringExtension on String {
  String stripRight(String pattern) {
    if (endsWith(pattern)) {
      return substring(0, length - pattern.length);
    } else {
      return this;
    }
  }

  String clean() {
    return replaceAll(" ", " ").trim();
  }
}

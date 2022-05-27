import 'package:nacht_sources/src/constants.dart' show dublinCore;

enum Namespace {
  dc,
  opf,
}

class MetaData {
  String name;
  String value;
  late Namespace namespace;
  Map<String, String> others;

  MetaData(this.name, this.value, [this.others = const {}]) {
    namespace = dublinCore.contains(name) ? Namespace.dc : Namespace.opf;
  }
}

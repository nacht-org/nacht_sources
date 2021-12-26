import '../constants.dart';

enum Namespace {
  DC,
  OPF,
}

class MetaData {
  String name;
  String value;
  late Namespace namespace;
  Map<String, String> others;

  MetaData(this.name, this.value, [this.others = const {}]) {
    namespace = dublinCore.contains(name) ? Namespace.DC : Namespace.OPF;
  }
}

library chapturn_sources;

import 'package:chapturn_sources/impls/scribblehub.dart';
import 'package:chapturn_sources/interfaces/crawler.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import './impls/impls.dart';
import './models/models.dart';

List<Tuple3<Meta Function(), Crawler Function(), Crawler Function(Client)>>
    sources = [
  Tuple3(ScribbleHub.constMeta, ScribbleHub.make, ScribbleHub.makeWith)
];

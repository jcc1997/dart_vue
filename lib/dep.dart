import 'package:dart_vue/effect.dart';

typedef Dep = Set<ReactiveEffect>;

Dep createDep([List<ReactiveEffect>? effects]) {
  Dep dep = {};
  dep.addAll(effects ?? []);
  return dep;
}

import 'package:dart_vue/effect.dart';

import 'ref.dart';
import 'dep.dart';

void noop(dynamic val) {}

class ComputedRefImpl<T> implements Ref<T> {
  T? _value;
  @override
  Dep? dep;
  ReactiveEffect? _effect;
  var _dirty = false;
  bool isReadOnly;

  final T Function() getter;
  final void Function(T newVal) _setter;

  ComputedRefImpl({required this.getter, void Function(T newVal)? setter})
      : _setter = setter ?? noop,
        isReadOnly = setter == null {
    _effect = ReactiveEffect(() {
      if (!_dirty) {
        _dirty = true;
        triggerRefValue(this);
      }
    });
    _effect!.computed = this;
  }

  @override
  get value {
    trackRefValue(this);
    if (_dirty) {
      _dirty = false;
      _value = _effect!.run();
    }
    return _value!;
  }

  @override
  set value(newVal) {
    _setter(newVal);
  }
}

import 'dep.dart';
import 'effect.dart';

class RefImpl<T> implements Ref<T> {
  T _value;
  @override
  Dep? dep;

  RefImpl(this._value);

  @override
  get value {
    trackRefValue(this);
    return this._value;
  }

  @override
  set value(newVal) {
    if (newVal != _value) {
      _value = newVal;
      triggerRefValue(this, newVal);
    }
  }
}

abstract class Ref<T> {
  Dep? dep;
  T value;
  Ref(this.value);
}

void trackRefValue(Ref<dynamic> ref) {
  if (shouldTrack && activeEffect != null) {
    ref.dep ??= createDep();
    trackEffects(ref.dep!);
  }
}

void triggerRefValue(Ref<dynamic> ref, [dynamic newVal]) {
  if (ref.dep != null) {
    triggerEffects(ref.dep!);
  }
}

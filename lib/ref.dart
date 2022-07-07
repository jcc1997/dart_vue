import 'dep.dart';
import 'effect.dart';

class RefComputedImpl {}

class RefImp<T> implements RefBase {
  T _value;
  Dep? dep;

  RefImp(this._value);

  get value {
    trackRefValue(this);
    return this._value;
  }

  set value(newVal) {
    if (newVal != _value) {
      _value = newVal;
      triggerRefValue(this, newVal);
    }
  }
}

abstract class RefBase<T> {
  Dep? dep;
  T value;
  RefBase(this.value);
}

void trackRefValue(RefBase<dynamic> ref) {
  if (shouldTrack && activeEffect != null) {
    ref.dep ??= createDep();
    trackEffects(ref.dep!);
  }
}

void triggerRefValue(RefBase<dynamic> ref, [dynamic newVal]) {
  if (ref.dep != null) {
    triggerEffects(ref.dep!);
  }
}

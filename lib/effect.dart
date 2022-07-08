import 'effect_scope.dart';
import 'dep.dart';
import 'ref.dart';
import 'computed.dart';

ReactiveEffect? activeEffect;

class ReactiveEffect<T> {
  var active = true;
  final List<Dep> deps = [];
  ReactiveEffect? parent;
  final T Function() fn;
  final EffectScheduler? scheduler;
  var deferStop = false;
  ComputedRefImpl? computed;

  ReactiveEffect(this.fn, [this.scheduler, EffectScope? scope]) {
    recordEffectScope(this, scope);
  }

  run() {
    if (!active) {
      return fn();
    }
    var parent = activeEffect;
    var lastShouldTrack = shouldTrack;
    while (parent != null) {
      if (parent == this) return;
      parent = parent.parent;
    }
    try {
      this.parent = activeEffect;
      activeEffect = this;
      shouldTrack = true;

      cleanupEffect(this);
      return this.fn();
    } finally {
      activeEffect = this.parent;
      shouldTrack = lastShouldTrack;
      this.parent = null;
      if (deferStop) {
        stop();
      }
    }
  }

  stop() {
    // stopped while running itself - defer the cleanup
    if (activeEffect == this) {
      deferStop = true;
    } else if (active) {
      cleanupEffect(this);
      active = false;
    }
  }
}

typedef EffectScheduler = Function;

void cleanupEffect(ReactiveEffect effect) {
  var deps = effect.deps;
  if (deps.isNotEmpty) {
    for (var i = 0; i < deps.length; i++) {
      deps[i].remove(effect);
    }
    deps.clear();
  }
}

var shouldTrack = true;
final List<bool> trackStack = [];

void pauseTracking() {
  trackStack.add(shouldTrack);
  shouldTrack = false;
}

void enableTracking() {
  trackStack.add(shouldTrack);
  shouldTrack = true;
}

void resetTracking() {
  shouldTrack = trackStack.removeLast();
}

// var effectTrackDepth = 0;
// var trackOpBit = 1;
// /// The bitwise track markers support at most 30 levels of recursion.
// /// This value is chosen to enable modern JS engines to use a SMI on all platforms.
// /// When recursion depth is greater, fall back to using a full cleanup.
// const maxMarkerBits = 30;

void trackEffects(Dep dep) {
  var shouldTrack = dep.lookup(activeEffect!) == null;

  if (shouldTrack) {
    dep.add(activeEffect!);
    activeEffect!.deps.add(dep);
  }
}

void triggerEffects(Dep dep) {
  var effects = Set.from(dep);
  // spread into array for stabilization
  for (var effect in effects) {
    if (effect.computed != null) {
      triggerEffect(effect);
    }
  }
  for (var effect in effects) {
    if (effect.computed == null) {
      triggerEffect(effect);
    }
  }
}

void triggerEffect(ReactiveEffect effect) {
  if (effect != activeEffect) {
    effect.run();
  }
}

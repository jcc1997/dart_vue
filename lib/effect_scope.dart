import 'effect.dart';

EffectScope? activeEffectScope;

class EffectScope {
  var active = true;
  final List<ReactiveEffect<dynamic>> effects = [];
  final List<void Function()> cleanups = [];

  /// only assigned by undetached scope
  EffectScope? parent;

  /// record undetached scopes
  List<EffectScope>? scopes;

  /// track a child scope's index in its parent's scopes array for optimized
  /// removal
  int? index;

  EffectScope({bool detached = false}) {
    var currentEffectScope = activeEffectScope;
    if (!detached && currentEffectScope != null) {
      parent = currentEffectScope;
      currentEffectScope.scopes ??= [];
      currentEffectScope.scopes!.add(this);
      index = currentEffectScope.scopes!.length - 1;
    }
  }

  T? run<T>(T Function() fn) {
    if (active) {
      var currentEffectScope = activeEffectScope;
      try {
        activeEffectScope = this;
        return fn();
      } finally {
        activeEffectScope = currentEffectScope;
      }
    }
    return null;
  }

  /// This should only be called on non-detached scopes
  on() => activeEffectScope = this;

  /// This should only be called on non-detached scopes
  off() => activeEffectScope = parent;

  stop(bool? fromParent) {
    if (active) {
      var l = effects.length;
      for (var i = 0; i < l; i++) {
        effects[i].stop();
      }
      l = cleanups.length;
      for (var i = 0; i < l; i++) {
        cleanups[i]();
      }
      if (scopes != null) {
        l = scopes!.length;
        for (var i = 0; i < l; i++) {
          scopes![i].stop(true);
        }
      }
      // nested scope, dereference from parent to avoid memory leaks
      if (parent != null && fromParent != true) {
        // optimized O(1) removal
        if (parent!.scopes!.isNotEmpty) {
          var last = parent!.scopes!.removeLast();
          if (last != this) {
            parent!.scopes![this.index!] = last;
            last.index = this.index!;
          }
        }
      }
      this.active = false;
    }
  }
}

EffectScope effectScope([bool detached = false]) {
  return EffectScope(detached: detached);
}

void recordEffectScope(ReactiveEffect effect, EffectScope? scope) {
  scope ??= activeEffectScope;
  if (scope != null && scope.active) {
    scope.effects.add(effect);
  }
}

EffectScope? getCurrentScope() {
  return activeEffectScope;
}

void onScopeDispose(void Function() fn) {
  var currentEffectScope = activeEffectScope;
  if (currentEffectScope != null) {
    currentEffectScope.cleanups.add(fn);
  }
}

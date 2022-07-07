# dart_vue

This is trying to build vue-like reactive system in Dart and finally use in Flutter.

Flutter has [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) and [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) which in my opinion, is similar to reactive system built by vue.

Inspired by [`reactivue`](https://github.com/antfu/reactivue), this package built [`@vue/reactivity`](https://github.com/vuejs/core/tree/main/packages/reactivity) in Dart and use it into Flutter.

## [WIP]Features

### [WIP]ref

- [x] ref
- [ ] shallowRef
- [ ] isRef
- [ ] toRef
- [ ] toRefs
- [ ] unref
- [ ] proxyRefs
- [ ] customRef
- [ ] triggerRef

### [WIP]reactive

- [ ] reactive
- [ ] readonly
- [ ] isReactive
- [ ] isReadonly
- [ ] isShallow
- [ ] isProxy
- [ ] shallowReactive
- [ ] shallowReadonly
- [ ] markRaw
- [ ] toRaw

### [WIP]computed

- [ ] computed

### [WIP]effect

- [ ] effect
- [ ] stop
- [ ] trigger
- [ ] track
- [ ] enableTracking
- [ ] pauseTracking
- [ ] resetTracking

### [WIP]effectScope

- [x] effectScope,
- [x] getCurrentScope,
- [x] onScopeDispose

### [WIP]widget

- [x] DartVueWidget

## Getting started

just get this package.

## Usage

see `/example` folder.

```dart
import 'package:flutter/material.dart';
import 'package:dart_vue/dart_vue.dart';

class CounterState {
  int ref;
  CounterState({required this.ref});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RefImp<int> _counter = RefImp(0);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AnimatedBuilder example')),
        body: CounterBody(counterRef: _counter),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _counter.value++;
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterBody extends StatelessWidget {
  const CounterBody({Key? key, required this.counterRef}) : super(key: key);

  final RefImp<int> counterRef;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Current counter value:'),
          DartVueWidget<CounterState>(setup: () {
            return CounterState(ref: counterRef.value);
          }, render: (ctx, state, child) {
            return Text('${state.ref}');
          })
        ],
      ),
    );
  }
}
```

## Additional information

I am a noob in Dart, so welcome PR.

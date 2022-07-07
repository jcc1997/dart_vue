<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

try build `@vue/reactivity` in Dart.

### ref

- [x] ref
- [ ] shallowRef
- [ ] isRef
- [ ] toRef
- [ ] toRefs
- [ ] unref
- [ ] proxyRefs
- [ ] customRef
- [ ] triggerRef

### reactive

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

### computed

- [ ] computed

### effect

- [ ] effect
- [ ] stop
- [ ] trigger
- [ ] track
- [ ] enableTracking
- [ ] pauseTracking
- [ ] resetTracking

### effectScope

- [x] effectScope,
- [x] getCurrentScope,
- [x] onScopeDispose

### Widget

inspired by [reactivue](https://github.com/antfu/reactivue)

- [ ] DartVueWidget

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

no

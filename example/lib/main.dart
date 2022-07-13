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
  final Ref<int> _counter = RefImpl(0);

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

  final Ref<int> counterRef;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Current counter value:'),
          // DartVueComponent<CounterState>(setup: () {
          //   return CounterState(ref: counterRef.value);
          // }, render: (ctx, state, child) {
          //   return Text('${state.ref}');
          // })
          CounterWidget(
            counterRef: counterRef,
          )
        ],
      ),
    );
  }
}

class CounterWidget extends DartVueWidget<CounterState> {
  const CounterWidget({Key? key, required this.counterRef}) : super(key: key);

  final Ref<int> counterRef;

  @override
  CounterState setup() {
    return CounterState(ref: counterRef.value);
  }

  @override
  Widget render(BuildContext context, CounterState state, Widget? child) {
    return Text('${state.ref}');
  }
}

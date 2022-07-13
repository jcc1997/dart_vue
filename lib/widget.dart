import 'package:flutter/widgets.dart';
import 'dart_vue.dart';

abstract class DartVueWidget<T> extends StatefulWidget {
  final Widget? child;
  const DartVueWidget({super.key, this.child});

  T setup();
  Widget render(BuildContext context, T state, Widget? child);

  @override
  State<DartVueWidget<T>> createState() => _DartVueState<T>();
}

class DartVueComponent<T> extends DartVueWidget<T> {
  final T Function() _setup;
  @override
  T setup() {
    return this._setup();
  }

  final Widget Function(BuildContext context, T state, Widget? child) _render;
  @override
  Widget render(BuildContext context, T state, Widget? child) {
    return _render(context, state, child);
  }

  const DartVueComponent({super.key, required setup, required render})
      : _setup = setup,
        _render = render;

  @override
  State<DartVueWidget<T>> createState() => _DartVueState<T>();
}

class _DartVueState<T> extends State<DartVueWidget<T>> {
  T? _state;
  ReactiveEffect? _effect;

  @override
  void initState() {
    super.initState();
    var effect = ReactiveEffect(() {
      _state = widget.setup();
      setState(() {
        // it changed already.
      });
    });
    effect.run();
    _effect = effect;
  }

  @override
  Widget build(BuildContext context) =>
      widget.render(context, _state!, widget.child);

  @override
  void dispose() {
    super.dispose();
    _effect!.stop();
  }
}

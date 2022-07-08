import 'package:flutter/widgets.dart';
import 'dart_vue.dart';

abstract class DartVueWidget<T> extends StatefulWidget {
  final Widget? child;
  abstract final T Function() setup;
  abstract final Widget Function(BuildContext context, T state, Widget? child)
      render;

  const DartVueWidget({super.key, this.child});

  @override
  State<DartVueWidget<T>> createState() => _DartVueState<T>();
}

class DartVueComponent<T> extends DartVueWidget<T> {
  @override
  final T Function() setup;
  @override
  final Widget Function(BuildContext context, T state, Widget? child) render;

  const DartVueComponent(
      {super.key, required this.setup, required this.render});

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

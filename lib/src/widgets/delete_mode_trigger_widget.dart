import 'package:flutter/widgets.dart';

class DeleteModeTriggerWidget extends StatefulWidget {
  const DeleteModeTriggerWidget({
    Key? key,
    required this.child,
    required this.onTrigger,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTrigger;

  @override
  _DeleteModeTriggerWidgetState createState() =>
      _DeleteModeTriggerWidgetState();
}

class _DeleteModeTriggerWidgetState extends State<DeleteModeTriggerWidget> {
  bool _isPointerUp = true;

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (event) {
          _isPointerUp = false;
          Future.delayed(const Duration(milliseconds: 700), () {
            if (!_isPointerUp) widget.onTrigger();
          });
        },
        onPointerUp: (_) => _isPointerUp = true,
        child: widget.child);
  }
}

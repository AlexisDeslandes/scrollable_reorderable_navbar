import 'package:flutter/widgets.dart';

class DeleteModeItemListener extends StatefulWidget {
  const DeleteModeItemListener(
      {Key? key, required this.child, required this.deleteModeCallback})
      : super(key: key);

  final Widget child;
  final VoidCallback deleteModeCallback;

  @override
  _DeleteModeItemListenerState createState() => _DeleteModeItemListenerState();
}

class _DeleteModeItemListenerState extends State<DeleteModeItemListener> {
  bool _isPointerUp = true;

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (event) {
          _isPointerUp = false;
          Future.delayed(const Duration(milliseconds: 700), () {
            if (!_isPointerUp) widget.deleteModeCallback();
          });
        },
        onPointerUp: (_) => _isPointerUp = true,
        child: widget.child);
  }
}

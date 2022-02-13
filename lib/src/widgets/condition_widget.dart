import 'package:flutter/cupertino.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

///
/// Widget used to avoid the practice of using if/else
/// in screen files of the app. Better readability.
///
class ConditionWidget extends StatelessWidget {
  final bool appear;
  final BuildWidget appearWidgetCallback;
  final BuildWidget replaceWidgetCallback;

  const ConditionWidget(
      {Key? key,
      required this.appear,
      required this.appearWidgetCallback,
      this.replaceWidgetCallback = _emptyCallback})
      : super(key: key);

  static Widget _emptyCallback() => const SizedBox();

  @override
  Widget build(BuildContext context) {
    if (appear) {
      return appearWidgetCallback();
    }
    return replaceWidgetCallback();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

import '../../helpers/helpers.dart';

void main() {
  group("DeleteModeTriggerWidget", () {
    testWidgets("onTrigger should be called after 700ms of pressing",
        (tester) async {
      final onTrigger = FunctionMock<void>(), key = UniqueKey();
      await tester.pumpWidget(DeleteModeTriggerWidget(
        child: Container(key: key, width: 10, height: 10, color: Colors.red),
        onTrigger: onTrigger,
      ));
      await tester.pumpAndSettle();
      final location = tester.getCenter(find.byKey(key));
      final TestGesture gesture = await tester.startGesture(location);
      await tester.pump(const Duration(milliseconds: 701));
      await gesture.up();
      await tester.pumpAndSettle();
      verify(onTrigger);
      addTearDown(gesture.removePointer);
    });
  });
}

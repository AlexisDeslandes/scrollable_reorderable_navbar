import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

import '../../helpers/helpers.dart';

void main() {
  group("ReorderableItem", () {
    testWidgets("Tap on item should trigger onTap event", (tester) async {
      final onTap = FunctionMock<void>();
      await tester.pumpApp(ReorderableItem(
          index: 0,
          item: NavBarItem(widget: Container(), name: "Item 1"),
          onTap: onTap,
          animationDuration: Duration.zero));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ReorderableItem));
      verify(onTap);
    });
  });
}

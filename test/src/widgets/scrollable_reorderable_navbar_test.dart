import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';
import '../../helpers/helpers.dart';

void main() {
  group("ScrollableReorderableNavBar", () {
    testWidgets("onItemTap should be triggered after a ReorderableItem tapped.",
        (tester) async {
      final onItemTap = ValueChangedMock<int>();
      await tester.pumpApp(ScrollableReorderableNavBar(
          items: [
            NavBarItem(
                widget: Container(
                  color: Colors.red,
                  width: 10,
                  height: 10,
                ),
                name: "Item")
          ],
          onItemTap: onItemTap,
          onReorder: (a, b) {},
          selectedIndex: 0,
          onDelete: (index) {},
          deleteIndicationWidget: const SizedBox()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey("_ReorderableItemItem")));
      await tester.pump(const Duration(milliseconds: 800));
      verify(() => onItemTap(0));
    });

    testWidgets(
        "Long press on an item should display the deleteIndicationWidget, tap on with should dismiss it.",
        (tester) async {
      final onItemTap = ValueChangedMock<int>();
      await tester.pumpApp(ScrollableReorderableNavBar(
          items: [
            NavBarItem(
                widget: Container(
                  color: Colors.red,
                  width: 10,
                  height: 10,
                ),
                name: "Item")
          ],
          onItemTap: onItemTap,
          onReorder: (a, b) {},
          selectedIndex: 0,
          onDelete: (index) {},
          deleteIndicationWidget: const Text("Delete mode")));
      await tester.pumpAndSettle();
      final location =
          tester.getCenter(find.byKey(const ValueKey("_ReorderableItemItem")));
      final TestGesture gesture = await tester.startGesture(location);
      await tester.pump(const Duration(milliseconds: 701));
      await gesture.up();
      final deleteWidgetFinder = find.text("Delete mode");
      expect(deleteWidgetFinder, findsOneWidget);
      await tester.tap(deleteWidgetFinder);
      await tester.pumpAndSettle();
      expect(deleteWidgetFinder, findsNothing);
      addTearDown(gesture.removePointer);
    });
  });
}

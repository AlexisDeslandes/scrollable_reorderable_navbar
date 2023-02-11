import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

import '../../helpers/helpers.dart';

void main() {
  group("ScrollableReorderableNavBar", () {
    final item = NavBarItem(
      widget: Container(
        color: Colors.red,
        width: 10,
        height: 10,
      ),
      name: "Item",
    );
    final onItemTap = ValueChangedMock<int>();

    testWidgets("onItemTap should be triggered after a ReorderableItem tapped.",
        (tester) async {
      await tester.pumpApp(ScrollableReorderableNavBar(
          items: [item],
          onItemTap: onItemTap,
          onReorder: (a, b) {},
          selectedIndex: 0,
          onDelete: (index) {},
          deleteIndicationWidget: const SizedBox()));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey("_NavBarDeletableWidgetItem")));
      await tester.pump(const Duration(milliseconds: 800));
      verify(() => onItemTap(0));
    });

    group('Delete feature', () {
      const deleteIndicationWidget = Text("Delete mode");

      Future<TestGesture> triggerDeleteMode(WidgetTester tester) async {
        final location = tester.getCenter(
            find.byKey(const ValueKey("_NavBarDeletableWidgetItem")));
        final TestGesture gesture = await tester.startGesture(location);
        await tester.pump(const Duration(milliseconds: 701));
        await gesture.up();
        return gesture;
      }

      testWidgets(
          "When onDelete is given, "
          "Long press on an item should display the deleteIndicationWidget, "
          "tap on with should dismiss it.", (tester) async {
        await tester.pumpApp(ScrollableReorderableNavBar(
          items: [item],
          onItemTap: onItemTap,
          onReorder: (a, b) {},
          selectedIndex: 0,
          onDelete: (index) {},
          deleteIndicationWidget: deleteIndicationWidget,
        ));
        await tester.pumpAndSettle();
        final gesture = await triggerDeleteMode(tester);
        final deleteWidgetFinder = find.text("Delete mode");
        expect(deleteWidgetFinder, findsOneWidget);
        await tester.tap(deleteWidgetFinder);
        await tester.pumpAndSettle();
        expect(deleteWidgetFinder, findsNothing);
        addTearDown(gesture.removePointer);
      });

      testWidgets(
          "When onDelete is not given, "
          "Long press on an item should not display the deleteIndicationWidget.",
          (tester) async {
        await tester.pumpApp(ScrollableReorderableNavBar(
          items: [item],
          onItemTap: onItemTap,
          onReorder: (a, b) {},
          selectedIndex: 0,
          deleteIndicationWidget: deleteIndicationWidget,
        ));
        await tester.pumpAndSettle();
        final gesture = await triggerDeleteMode(tester);
        final deleteWidgetFinder = find.text("Delete mode");
        expect(deleteWidgetFinder, findsNothing);
        addTearDown(gesture.removePointer);
      });
    });

    testWidgets(
        'When onReorder is not given, it should render a ListView. '
        'Not a ReorderableListView.', (tester) async {
      await tester.pumpApp(ScrollableReorderableNavBar(
        items: [item],
        onItemTap: onItemTap,
        selectedIndex: 0,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ReorderableListView), findsNothing);
    });
  });
}

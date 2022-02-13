import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

void main() {
  group("ConditionWidget", () {
    testWidgets("appear should change the displayed widget.", (tester) async {
      final container = Container(), text = const Text("Text");
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: ConditionWidget(
          appear: true,
          appearWidgetCallback: () => text,
          replaceWidgetCallback: () => container,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: ConditionWidget(
          appear: false,
          appearWidgetCallback: () => text,
          replaceWidgetCallback: () => container,
        ),
      ));
      expect(find.byType(Container), findsOneWidget);
    });
  });
}

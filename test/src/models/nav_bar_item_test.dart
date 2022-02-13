import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

void main() {
  group("NavBarItem", () {
    test(
        "2 NavBarItem should be equals when they have the same name and Widget.",
        () {
      final widget = Container();
      final item1 = NavBarItem(widget: widget, name: "item1");
      final item2 = NavBarItem(widget: widget, name: "item2");
      expect(item1 == item2, false);
      final itemEqual1 = NavBarItem(widget: widget, name: "item1");
      expect(item1, itemEqual1);
    });
  });
}

import 'package:flutter/widgets.dart';

///
/// [NavBarItem] let user precise which widget and name he
/// wants to define to access navigation.
///
class NavBarItem {
  const NavBarItem({required this.widget, required this.name});

  final Widget widget;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is NavBarItem && widget == other.widget && name == other.name;

  @override
  int get hashCode => Object.hash(widget, name);
}

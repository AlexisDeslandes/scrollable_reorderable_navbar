import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_reorderable_navbar/scrollable_reorderable_navbar.dart';

///
/// [ScrollableReorderableNavBar] is a [Widget] that let user picks
/// a [NavBarItem] and access to the matching navigation.
/// When there are more than 5 items, the navbar can be scrolled left and right.
/// It also let user swipe position of items and delete items from the navbar.
///
class ScrollableReorderableNavBar extends StatelessWidget {
  const ScrollableReorderableNavBar(
      {Key? key,
      required this.items,
      required this.onItemTap,
      required this.onReorder,
      required this.selectedIndex,
      required this.onDelete,
      required this.deleteIndicationWidget,
      this.backgroundColor = Colors.white,
      this.duration = const Duration(milliseconds: 300),
      this.proxyDecorator,
      this.decoration})
      : super(key: key);

  /// Every items should have different names
  final List<NavBarItem> items;

  /// The index of the selected [NavBarItem]
  final int selectedIndex;

  /// Which behaviour should have after the user tap on a [NavBarItem]
  final ValueChanged<int> onItemTap;

  /// Which behaviour should have after user swap 2 [NavBarItem]
  final ReorderCallback onReorder;

  /// The [Widget] displayed on top of the delete overlay
  /// to show user that he can tap on [NavBarItem] to delete them
  final Widget deleteIndicationWidget;

  /// Which behaviour should have after user delete a [NavBarItem]
  final ValueChanged<int> onDelete;

  /// How the widget should look like on a reorder operation
  final ReorderItemProxyDecorator? proxyDecorator;

  /// Background color of the navbar
  final Color backgroundColor;

  /// Duration of the animations
  final Duration duration;

  /// Decoration of the entire navbar. You should use either [backgroundColor] or this one
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: decoration ??
            BoxDecoration(boxShadow: const [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
            ], color: backgroundColor),
        width: MediaQuery.of(context).size.width,
        height: kBottomNavigationBarHeight +
            MediaQuery.of(context).viewPadding.bottom,
        child: _ScrollableReorderableNavBar(
          selectedIndex: selectedIndex,
          items: items,
          backgroundColor: backgroundColor,
          onItemTap: onItemTap,
          animationDuration: duration,
          onReorder: onReorder,
          proxyDecorator: proxyDecorator,
          onDelete: onDelete,
          deleteIndicationWidget: deleteIndicationWidget,
        ));
  }
}

class _ScrollableReorderableNavBar extends StatefulWidget {
  const _ScrollableReorderableNavBar({
    Key? key,
    required this.onItemTap,
    required this.onDelete,
    required this.onReorder,
    required this.animationDuration,
    required this.selectedIndex,
    required this.deleteIndicationWidget,
    this.items = const [],
    this.backgroundColor,
    this.proxyDecorator,
  }) : super(key: key);

  final int selectedIndex;
  final List<NavBarItem> items;
  final Color? backgroundColor;
  final ValueChanged<int> onItemTap;
  final ValueChanged<int> onDelete;
  final ReorderCallback onReorder;
  final Duration animationDuration;
  final ReorderItemProxyDecorator? proxyDecorator;
  final Widget deleteIndicationWidget;

  @override
  _ScrollableReorderableNavBarState createState() =>
      _ScrollableReorderableNavBarState();
}

class _ScrollableReorderableNavBarState
    extends State<_ScrollableReorderableNavBar> {
  static const int _maxItemDisplayed = 5;
  late final ScrollController _controller = ScrollController();
  late final double _width = MediaQuery.of(context).size.width;

  late List<NavBarItem> _items = widget.items;
  late double _cellSize = _width / min(_maxItemDisplayed, _items.length);
  bool _deleteMode = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ScrollableReorderableNavBar oldWidget) {
    _items = widget.items;
    _cellSize = _width / min(_maxItemDisplayed, _items.length);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        scrollController: _controller,
        proxyDecorator: widget.proxyDecorator ??
            (child, index, animation) => ScaleTransition(
                scale: animation.drive(Tween(begin: 1.0, end: 1.5)),
                child: child),
        itemCount: _items.length,
        onReorder: widget.onReorder,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final shouldAddMargin =
                  index == 0 && _items.length > _maxItemDisplayed,
              margin =
                  EdgeInsets.only(left: shouldAddMargin ? _cellSize / 2 : 0),
              item = _items[index];
          return _ReorderableItemWrapper(
              key: ValueKey("_ReorderableItem${item.name}"),
              index: index,
              item: item,
              width: _cellSize + margin.left,
              deleteModeCallback: () {
                if (!_deleteMode) {
                  _displayDeleteModeOverlay();
                  _deleteMode = true;
                }
              },
              margin: margin,
              onTap: _deleteMode
                  ? () => widget.onDelete(index)
                  : () => _onItemTap(index),
              selected: index == widget.selectedIndex,
              animationDuration: widget.animationDuration);
        });
  }

  /// Display an overlay that hover above everything except nav bar
  /// to catch a tap event and disable Delete mode.
  void _displayDeleteModeOverlay() {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            child: Listener(
                onPointerDown: (_) {
                  overlayEntry!.remove();
                  setState(() => _deleteMode = false);
                },
                child: Container(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                    child: widget.deleteIndicationWidget)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                (kBottomNavigationBarHeight +
                    MediaQuery.of(context).viewPadding.bottom)));
    Overlay.of(context).insert(overlayEntry);
  }

  /// When user tap on a a nav item, the nav bar try to scroll
  /// so that the selected item is centered on the screen.
  void _centerFocusItem(int index) {
    final preferredX = _cellSize * (index - 2),
        gap = _items.length > _maxItemDisplayed ? _cellSize / 2 : 0,
        offset = max<double>(
            0, min(preferredX + gap, _controller.position.maxScrollExtent));
    _controller.animateTo(offset,
        duration: widget.animationDuration, curve: Curves.easeOut);
  }

  void _onItemTap(int index) {
    _centerFocusItem(index);
    widget.onItemTap(index);
  }
}

///
/// Wrapper for [_ReorderableItem], it adds the DeleteMode listener
/// and a width to this [Widget].
///
class _ReorderableItemWrapper extends StatelessWidget {
  const _ReorderableItemWrapper(
      {Key? key,
      required this.index,
      required this.item,
      required this.width,
      required this.deleteModeCallback,
      required this.margin,
      required this.onTap,
      required this.selected,
      required this.animationDuration})
      : super(key: key);

  final int index;
  final NavBarItem item;
  final double width;
  final VoidCallback deleteModeCallback;
  final EdgeInsets margin;
  final VoidCallback onTap;
  final bool selected;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DeleteModeItemListener(
        deleteModeCallback: deleteModeCallback,
        child: Padding(
          padding: margin,
          child: ReorderableItem(
            index: index,
            item: item,
            onTap: onTap,
            selected: selected,
            animationDuration: animationDuration,
          ),
        ),
      ),
    );
  }
}

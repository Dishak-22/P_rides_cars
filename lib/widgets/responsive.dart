import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Width breakpoints shared by the whole app.
///
///  * mobile  : < 600   – single column, bottom navigation
///  * tablet  : 600–1023 – centred content, side navigation + two-pane layouts from 720
///  * desktop : >= 1024 – wider grids, extended side navigation from 1200
class Breakpoints {
  Breakpoints._();
  static const double tablet = 600;
  static const double split = 720;
  static const double desktop = 1024;
  static const double extendedRail = 1200;
}

extension ResponsiveContext on BuildContext {
  /// True when there is room for side navigation / two-pane layouts.
  bool get useSplitLayout => MediaQuery.sizeOf(this).width >= Breakpoints.split;
}

/// Centres [child] and limits it to [maxWidth] while keeping the same tight
/// constraints a full-width child would get (so existing Column/Expanded
/// layouts keep working). Pass `double.infinity` to disable the limit.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 640});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (maxWidth.isInfinite) return child;
    return LayoutBuilder(builder: (context, box) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: math.min(box.maxWidth, maxWidth),
          height: box.hasBoundedHeight ? box.maxHeight : null,
          child: child,
        ),
      );
    });
  }
}

/// A scrollable page body that still lets a `Spacer()` push the last widgets
/// to the bottom when there is room. Prevents overflow on short screens,
/// landscape phones and when the keyboard is open.
class FormScroll extends StatelessWidget {
  const FormScroll({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: math.max(0, box.maxHeight - padding.vertical)),
          child: IntrinsicHeight(child: child),
        ),
      );
    });
  }
}

/// Vertically centres [child] when there is room and scrolls when there is not.
class CenteredScroll extends StatelessWidget {
  const CenteredScroll({super.key, required this.child, this.padding = const EdgeInsets.all(24), this.maxWidth = 480});

  final Widget child;
  final EdgeInsets padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: math.max(0, box.maxHeight - padding.vertical)),
          child: Center(
            child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
          ),
        ),
      );
    });
  }
}

/// A scrolling list that automatically flows into 1, 2, 3… columns depending
/// on the available width (one column on phones, two on tablets/desktop).
class ResponsiveList extends StatelessWidget {
  const ResponsiveList({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(20),
    this.maxColumnWidth = 460,
    this.spacing = 12,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double maxColumnWidth;
  final double spacing;

  List<Widget> _spaced(List<Widget> items) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          items[i],
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final available = box.maxWidth - padding.horizontal;
      final cols = math.max(1, ((available + spacing) / (maxColumnWidth + spacing)).floor());

      final Widget content;
      if (cols == 1) {
        content = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _spaced(children));
      } else {
        final buckets = List.generate(cols, (_) => <Widget>[]);
        for (var i = 0; i < children.length; i++) {
          buckets[i % cols].add(children[i]);
        }
        content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cols; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _spaced(buckets[i])),
              ),
            ],
          ],
        );
      }
      return SingleChildScrollView(padding: padding, child: content);
    });
  }
}

/// Map + details layout.
///
///  * narrow: the map fills the screen and the details sit below it
///    (capped at 60% of the height and scrollable, so nothing overflows)
///  * wide  : the map is on the left and the details are a side panel
class MapPanelLayout extends StatelessWidget {
  const MapPanelLayout({
    super.key,
    required this.map,
    required this.children,
    this.footer,
    this.panelWidth = 400,
  });

  final Widget map;
  final List<Widget> children;

  /// Pinned below the scrolling [children] (usually the primary button).
  final Widget? footer;
  final double panelWidth;

  Widget _panel({required bool scrollable}) {
    return Column(
      mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: !scrollable,
            padding: EdgeInsets.fromLTRB(16, 8, 16, footer == null ? 16 : 8),
            children: children,
          ),
        ),
        if (footer != null) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), child: footer),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      if (box.maxWidth >= Breakpoints.split) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 0, 16), child: map)),
            SizedBox(width: panelWidth, child: _panel(scrollable: true)),
          ],
        );
      }
      return Column(
        children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(12), child: map)),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 560, maxHeight: box.maxHeight * 0.6),
              child: _panel(scrollable: false),
            ),
          ),
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'responsive.dart';

class PRideLogo extends StatelessWidget {
  final bool compact;
  const PRideLogo({super.key, this.compact = false});

  @override
  Widget build(BuildContext c) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 38 : 44,
            height: compact ? 38 : 44,
            decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.bolt_rounded, color: AppColors.navy, size: 25),
          ),
          if (!compact) const SizedBox(width: 10),
          if (!compact)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('P-Ride', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19, color: AppColors.navy)),
                Text("Pune's Smart Ride", style: TextStyle(fontSize: 10, color: AppColors.muted)),
              ],
            ),
        ],
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext c) => SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const SoftCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext c) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.035), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: child,
      );
}

/// Tap target that shows the pointer cursor on desktop / web.
class Tappable extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const Tappable({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext c) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: child),
      );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext c) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(c).textTheme.titleLarge),
          if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
        ],
      );
}

class MockMap extends StatelessWidget {
  final bool tracking;
  const MockMap({super.key, this.tracking = false});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(painter: _MapPainter(tracking), child: const SizedBox.expand()),
      );
}

class _MapPainter extends CustomPainter {
  final bool tracking;
  _MapPainter(this.tracking);

  @override
  void paint(Canvas c, Size s) {
    final bg = Paint()..color = const Color(0xFFE8EFEA);
    c.drawRect(Offset.zero & s, bg);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;
    for (int i = -2; i < 7; i++) {
      c.drawLine(Offset(s.width * .1 * i, s.height), Offset(s.width * (.2 + i * .13), 0), road);
      c.drawLine(Offset(0, s.height * (.14 * i + .35)), Offset(s.width, s.height * (.7 - i * .06)), road);
    }
    final p = Path()
      ..moveTo(s.width * .05, s.height * .72)
      ..cubicTo(s.width * .25, s.height * .58, s.width * .32, s.height * .83, s.width * .5, s.height * .55)
      ..cubicTo(s.width * .68, s.height * .3, s.width * .75, s.height * .55, s.width * .96, s.height * .24);
    c.drawPath(p, road);
    c.drawPath(
      p,
      Paint()
        ..color = AppColors.teal.withOpacity(.45)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke,
    );
    final pin = Paint()..color = AppColors.navy;
    final pos = tracking ? Offset(s.width * .62, s.height * .44) : Offset(s.width * .5, s.height * .55);
    c.drawCircle(pos, 15, pin);
    c.drawCircle(pos, 6, Paint()..color = AppColors.teal);
    if (!tracking) {
      c.drawCircle(Offset(s.width * .24, s.height * .68), 11, Paint()..color = AppColors.teal);
      c.drawCircle(Offset(s.width * .24, s.height * .68), 4, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.tracking != tracking;
}

/// Standard page: app bar + safe, width-limited body.
///
/// [maxWidth] centres the body on tablets/desktops. Use `double.infinity`
/// for full-bleed layouts such as map screens.
class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool back;
  final double maxWidth;
  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.back = true,
    this.maxWidth = 640,
  });

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(
          leading: back ? IconButton(onPressed: () => Navigator.maybePop(c), icon: const Icon(Icons.arrow_back_rounded)) : null,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: actions,
        ),
        body: SafeArea(top: false, child: ContentWidth(maxWidth: maxWidth, child: body)),
      );
}

class NavItem {
  final IconData icon, selectedIcon;
  final String label;
  const NavItem(this.icon, this.selectedIcon, this.label);
}

const navItems = [
  NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
  NavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Rides'),
  NavItem(Icons.local_offer_outlined, Icons.local_offer_rounded, 'Offers'),
  NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
];

/// Bottom navigation (phones).
class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext c) => NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onTap,
        height: 70,
        destinations: [
          for (final n in navItems)
            NavigationDestination(icon: Icon(n.icon), selectedIcon: Icon(n.selectedIcon), label: n.label),
        ],
      );
}

/// Side navigation (tablets & desktop). Extends to show labels on wide windows.
class SideNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const SideNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext c) {
    final size = MediaQuery.sizeOf(c);
    final extended = size.width >= Breakpoints.extendedRail;
    final shortScreen = size.height < 480; // e.g. landscape phone
    return NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      extended: extended,
      labelType: (extended || shortScreen) ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      leading: shortScreen
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: PRideLogo(compact: !extended),
            ),
      destinations: [
        for (final n in navItems)
          NavigationRailDestination(
            icon: Icon(n.icon),
            selectedIcon: Icon(n.selectedIcon),
            label: Text(n.label),
          ),
      ],
    );
  }
}

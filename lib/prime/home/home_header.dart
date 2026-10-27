import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home_style.dart';

/// Menu button, brand logo + name, booking-history shortcut.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onHistory});
  final VoidCallback onHistory;

  Widget _glass({required Widget child, required VoidCallback onTap, required String tooltip}) => Tooltip(
        message: tooltip,
        child: Material(
          color: HomeColors.glass,
          shape: CircleBorder(side: BorderSide(color: HomeColors.stroke)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(width: 46, height: 46, child: child),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        child: Row(children: [
          Builder(
            builder: (ctx) => _glass(
              tooltip: 'Menu',
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: const Icon(Icons.menu_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          const BrandLogo(size: 42, radius: 12),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('PRIME RIDES',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.1)),
              Text('PUNE', style: TextStyle(color: P.gold, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 2.4)),
            ]),
          ),
          _glass(
            tooltip: 'Booking history',
            onTap: onHistory,
            child: const Icon(Icons.receipt_long_rounded, color: Colors.white),
          ),
        ]),
      );
}

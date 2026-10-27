import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_style.dart';

/// Floating bottom bar: Home (active) + shortcuts to existing screens.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, required this.onBookings, required this.onOffers, required this.onProfile});
  final VoidCallback onBookings, onOffers, onProfile;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: HomeColors.card,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: HomeColors.stroke),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .35), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(color: P.gold, borderRadius: BorderRadius.circular(24)),
                child: const Row(children: [
                  Icon(Icons.home_rounded, color: P.navy, size: 22),
                  SizedBox(width: 8),
                  Text('Home', style: TextStyle(color: P.navy, fontWeight: FontWeight.w900, fontSize: 14)),
                ]),
              ),
              _item(Icons.receipt_long_rounded, 'Bookings', onBookings),
              _item(Icons.local_offer_rounded, 'Offers', onOffers),
              _item(Icons.person_rounded, 'Profile', onProfile),
            ]),
          ),
        ),
      );

  Widget _item(IconData icon, String label, VoidCallback onTap) => IconButton(
        tooltip: label,
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white.withValues(alpha: .72)),
        style: IconButton.styleFrom(fixedSize: const Size(48, 48)),
      );
}

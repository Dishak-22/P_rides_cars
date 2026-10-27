import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../theme.dart';
import 'promo_slide.dart';

/// Full offer details, opened when a customer taps a banner.
Future<void> showPromoDetails(BuildContext context, PromoSlide s, ValueChanged<TripType> onBook) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (s.badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: P.gold, borderRadius: BorderRadius.circular(20)),
              child: Text(s.badge, style: const TextStyle(color: P.navy, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .7)),
            ),
          const SizedBox(height: 12),
          Text(s.heading, style: const TextStyle(color: P.navy, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(s.description, style: const TextStyle(color: P.muted, fontSize: 14, height: 1.35)),
          const SizedBox(height: 14),
          if (s.destination.isNotEmpty) _row(Icons.place_rounded, 'Destination', s.destination),
          if (s.validUntil.isNotEmpty) _row(Icons.event_rounded, 'Valid until', s.validUntil),
          if (s.promoCode.isNotEmpty)
            _row(Icons.local_offer_rounded, 'Offer code', s.promoCode, trailing: IconButton(
              tooltip: 'Copy code',
              icon: const Icon(Icons.copy_rounded, size: 18, color: P.navy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: s.promoCode));
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Code copied')));
              },
            )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: P.gold, foregroundColor: P.navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Navigator.of(ctx).pop();
                onBook(s.trip);
              },
              child: Text(s.buttonText),
            ),
          ),
        ]),
      ),
    ),
  );
}

Widget _row(IconData icon, String label, String value, {Widget? trailing}) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 20, color: P.navy),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(color: P.muted, fontSize: 13)),
        Expanded(child: Text(value, style: const TextStyle(color: P.navy, fontWeight: FontWeight.w800, fontSize: 14))),
        if (trailing != null) trailing,
      ]),
    );

import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext c) => const AppShell(title: 'Offers', maxWidth: 1100, body: OffersBody());
}

class OffersBody extends StatelessWidget {
  const OffersBody({super.key});

  @override
  Widget build(BuildContext c) => ResponsiveList(children: [for (final o in offers) _OfferCard(o)]);
}

class _OfferCard extends StatelessWidget {
  const _OfferCard(this.offer);
  final Map<String, String> offer;

  @override
  Widget build(BuildContext c) => SoftCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.local_offer_rounded, color: AppColors.teal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer['title']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(offer['subtitle']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(offer['code']!, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.teal)),
                ],
              ),
            ),
          ],
        ),
      );
}

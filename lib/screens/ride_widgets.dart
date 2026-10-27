import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Small widgets shared by several ride screens (route line, fare row, info row, driver card).
class RouteLine extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const RouteLine({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext c) => Row(
        children: [
          Icon(icon, color: AppColors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      );
}

class FareRow extends StatelessWidget {
  final String a, b;
  final bool strong;
  const FareRow(this.a, this.b, {this.strong = false});

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(a, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w500))),
            Text(b, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w700, fontSize: strong ? 18 : 14)),
          ],
        ),
      );
}

class RideInfoRow extends StatelessWidget {
  final String a, b;
  const RideInfoRow(this.a, this.b);

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Expanded(child: Text(a, style: const TextStyle(color: AppColors.muted))),
            const SizedBox(width: 12),
            Text(b, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class DriverCard extends StatelessWidget {
  final VoidCallback onTap;
  const DriverCard({required this.onTap});

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: onTap,
        child: const SoftCard(
          child: Row(
            children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amit Patil', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    Text('4.9 ★ • Maruti Suzuki Dzire', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    Text('MH 12 KT 4821', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
}

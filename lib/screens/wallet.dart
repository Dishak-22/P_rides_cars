import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'P-Ride Wallet',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(24)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available balance', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  Text('₹540.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  SizedBox(height: 18),
                  Text('P-Ride Wallet • Demo balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SoftCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Add money', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.receipt_long_outlined),
                    title: Text('Wallet activity', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

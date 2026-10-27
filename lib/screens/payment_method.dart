import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Payment method',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _PayTile(title: 'Cash', subtitle: 'Pay driver after the ride', icon: Icons.payments_outlined, selected: true),
            _PayTile(title: 'P-Ride Wallet', subtitle: 'Demo balance ₹540', icon: Icons.account_balance_wallet_outlined),
            _PayTile(title: 'UPI', subtitle: 'Google Pay • PhonePe • BHIM', icon: Icons.account_balance_outlined),
          ],
        ),
      );
}

class _PayTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool selected;
  const _PayTile({required this.title, required this.subtitle, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SoftCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: AppColors.navy),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            trailing: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.teal : AppColors.muted),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => const Scaffold(body: SafeArea(child: ProfileBody()));
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext c) => ContentWidth(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            Row(children: [const PRideLogo(), const Spacer(), IconButton(onPressed: () => go(c, '/settings'), icon: const Icon(Icons.settings_outlined))]),
            const SizedBox(height: 22),
            SoftCard(
              child: Row(
                children: [
                  const CircleAvatar(radius: 32, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 31)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanmay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        Text('+91 98765 43210', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => go(c, '/edit-profile'), icon: const Icon(Icons.edit_outlined)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _MenuItem(title: 'P-Ride Wallet', icon: Icons.account_balance_wallet_outlined, route: '/wallet'),
            const _MenuItem(title: 'Ride history', icon: Icons.receipt_long_outlined, route: '/history'),
            const _MenuItem(title: 'Offers', icon: Icons.local_offer_outlined, route: '/offers'),
            const _MenuItem(title: 'Notifications', icon: Icons.notifications_none_rounded, route: '/notifications'),
            const _MenuItem(title: 'Help & support', icon: Icons.help_outline_rounded, route: '/help'),
            const _MenuItem(title: 'Settings', icon: Icons.settings_outlined, route: '/settings'),
          ],
        ),
      );
}

class _MenuItem extends StatelessWidget {
  final String title, route;
  final IconData icon;
  const _MenuItem({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: SoftCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => go(c, route),
            leading: Icon(icon, color: AppColors.navy),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
      );
}

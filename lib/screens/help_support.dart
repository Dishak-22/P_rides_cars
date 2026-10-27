import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Help & support',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('How can we help?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search help topics')),
            const SizedBox(height: 18),
            for (final x in const [
              'I have an issue with my ride',
              'Payment & refunds',
              'Safety and emergency',
              'Account & profile',
              'Offers and promotions',
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                child: SoftCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(x, style: const TextStyle(fontWeight: FontWeight.w800)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need more help?', style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 5),
                  Text('Chat with P-Ride support in this UI prototype.', style: TextStyle(color: AppColors.muted)),
                  SizedBox(height: 12),
                  OutlinedButton(onPressed: null, child: Text('Contact support')),
                ],
              ),
            ),
          ],
        ),
      );
}

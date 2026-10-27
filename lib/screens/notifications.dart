import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Notifications',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _Note(icon: Icons.local_offer_outlined, title: 'New offer unlocked', body: 'Get ₹20 off your next weekday ride.', time: '10 min ago'),
            _Note(icon: Icons.check_circle_outline, title: 'Ride completed', body: 'Your ride to Koregaon Park is complete.', time: 'Today'),
            _Note(icon: Icons.security_outlined, title: 'Safety first', body: 'Share your trip with trusted contacts anytime.', time: 'Yesterday'),
          ],
        ),
      );
}

class _Note extends StatelessWidget {
  final IconData icon;
  final String title, body, time;
  const _Note({required this.icon, required this.title, required this.body, required this.time});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SoftCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: const Color(0xFFE8FBF7), child: Icon(icon, color: AppColors.teal)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(body, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 5),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext c) => const AppShell(title: 'Ride history', maxWidth: 1100, body: RideHistoryBody());
}

/// Ride cards – one column on phones, two on tablets/desktop.
class RideHistoryBody extends StatelessWidget {
  const RideHistoryBody({super.key});

  @override
  Widget build(BuildContext c) => ResponsiveList(children: [for (final r in recentRides) RideCard(r)]);
}

class RideCard extends StatelessWidget {
  const RideCard(this.ride);
  final Map<String, String> ride;

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: () => go(c, '/details'),
        child: SoftCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.route_rounded, color: AppColors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride['to']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                        Text(ride['date']!, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Text(ride['fare']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text('${ride['from']} → ${ride['to']}', style: const TextStyle(fontSize: 12, color: AppColors.muted))),
                  const SizedBox(width: 8),
                  const Text('Completed', style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      );
}

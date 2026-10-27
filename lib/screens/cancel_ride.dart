import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../models/ride_models.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class CancelRideScreen extends StatelessWidget {
  const CancelRideScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Cancel ride',
        body: FormScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Why are you cancelling?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              for (final x in const [
                'Driver is taking too long',
                'Changed my plans',
                'Wrong pickup location',
                'Found another ride',
                'Other',
              ])
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: SoftCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(x, style: const TextStyle(fontWeight: FontWeight.w800)),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Cancel ride', onTap: () => go(c, '/complete')),
            ],
          ),
        ),
      );
}

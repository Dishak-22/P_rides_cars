import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: CenteredScroll(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: const BoxDecoration(color: Color(0xFFE6FBF8), shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: AppColors.teal, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Ride completed', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('You arrived at Koregaon Park', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 24),
                const SoftCard(
                  child: Column(
                    children: [
                      RideInfoRow('Fare', '₹189'),
                      RideInfoRow('Distance', '8.7 km'),
                      RideInfoRow('Duration', '24 min'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryButton(label: 'Rate your ride', onTap: () => go(c, '/rating')),
              ],
            ),
          ),
        ),
      );
}

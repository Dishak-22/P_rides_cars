import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../models/ride_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Driver profile',
        body: FormScroll(
          child: Column(
            children: [
              const CircleAvatar(radius: 46, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 48)),
              const SizedBox(height: 14),
              const Text('Amit Patil', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const Text('4.9 ★ • 1,240 rides', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              const SoftCard(
                child: Column(
                  children: [
                    RideInfoRow('Vehicle', 'Maruti Suzuki Dzire'),
                    RideInfoRow('Plate', 'MH 12 KT 4821'),
                    RideInfoRow('Member since', '2024'),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Chat with Amit', onTap: () => go(c, '/chat')),
            ],
          ),
        ),
      );
}

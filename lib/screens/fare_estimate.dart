import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class FareEstimateScreen extends StatelessWidget {
  const FareEstimateScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Fare estimate',
        body: FormScroll(
          child: Column(
            children: [
              const SoftCard(
                child: Column(
                  children: [
                    RideInfoRow('Pickup', 'Pune Railway Station'),
                    RideInfoRow('Destination', 'Koregaon Park'),
                    RideInfoRow('Ride', 'P-Ride Go'),
                    RideInfoRow('Estimated time', '24 min'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SoftCard(
                child: Column(
                  children: [
                    FareRow('Base fare', '₹55'),
                    FareRow('Distance', '₹102'),
                    FareRow('Booking fee', '₹12'),
                    Divider(),
                    FareRow('Estimated total', '₹189', strong: true),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Continue', onTap: () => go(c, '/confirm')),
            ],
          ),
        ),
      );
}

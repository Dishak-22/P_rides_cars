import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../widgets/common.dart';
import 'ride_widgets.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Ride details',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SoftCard(
              child: Column(
                children: [
                  RouteLine(title: 'Pune Railway Station', subtitle: 'Pickup', icon: Icons.trip_origin),
                  SizedBox(height: 18),
                  RouteLine(title: 'Koregaon Park', subtitle: 'Destination', icon: Icons.location_on),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SoftCard(
              child: Column(
                children: [
                  RideInfoRow('Ride type', 'P-Ride Go'),
                  RideInfoRow('Date', 'Today, 10:42 AM'),
                  RideInfoRow('Distance', '8.7 km'),
                  RideInfoRow('Duration', '24 min'),
                  RideInfoRow('Fare', '₹184'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            DriverCard(onTap: () => go(c, '/driver')),
          ],
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Confirm ride',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(),
          footer: PrimaryButton(label: 'Confirm P-Ride', onTap: () => go(c, '/searching')),
          children: const [
            SoftCard(
              child: Column(
                children: [
                  RouteLine(title: 'Pune Railway Station', subtitle: 'Pickup', icon: Icons.trip_origin),
                  SizedBox(height: 16),
                  RouteLine(title: 'Koregaon Park', subtitle: 'Destination', icon: Icons.location_on),
                ],
              ),
            ),
            SizedBox(height: 12),
            SoftCard(child: RideInfoRow('P-Ride Go', '₹189')),
          ],
        ),
      );
}

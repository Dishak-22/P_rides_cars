import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../models/ride_models.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'ride_widgets.dart';

class DriverAcceptedScreen extends StatelessWidget {
  const DriverAcceptedScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Driver found',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(tracking: true),
          footer: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(label: 'Track driver', onTap: () => go(c, '/tracking')),
              TextButton(onPressed: () => go(c, '/cancel'), child: const Text('Cancel ride')),
            ],
          ),
          children: [DriverCard(onTap: () => go(c, '/driver'))],
        ),
      );
}

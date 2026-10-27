import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class PickupScreen extends StatelessWidget {
  const PickupScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Pickup location',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search pickup')),
              const SizedBox(height: 14),
              const SoftCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: Color(0xFFE6FBF8), child: Icon(Icons.my_location_rounded, color: AppColors.teal)),
                  title: Text('Use current location', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('Mock location • Pune', style: TextStyle(color: AppColors.muted)),
                ),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Popular in Pune'),
              Expanded(
                child: ListView(
                  children: locations
                      .map((x) => ListTile(onTap: () => go(c, '/destination'), leading: const Icon(Icons.location_on_outlined), title: Text(x)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

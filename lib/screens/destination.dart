import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Where to?',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TextField(
                autofocus: true,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search destination', suffixIcon: Icon(Icons.mic_none_rounded)),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Popular destinations'),
              Expanded(
                child: ListView(
                  children: locations
                      .map((x) => ListTile(
                            onTap: () => go(c, '/choose'),
                            leading: const Icon(Icons.place_outlined),
                            title: Text(x),
                            subtitle: const Text('Pune, Maharashtra', style: TextStyle(color: AppColors.muted)),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});
  @override
  State<SearchingScreen> createState() => _SearchingState();
}

class _SearchingState extends State<SearchingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) go(context, '/accepted');
    });
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: CenteredScroll(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.teal),
                const SizedBox(height: 28),
                const Text('Finding your P-Ride', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Matching a nearby driver for your trip.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 28),
                OutlinedButton(onPressed: () => go(c, '/cancel'), child: const Text('Cancel ride')),
              ],
            ),
          ),
        ),
      );
}

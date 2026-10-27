import 'dart:async';
import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) go(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(24)),
                child: const Icon(Icons.bolt_rounded, size: 46, color: AppColors.navy),
              ),
              const SizedBox(height: 18),
              const Text('P-Ride', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text("Pune's Smart Ride", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
}

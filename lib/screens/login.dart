import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Welcome to P-Ride',
        maxWidth: 480,
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PRideLogo(),
              const SizedBox(height: 36),
              Text('Enter your mobile number', style: Theme.of(c).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('We’ll send a demo OTP to continue.', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 24),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(prefixText: '+91  ', labelText: 'Mobile number', hintText: '98765 43210'),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Continue', onTap: () => go(c, '/otp')),
              const SizedBox(height: 12),
              const Center(
                child: Text('Demo only • no real authentication', style: TextStyle(fontSize: 11, color: AppColors.muted)),
              ),
            ],
          ),
        ),
      );
}

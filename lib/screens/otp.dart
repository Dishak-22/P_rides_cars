import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Verify number',
        maxWidth: 480,
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter the 4-digit code', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Demo code: 2468', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 24),
              Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 10 : 0),
                      child: const TextField(
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(counterText: '', contentPadding: EdgeInsets.symmetric(vertical: 17)),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Verify & continue', onTap: () => go(c, '/home')),
              Center(child: TextButton(onPressed: () {}, child: const Text('Resend code'))),
            ],
          ),
        ),
      );
}

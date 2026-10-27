import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _hero({double? height, double iconSize = 120}) => Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(32)),
        child: Center(child: Icon(Icons.route_rounded, color: AppColors.teal, size: iconSize)),
      );

  Widget _headline() => const Text(
        'Your city. Your ride.',
        style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: AppColors.ink),
      );

  Widget _body() => const Text(
        'Quick pickups, clear fares and a smarter way to move around Pune.',
        style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.5),
      );

  Widget _actions(BuildContext c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(label: 'Get started', onTap: () => go(c, '/login')),
          const SizedBox(height: 10),
          Center(child: TextButton(onPressed: () => go(c, '/login'), child: const Text('I already have an account'))),
        ],
      );

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          // Wide: hero on the left, copy + buttons on the right.
          if (box.maxWidth >= 840) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _hero(iconSize: 160)),
                  const SizedBox(width: 56),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _headline(),
                              const SizedBox(height: 10),
                              _body(),
                              const SizedBox(height: 36),
                              _actions(c),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // Phone / small tablet: stacked, hero height adapts to the screen.
          final heroHeight = (box.maxHeight * 0.3).clamp(180.0, 300.0).toDouble();
          return ContentWidth(
            maxWidth: 560,
            child: FormScroll(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  _hero(height: heroHeight),
                  const SizedBox(height: 28),
                  _headline(),
                  const SizedBox(height: 10),
                  _body(),
                  const Spacer(),
                  const SizedBox(height: 16),
                  _actions(c),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

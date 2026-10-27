import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});
  @override
  State<RatingScreen> createState() => _RatingState();
}

class _RatingState extends State<RatingScreen> {
  int rating = 5;

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Rate your ride',
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(radius: 38, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 38)),
              const SizedBox(height: 14),
              const Text('How was your ride?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const Text('Amit Patil', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      onPressed: () => setState(() => rating = i + 1),
                      icon: Icon(i < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.amber, size: 38),
                    ),
                  ),
                ),
              ),
              const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Add a review (optional)')),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Submit review', onTap: () => go(c, '/home')),
            ],
          ),
        ),
      );
}

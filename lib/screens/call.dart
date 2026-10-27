import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        backgroundColor: AppColors.navy,
        body: SafeArea(
          child: CenteredScroll(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.navy, size: 50)),
                const SizedBox(height: 20),
                const Text('Amit Patil', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('Calling… • Demo UI', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.red,
                  child: IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.call_end, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
}

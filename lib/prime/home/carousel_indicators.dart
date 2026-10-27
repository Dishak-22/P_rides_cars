import 'package:flutter/material.dart';
import '../theme.dart';

/// Dots below the carousel; the active one expands smoothly.
class CarouselIndicators extends StatelessWidget {
  const CarouselIndicators({super.key, required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Slide ${index + 1} of $count',
        excludeSemantics: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: i == index ? 24 : 6,
              decoration: BoxDecoration(
                color: i == index ? P.gold : Colors.white.withValues(alpha: .28),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      );
}

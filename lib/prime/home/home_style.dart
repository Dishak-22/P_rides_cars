import 'package:flutter/material.dart';

/// Dark premium palette used only on the home screen.
class HomeColors {
  HomeColors._();
  static const top = Color(0xFF050B18);
  static const mid = Color(0xFF0A1830);
  static const bottom = Color(0xFF061226);
  static const card = Color(0xFF0E1B36);
  static const glow = Color(0xFF2F6BFF);
  static Color stroke = Colors.white.withValues(alpha: .10);
  static Color glass = Colors.white.withValues(alpha: .07);
}

/// Deep navy gradient with a soft blue glow in the top-right corner.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) => const IgnorePointer(
        child: Stack(children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [HomeColors.top, HomeColors.mid, HomeColors.bottom],
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -110,
            child: SizedBox(
              width: 340,
              height: 340,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Color(0x442F6BFF), Color(0x002F6BFF)]),
                ),
              ),
            ),
          ),
        ]),
      );
}

import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

/// Car drawing (existing CarArt painter) that drives slowly left/right over a
/// short distance on a thin road line. Stays inside its own bounds.
class AnimatedCarIllustration extends StatelessWidget {
  const AnimatedCarIllustration({
    super.key,
    required this.animation,
    required this.vehicle,
    this.width = 140,
    this.travel = 12,
    this.reduceMotion = false,
  });

  /// 0..1 looping value (shared with the banner's controller).
  final Animation<double> animation;
  final Vehicle vehicle;
  final double width;

  /// Maximum horizontal movement in logical pixels (each side of centre).
  final double travel;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final car = RepaintBoundary(
      child: SizedBox(
        width: width,
        child: CarArt(kind: vehicle.kind, color: vehicle.color),
      ),
    );
    return Semantics(
      label: '${vehicle.name} illustration',
      excludeSemantics: true,
      child: SizedBox(
        width: width + travel * 2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.hardEdge,
          children: [
            // road line
            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            reduceMotion
                ? car
                : AnimatedBuilder(
                    animation: animation,
                    child: car,
                    builder: (_, child) {
                      final t = Curves.easeInOut.transform(animation.value);
                      return Transform.translate(offset: Offset((t * 2 - 1) * travel, 0), child: child);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

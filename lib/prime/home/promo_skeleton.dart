import 'package:flutter/material.dart';
import '../theme.dart';

/// Loading placeholder shown while promotions are being fetched.
class PromoCarouselSkeleton extends StatefulWidget {
  const PromoCarouselSkeleton({super.key, this.height = 280});
  final double height;

  @override
  State<PromoCarouselSkeleton> createState() => _PromoCarouselSkeletonState();
}

class _PromoCarouselSkeletonState extends State<PromoCarouselSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _bar(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .22), borderRadius: BorderRadius.circular(8)),
      );

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'Loading offers',
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => Opacity(
            opacity: still ? .8 : .55 + .35 * _c.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 6),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [Color(0xFF0E1B36), Color(0xFF16345F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _bar(80, 20),
                const SizedBox(height: 14),
                _bar(170, 22),
                const SizedBox(height: 10),
                _bar(130, 12),
                const Spacer(),
                _bar(110, 42),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

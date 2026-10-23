import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'animated_car_illustration.dart';
import 'promo_slide.dart';

/// A single rounded promotional banner with animated background and car.
class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key, required this.slide, required this.onBook});
  final PromoSlide slide;
  final VoidCallback onBook;

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _loop =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) {
      _loop.stop();
      _started = false;
    } else if (!_started) {
      _loop.repeat(reverse: true);
      _started = true;
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.slide;
    final reduce = MediaQuery.of(context).disableAnimations;
    final vehicle = vehicles[s.vehicleIndex.clamp(0, vehicles.length - 1)];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: s.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: P.navy.withValues(alpha: .18), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: LayoutBuilder(builder: (context, c) {
        final carW = math.min(140.0, c.maxWidth * .40);
        return Stack(children: [
          // Animated background shapes (cheap: two circles that drift).
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _loop,
                  builder: (_, __) => CustomPaint(painter: _BgPainter(reduce ? .5 : _loop.value)),
                ),
              ),
            ),
          ),
          // Car, bottom-right, kept inside the banner.
          Positioned(
            right: 8,
            bottom: 10,
            child: AnimatedCarIllustration(
              animation: _loop,
              vehicle: vehicle,
              width: carW,
              travel: 10,
              reduceMotion: reduce,
            ),
          ),
          // Text + button, left side.
          Positioned(
            left: 18,
            top: 16,
            bottom: 16,
            width: c.maxWidth - carW * .55 - 18 - 12,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (s.badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: P.gold, borderRadius: BorderRadius.circular(20)),
                  child: Text(s.badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: P.navy, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .7)),
                ),
              const SizedBox(height: 10),
              Text(s.heading,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 20, height: 1.15, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(s.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFEAF1FB), fontSize: 12.5, height: 1.3)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: widget.onBook,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    backgroundColor: P.gold,
                    foregroundColor: P.navy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontSize: 13)),
                ),
              ),
            ]),
          ),
        ]);
      }),
    );
  }
}

class _BgPainter extends CustomPainter {
  _BgPainter(this.t);
  final double t; // 0..1

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..color = Colors.white.withValues(alpha: .07);
    canvas.drawCircle(Offset(s.width * (.78 + .06 * t), s.height * (.18 + .08 * t)), s.height * .42, p);
    canvas.drawCircle(Offset(s.width * (.55 - .05 * t), s.height * (1.0 - .06 * t)), s.height * .38,
        Paint()..color = P.gold.withValues(alpha: .10));
  }

  @override
  bool shouldRepaint(covariant _BgPainter old) => old.t != t;
}

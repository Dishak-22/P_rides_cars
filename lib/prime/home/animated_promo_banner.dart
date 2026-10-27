import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'animated_car_illustration.dart';
import 'promo_slide.dart';
import 'promo_visual.dart';

/// Full-width hero card: your car GIF fills the card, a dark gradient keeps the
/// text readable, and a gold button opens the matching booking flow.
class AnimatedPromoBanner extends StatefulWidget {
  const AnimatedPromoBanner({
    super.key,
    required this.slide,
    required this.onBook,
    this.onDetails,
  });

  final PromoSlide slide;
  final VoidCallback onBook;

  /// Tap on the card (outside the button). Only used when the slide has details.
  final VoidCallback? onDetails;

  @override
  State<AnimatedPromoBanner> createState() => _AnimatedPromoBannerState();
}

class _AnimatedPromoBannerState extends State<AnimatedPromoBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _loop =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
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
    final reduce = MediaQuery.disableAnimationsOf(context);
    final vehicle = vehicles[s.vehicleIndex.clamp(0, vehicles.length - 1)];
    final tappable = widget.onDetails != null && s.hasDetails;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: s.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
        boxShadow: [BoxShadow(color: const Color(0xFF2F6BFF).withValues(alpha: .20), blurRadius: 26, offset: const Offset(0, 12))],
      ),
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;

        // Used only when the GIF/image is unavailable: soft glow + drawn car.
        final art = Stack(fit: StackFit.expand, children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _loop,
              builder: (_, __) => CustomPaint(painter: _GlowPainter(reduce ? .5 : _loop.value)),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 34),
              child: AnimatedCarIllustration(
                animation: _loop,
                vehicle: vehicle,
                width: math.min<double>(w * .55, 200.0),
                travel: 8,
                reduceMotion: reduce,
              ),
            ),
          ),
        ]);

        const shade = Color(0xFF050B18);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: tappable ? widget.onDetails : null,
          child: Stack(fit: StackFit.expand, children: [
            // car GIF (fills the card, never stretched)
            IgnorePointer(
              child: RepaintBoundary(
                child: PromoVisual(
                  mediaUrl: s.mediaUrl,
                  fallback: art,
                  alignment: const Alignment(0, .25),
                  fadeLeft: false,
                ),
              ),
            ),
            // readability shading: bottom + left
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [shade.withValues(alpha: .95), shade.withValues(alpha: .62), shade.withValues(alpha: 0)],
                    stops: const [0, .5, 1],
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [shade.withValues(alpha: .55), shade.withValues(alpha: 0)],
                    stops: const [0, .7],
                  ),
                ),
              ),
            ),
            // text + button
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: _AnimatedText(
                key: ValueKey('${s.heading}|${s.description}'),
                reduceMotion: reduce,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: w * .78),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (s.badge.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(color: P.gold, borderRadius: BorderRadius.circular(20)),
                        child: Text(s.badge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: P.navy, fontSize: 10.5, fontWeight: FontWeight.w900, letterSpacing: .8)),
                      ),
                    const SizedBox(height: 10),
                    Text(s.heading,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(s.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withValues(alpha: .82), fontSize: 13, height: 1.3)),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: widget.onBook,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 46),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: P.gold,
                          foregroundColor: P.navy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                            child: Text(s.buttonText,
                                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

/// Subtle one-shot fade + upward slide for the banner text.
class _AnimatedText extends StatelessWidget {
  const _AnimatedText({super.key, required this.child, required this.reduceMotion});
  final Widget child;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 10 * (1 - v)), child: child),
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  _GlowPainter(this.t);
  final double t; // 0..1

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawCircle(Offset(s.width * (.75 + .04 * t), s.height * (.20 + .05 * t)), s.height * .45,
        Paint()..color = const Color(0xFF5AA0FF).withValues(alpha: .14));
    canvas.drawCircle(Offset(s.width * (.10 - .03 * t), s.height * 1.0), s.height * .40,
        Paint()..color = Colors.white.withValues(alpha: .05));
  }

  @override
  bool shouldRepaint(covariant _GlowPainter old) => old.t != t;
}

import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

/// Rounded booking-category card with press animation. Navigation is supplied by [onTap].
class BookingCategoryCard extends StatefulWidget {
  const BookingCategoryCard({super.key, required this.type, required this.onTap});
  final TripType type;
  final VoidCallback onTap;

  @override
  State<BookingCategoryCard> createState() => _BookingCategoryCardState();
}

class _BookingCategoryCardState extends State<BookingCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.type;
    final reduce = MediaQuery.of(context).disableAnimations;
    return Semantics(
      button: true,
      label: '${t.title}. ${t.description}',
      excludeSemantics: true,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed && !reduce ? .96 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Material(
          color: P.pale,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: P.line),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: t.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(t.icon, color: t.color, size: 25),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(color: P.gold, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_rounded, color: P.navy, size: 18),
                  ),
                ]),
                const SizedBox(height: 14),
                Text(t.title, style: const TextStyle(color: P.navy, fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(t.description, style: const TextStyle(color: P.muted, fontSize: 12, height: 1.3)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Choose Your Ride" grid with staggered fade + slide-up entrance.
class BookingCategoryGrid extends StatefulWidget {
  const BookingCategoryGrid({super.key, required this.onSelect});
  final ValueChanged<TripType> onSelect;

  static const order = [TripType.oneWay, TripType.roundTrip, TripType.hourly, TripType.airport];

  @override
  State<BookingCategoryGrid> createState() => _BookingCategoryGridState();
}

class _BookingCategoryGridState extends State<BookingCategoryGrid> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _animated(int i) {
    final start = i * .12;
    final curve = CurvedAnimation(parent: _c, curve: Interval(start, start + .55, curve: Curves.easeOutCubic));
    final type = BookingCategoryGrid.order[i];
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, .25), end: Offset.zero).animate(curve),
        child: BookingCategoryCard(type: type, onTap: () => widget.onSelect(type)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: _animated(0)),
              const SizedBox(width: 12),
              Expanded(child: _animated(1)),
            ]),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: _animated(2)),
              const SizedBox(width: 12),
              Expanded(child: _animated(3)),
            ]),
          ),
        ]),
      );
}

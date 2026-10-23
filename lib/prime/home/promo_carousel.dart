import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import 'carousel_indicators.dart';
import 'promo_banner.dart';
import 'promo_slide.dart';

/// Auto-advancing, swipeable promo carousel with slide + fade transition and indicators.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({
    super.key,
    required this.slides,
    required this.onBook,
    this.interval = const Duration(seconds: 5),
    this.height = 210,
  });

  final List<PromoSlide> slides;
  final ValueChanged<TripType> onBook;
  final Duration interval;
  final double height;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> with WidgetsBindingObserver {
  // Large start page so the carousel can loop forever in both directions.
  static const _loopBase = 10000;
  late final PageController _ctrl;
  final ValueNotifier<int> _index = ValueNotifier(0);
  Timer? _timer;
  bool _userTouching = false;

  int get _n => widget.slides.length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ctrl = PageController(viewportFraction: .92, initialPage: _loopBase * (_n == 0 ? 1 : _n));
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant PromoCarousel old) {
    super.didUpdateWidget(old);
    if (old.slides.length != _n && _index.value >= _n) _index.value = 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) => _advance());
  }

  void _advance() {
    if (!mounted || _userTouching || !_ctrl.hasClients || _n < 2) return;
    // Don't animate while another screen covers the home page, or in reduced-motion mode.
    if (!TickerMode.of(context) || MediaQuery.of(context).disableAnimations) return;
    final next = (_ctrl.page ?? _ctrl.initialPage.toDouble()).round() + 1;
    _ctrl.animateToPage(next, duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic);
  }

  void _touchDown() {
    _userTouching = true;
    _timer?.cancel();
  }

  void _touchUp() {
    _userTouching = false;
    _startTimer(); // restart so the next slide waits a full interval
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _ctrl.dispose();
    _index.dispose();
    super.dispose();
  }

  double _pageValue() =>
      (_ctrl.hasClients && _ctrl.position.haveDimensions ? _ctrl.page : null) ?? _ctrl.initialPage.toDouble();

  @override
  Widget build(BuildContext context) {
    if (_n == 0) return const SizedBox.shrink();
    return Column(children: [
      SizedBox(
        height: widget.height,
        child: Listener(
          onPointerDown: (_) => _touchDown(),
          onPointerUp: (_) => _touchUp(),
          onPointerCancel: (_) => _touchUp(),
          child: PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => _index.value = i % _n,
            itemBuilder: (_, i) {
              final slide = widget.slides[i % _n];
              return AnimatedBuilder(
                animation: _ctrl,
                child: PromoBanner(slide: slide, onBook: () => widget.onBook(slide.trip)),
                builder: (_, child) {
                  // 0 when centred, +-1 when fully off to the side.
                  final d = (_pageValue() - i).clamp(-1.0, 1.0);
                  final a = d.abs();
                  return Opacity(
                    opacity: 1 - a * .45,
                    child: Transform.scale(scale: 1 - a * .04, child: child),
                  );
                },
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      ValueListenableBuilder<int>(
        valueListenable: _index,
        builder: (_, i, __) => CarouselIndicators(count: _n, index: i),
      ),
    ]);
  }
}

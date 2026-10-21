import 'dart:async';
import 'package:flutter/material.dart';
import '../config.dart';
import '../models.dart';
import '../offers_repo.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';
import 'booking_form.dart';
import 'history.dart';
import 'info_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Offer> _offers = OfferRepo.defaults;

  @override
  void initState() {
    super.initState();
    OfferRepo.load().then((o) {
      if (mounted) setState(() => _offers = o);
    });
  }

  void _book(TripType t) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingFormScreen(type: t)));

  void _go(Widget page) {
    Navigator.of(context).pop(); // close drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        drawer: _buildDrawer(store),
        floatingActionButton: FloatingActionButton(
          heroTag: 'wa',
          tooltip: 'Chat on WhatsApp',
          backgroundColor: P.green,
          foregroundColor: Colors.white,
          onPressed: () => openWhatsApp(context, text: 'Hello PRIME RIDES PUNE, I need help with a ride.'),
          child: const Icon(Icons.chat_rounded, size: 28),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              _topBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(store.name.isEmpty ? 'Welcome!' : 'Hi, ${store.name.split(' ').first}!',
                      style: const TextStyle(color: P.muted, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Where would you\nlike to go?',
                      style: TextStyle(color: P.navy, fontSize: 28, height: 1.15, fontWeight: FontWeight.w900)),
                ]),
              ),
              HomeSlider(offers: _offers, onBook: _book),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 26, 20, 4),
                child: Text('Choose your ride', style: TextStyle(color: P.navy, fontSize: 21, fontWeight: FontWeight.w900)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Text('Tap Book Now on any service.', style: TextStyle(color: P.muted, fontSize: 13)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _RideCard(TripType.oneWay, () => _book(TripType.oneWay))),
                    const SizedBox(width: 12),
                    Expanded(child: _RideCard(TripType.hourly, () => _book(TripType.hourly))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _RideCard(TripType.roundTrip, () => _book(TripType.roundTrip))),
                    const SizedBox(width: 12),
                    Expanded(child: _RideCard(TripType.airport, () => _book(TripType.airport))),
                  ]),
                ]),
              ),
              const SizedBox(height: 26),
              const Center(
                child: Text(AppConfig.businessName,
                    style: TextStyle(color: P.navy, fontWeight: FontWeight.w900, letterSpacing: 1.4, fontSize: 11)),
              ),
              const SizedBox(height: 4),
              const Center(child: Text('Every journey starts with a good ride.', style: TextStyle(color: P.muted, fontSize: 11))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        child: Row(children: [
          Builder(
            builder: (ctx) => Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: const SizedBox(width: 46, height: 46, child: Icon(Icons.menu_rounded, color: P.navy)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const BrandLogo(size: 42, radius: 12),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('PRIME RIDES', style: TextStyle(color: P.navy, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.1)),
              Text('PUNE', style: TextStyle(color: P.muted, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 2)),
            ]),
          ),
          IconButton(
            tooltip: 'Booking history',
            style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: P.navy, fixedSize: const Size(46, 46)),
            icon: const Icon(Icons.receipt_long_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
        ]),
      );

  Widget _buildDrawer(AppStore store) => Drawer(
        child: SafeArea(
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [P.navy, Color(0xFF234A83)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const BrandLogo(size: 60, radius: 18),
                const SizedBox(height: 14),
                Text(store.name.isEmpty ? AppConfig.businessName : store.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19)),
                const SizedBox(height: 4),
                Text('+91 ${store.phone}', style: const TextStyle(color: Color(0xFFD8E4F7), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 8),
            _item(Icons.home_rounded, 'Home', () => Navigator.of(context).pop()),
            _item(Icons.person_rounded, 'Profile', () => _go(const ProfileScreen())),
            _item(Icons.receipt_long_rounded, 'Booking History', () => _go(const HistoryScreen())),
            _item(Icons.local_offer_rounded, 'Offers & Packages', () => _go(const OffersScreen())),
            _item(Icons.miscellaneous_services_rounded, 'Our Services', () => _go(const ServicesScreen())),
            _item(Icons.settings_rounded, 'Settings', () => _go(const SettingsScreen())),
            const Spacer(),
            _item(Icons.chat_rounded, 'Chat on WhatsApp', () {
              Navigator.of(context).pop();
              openWhatsApp(context, text: 'Hello PRIME RIDES PUNE');
            }, color: P.green),
            _item(Icons.logout_rounded, 'Logout', () async {
              Navigator.of(context).pop();
              await store.logout();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
            }, color: P.red),
            const SizedBox(height: 10),
          ]),
        ),
      );

  Widget _item(IconData icon, String title, VoidCallback onTap, {Color color = P.muted}) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 22),
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(color: P.navy, fontWeight: FontWeight.w700)),
        onTap: onTap,
      );
}

class _RideCard extends StatelessWidget {
  const _RideCard(this.type, this.onTap);
  final TripType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: P.line),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: type.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)),
                child: Icon(type.icon, color: type.color, size: 25),
              ),
              const SizedBox(height: 12),
              Text(type.label, style: const TextStyle(color: P.navy, fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Expanded(
                child: Text(type.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: P.muted, fontSize: 11, height: 1.3)),
              ),
              SizedBox(
                height: 38,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: EdgeInsets.zero,
                    backgroundColor: type.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontSize: 13)),
                ),
              ),
            ]),
          ),
        ),
      );
}

// ───────────────────────── Animated slider ─────────────────────────

class _Slide {
  final String title, subtitle, tag, imageUrl;
  final Vehicle? vehicle;
  final TripType trip;
  final List<Color> colors;
  const _Slide(this.title, this.subtitle, this.tag, this.trip, this.colors, {this.vehicle, this.imageUrl = ''});
}

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key, required this.offers, required this.onBook});
  final List<Offer> offers;
  final ValueChanged<TripType> onBook;
  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final _ctrl = PageController(viewportFraction: .92);
  Timer? _timer;
  int _page = 0;

  static const _palettes = [
    [Color(0xFF10233F), Color(0xFF2457E6)],
    [Color(0xFF5B2A86), Color(0xFF7950D9)],
    [Color(0xFF0E5E4A), Color(0xFF15966B)],
    [Color(0xFF9A3B0B), Color(0xFFE47B22)],
  ];

  List<_Slide> get _slides {
    final out = <_Slide>[];
    for (var i = 0; i < widget.offers.length; i++) {
      final o = widget.offers[i];
      out.add(_Slide(o.title, o.subtitle, o.tag, o.trip, _palettes[i % _palettes.length], imageUrl: o.imageUrl,
          vehicle: o.imageUrl.isEmpty ? vehicles[(i + 1) % vehicles.length] : null));
    }
    for (var i = 0; i < vehicles.length; i++) {
      final v = vehicles[i];
      out.add(_Slide('${v.name} • ${v.seats} Seater', v.model, 'OUR FLEET', TripType.oneWay, _palettes[(i + 2) % _palettes.length], vehicle: v));
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_ctrl.hasClients) return;
      final n = _slides.length;
      _ctrl.animateToPage((_page + 1) % n, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    return Column(children: [
      SizedBox(
        height: 210,
        child: PageView.builder(
          controller: _ctrl,
          itemCount: slides.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => _SlideCard(slide: slides[i], onBook: () => widget.onBook(slides[i].trip)),
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          slides.length,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: i == _page ? 22 : 6,
            decoration: BoxDecoration(color: i == _page ? P.blue : const Color(0xFFD3DBEA), borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    ]);
  }
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.slide, required this.onBook});
  final _Slide slide;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final hasImage = slide.imageUrl.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: slide.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(fit: StackFit.expand, children: [
        if (hasImage) ...[
          Image.network(slide.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: .1), Colors.black.withValues(alpha: .75)],
              ),
            ),
          ),
        ],
        if (slide.vehicle != null)
          Positioned(
            right: 10,
            bottom: 6,
            width: 165,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (_, v, child) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.translate(offset: Offset((1 - v) * -220, 0), child: child),
              ),
              child: VehicleArt(slide.vehicle!),
            ),
          ),
        Positioned(
          left: 18,
          right: 18,
          top: 16,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), borderRadius: BorderRadius.circular(20)),
              child: Text(slide.tag, style: TextStyle(color: slide.colors.last, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .7)),
            ),
            const SizedBox(height: 10),
            Text(slide.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 20, height: 1.15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(slide.subtitle,
                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFE6ECF8), fontSize: 12)),
          ]),
        ),
        Positioned(
          left: 18,
          bottom: 16,
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 38),
                backgroundColor: Colors.white,
                foregroundColor: P.navy,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Book Now', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ]),
    );
  }
}

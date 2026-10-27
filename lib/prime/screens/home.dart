import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../models.dart';
import '../offers_repo.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import '../home/booking_category_card.dart';
import '../home/home_bottom_nav.dart';
import '../home/home_header.dart';
import '../home/home_search_pill.dart';
import '../home/home_style.dart';
import '../home/promo_carousel.dart';
import '../home/promo_details_sheet.dart';
import '../home/promo_skeleton.dart';
import '../home/promo_slide.dart';
import '../home/whatsapp_fab.dart';
import 'auth.dart';
import 'booking_form.dart';
import 'history.dart';
import 'info_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Offer> _offers = OfferRepo.defaults;
  bool _loading = true; // true until the first load of promotions finishes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Reload promotions when the app comes back to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  /// Published offers from Supabase; falls back to built-in slides on error / when none exist.
  Future<void> _load() async {
    final offers = await OfferRepo.load().timeout(const Duration(seconds: 6), onTimeout: () => OfferRepo.defaults);
    if (!mounted) return;
    setState(() {
      _offers = offers;
      _loading = false;
    });
  }

  Future<void> _book(TripType t) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingFormScreen(type: t)));
    if (mounted) _load(); // refresh offers when the customer returns to Home
  }

  void _go(Widget page) {
    Navigator.of(context).pop(); // close drawer
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _open(Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final first = store.name.trim().isEmpty ? '' : store.name.trim().split(' ').first;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: HomeColors.bottom,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: HomeColors.bottom,
          drawer: _buildDrawer(store),
          floatingActionButton: const WhatsAppFab(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: HomeBottomNav(
            onBookings: () => _open(const HistoryScreen()),
            onOffers: () => _open(const OffersScreen()),
            onProfile: () => _open(const ProfileScreen()),
          ),
          body: Stack(children: [
            const Positioned.fill(child: HomeBackground()),
            SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: P.gold,
                backgroundColor: HomeColors.card,
                onRefresh: _load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 90),
                  children: [
                    HomeHeader(onHistory: () => _open(const HistoryScreen())),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(first.isEmpty ? 'Welcome!' : 'Welcome, $first!',
                            style: TextStyle(color: Colors.white.withValues(alpha: .62), fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 6),
                        const Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white, fontSize: 30, height: 1.14, fontWeight: FontWeight.w900),
                            children: [
                              TextSpan(text: 'Where would you\nlike to '),
                              TextSpan(text: 'go?', style: TextStyle(color: P.gold)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    HomeSearchPill(onTap: () => _book(TripType.oneWay)),
                    if (_loading)
                      const PromoCarouselSkeleton()
                    else
                      PromoCarousel(
                        slides: PromoSlides.fromOffers(_offers, remote: !identical(_offers, OfferRepo.defaults)),
                        onBook: _book,
                        onDetails: (s) => showPromoDetails(context, s, _book),
                      ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 4),
                      child: Text('Choose Your Ride', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                      child: Text('Tap a service to start your booking.',
                          style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 13)),
                    ),
                    BookingCategoryGrid(onSelect: _book),
                    const SizedBox(height: 26),
                    const Center(
                      child: Text(AppConfig.businessName,
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w900, letterSpacing: 1.4, fontSize: 11)),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text('Every journey starts with a good ride.',
                          style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

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

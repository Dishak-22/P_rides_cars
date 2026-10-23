import 'package:flutter/material.dart';
import '../config.dart';
import '../models.dart';
import '../offers_repo.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import '../home/booking_category_card.dart';
import '../home/promo_carousel.dart';
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
        floatingActionButton: const WhatsAppFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              PromoCarousel(
                slides: PromoSlides.fromOffers(_offers, remote: AppConfig.offersUrl.isNotEmpty),
                onBook: _book,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 26, 20, 4),
                child: Text('Choose Your Ride', style: TextStyle(color: P.navy, fontSize: 21, fontWeight: FontWeight.w900)),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Text('Tap a service to start your booking.', style: TextStyle(color: P.muted, fontSize: 13)),
              ),
              BookingCategoryGrid(onSelect: _book),
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

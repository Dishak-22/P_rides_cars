import 'dart:async';
import 'package:flutter/material.dart';

/// Prime Rides Pune home page. Save as lib/home_screen.dart.
/// Offer content is sample data until connected to the admin/backend.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onBookNow, this.onWhatsAppTap,
    this.onBookingHistoryTap, this.onProfileTap});

  /// Receives: 'One-way', 'Hourly Rental', 'Airport Transfer', 'Round Trip'.
  final ValueChanged<String>? onBookNow;
  final VoidCallback? onWhatsAppTap;
  final VoidCallback? onBookingHistoryTap;
  final VoidCallback? onProfileTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const navy = Color(0xFF10233F);
  static const blue = Color(0xFF2457E6);
  static const pale = Color(0xFFF4F7FC);
  static const muted = Color(0xFF69778C);
  final PageController _pageController = PageController(viewportFraction: .91);
  Timer? _timer;
  int _activeSlide = 0;

  final List<_Offer> _offers = const [
    _Offer('Chase the Monsoon', 'Green valleys, misty roads and refreshing weekend escapes.',
      'Lonavala • From Pune', 'MONSOON SPECIAL',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=85'),
    _Offer('A Weekend in Mahabaleshwar', 'Plan a relaxing hill-station drive with your favourite people.',
      'Mahabaleshwar • From Pune', 'WEEKEND GETAWAY',
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1400&q=85'),
    _Offer('Your Trip, Your Way', 'Comfortable rides for airport transfers and outstation travel.',
      'Pune and beyond', 'TRAVEL COMFORTABLY',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1400&q=85'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.animateToPage((_activeSlide + 1) % _offers.length,
        duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() { _timer?.cancel(); _pageController.dispose(); super.dispose(); }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$text will be connected when its page/service is ready.'),
      behavior: SnackBarBehavior.floating));

  void _book(String type) => widget.onBookNow != null
      ? widget.onBookNow!(type) : _message('$type booking');

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: pale,
    drawer: _drawer(),
    body: SafeArea(child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: _topBar()),
      SliverToBoxAdapter(child: _welcome()),
      SliverToBoxAdapter(child: _carousel()),
      SliverToBoxAdapter(child: _rideOptions()),
      SliverToBoxAdapter(child: _benefits()),
      SliverToBoxAdapter(child: _footer()),
    ])),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
        heroTag: 'primeRidesWhatsApp', tooltip: 'Chat on WhatsApp',
        backgroundColor: const Color(0xFF20C66B), foregroundColor: Colors.white,
        onPressed: widget.onWhatsAppTap ?? () => _message('WhatsApp support'),
        child: const Icon(Icons.chat_bubble_rounded, size: 27),
      ),
    ),
  );

  Widget _topBar() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
    child: Row(children: [
      Builder(builder: (context) => Material(color: Colors.white,
        borderRadius: BorderRadius.circular(15), child: InkWell(
          borderRadius: BorderRadius.circular(15), onTap: () => Scaffold.of(context).openDrawer(),
          child: const SizedBox(width: 48, height: 48, child: Icon(Icons.menu_rounded, color: navy, size: 26))))),
      const SizedBox(width: 12),
      Container(width: 44, height: 44, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [blue, Color(0xFF5484FF)]), borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.directions_car_filled_rounded, color: Colors.white, size: 25)),
      const SizedBox(width: 10),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('PRIME RIDES', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.1)),
        SizedBox(height: 2), Text('PUNE • YOUR RIDE, YOUR WAY', style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 9, letterSpacing: .7)),
      ])),
      IconButton(tooltip: 'Booking history', onPressed: widget.onBookingHistoryTap ?? () => _message('Booking history'),
        style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: navy, fixedSize: const Size(46, 46)),
        icon: const Icon(Icons.receipt_long_rounded)),
    ]),
  );

  Widget _welcome() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(color: const Color(0xFFE7EDFF), borderRadius: BorderRadius.circular(30)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.location_on_rounded, color: blue, size: 15), SizedBox(width: 5),
          Text('PUNE, MAHARASHTRA', style: TextStyle(color: blue, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: .8)),
        ])),
      const SizedBox(height: 13),
      const Text('Where would you\nlike to go?', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 31, height: 1.12, letterSpacing: -.8)),
      const SizedBox(height: 9),
      const Text('Book a comfortable ride for every journey.', style: TextStyle(color: muted, fontSize: 14, height: 1.45)),
    ]),
  );

  Widget _carousel() => Column(children: [
    SizedBox(height: 300, child: PageView.builder(
      controller: _pageController, itemCount: _offers.length,
      onPageChanged: (i) => setState(() => _activeSlide = i),
      itemBuilder: (context, i) => AnimatedBuilder(animation: _pageController, builder: (context, child) {
        double page = _activeSlide.toDouble();
        if (_pageController.hasClients && _pageController.position.haveDimensions) page = _pageController.page ?? page;
        final scale = (1 - (page - i).abs() * .045).clamp(.94, 1.0).toDouble();
        return Transform.scale(scale: scale, child: child);
      }, child: _offerCard(_offers[i])),
    )),
    const SizedBox(height: 13),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_offers.length, (i) => AnimatedContainer(
      duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 6, width: i == _activeSlide ? 23 : 6,
      decoration: BoxDecoration(color: i == _activeSlide ? blue : const Color(0xFFD3DBEA), borderRadius: BorderRadius.circular(20)),
    ))),
  ]);

  Widget _offerCard(_Offer offer) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3), clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(26),
      boxShadow: [BoxShadow(color: navy.withValues(alpha: .16), blurRadius: 18, offset: const Offset(0, 9))]),
    child: Stack(fit: StackFit.expand, children: [
      Image.network(offer.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [navy, Color(0xFF345E9A)])),
        child: Icon(Icons.directions_car_filled_rounded, size: 110, color: Colors.white.withValues(alpha: .16)))),
      DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.black.withValues(alpha: .06), Colors.black.withValues(alpha: .22), Colors.black.withValues(alpha: .84)], stops: const [0, .35, 1]))),
      Positioned(top: 17, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(30)),
        child: Text(offer.tag, style: const TextStyle(color: blue, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .65)))),
      Positioned(left: 18, right: 18, bottom: 18, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(offer.destination, style: const TextStyle(color: Color(0xFFE1E9FF), fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7), Text(offer.title, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 23, height: 1.12, fontWeight: FontWeight.w900, letterSpacing: -.4)),
        const SizedBox(height: 7), Text(offer.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFFF1F4FA), fontSize: 11, height: 1.4)),
        const SizedBox(height: 13), SizedBox(height: 42, child: ElevatedButton(
          onPressed: () => _book('Round Trip'), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: navy,
            elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 17), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Explore & Book', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, size: 16)]))),
      ])),
    ]),
  );

  Widget _rideOptions() {
    final options = <_RideOption>[
      _RideOption('ONE-WAY', 'Pay for one direction', Icons.arrow_forward_rounded, const Color(0xFFE9F1FF), blue, 'One-way'),
      _RideOption('HOURLY RENTAL', 'Keep a car by the hour', Icons.schedule_rounded, const Color(0xFFFFF0E4), const Color(0xFFE47B22), 'Hourly Rental'),
      _RideOption('AIRPORT TRANSFER', 'Airport pickup or drop', Icons.flight_takeoff_rounded, const Color(0xFFE7F8F1), const Color(0xFF15966B), 'Airport Transfer'),
      _RideOption('ROUND TRIP', 'Return journey made easy', Icons.sync_alt_rounded, const Color(0xFFF0E9FF), const Color(0xFF7950D9), 'Round Trip'),
    ];
    return Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Choose your ride', style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -.4)),
      const SizedBox(height: 6), const Text('Select a service to start your booking.', style: TextStyle(color: muted, fontSize: 13)),
      const SizedBox(height: 17), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: options.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .91),
        itemBuilder: (_, i) => _rideCard(options[i])),
    ]));
  }

  Widget _rideCard(_RideOption o) => Material(color: Colors.white, borderRadius: BorderRadius.circular(22), child: InkWell(
    onTap: () => _book(o.tripType), borderRadius: BorderRadius.circular(22), child: Padding(padding: const EdgeInsets.fromLTRB(14, 15, 14, 13),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 47, height: 47, decoration: BoxDecoration(color: o.tint, borderRadius: BorderRadius.circular(15)), child: Icon(o.icon, color: o.iconColor, size: 25)),
        const Spacer(), Text(o.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: .2)),
        const SizedBox(height: 5), Text(o.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF778397), fontSize: 10, height: 1.3)),
        const SizedBox(height: 13), Row(children: [const Expanded(child: Text('Book now', style: TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.w800))),
          Container(width: 27, height: 27, decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15))]),
      ]))));

  Widget _benefits() => Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 0), child: Container(
    padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)),
    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Travel with confidence', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)), SizedBox(height: 15),
      _Benefit(icon: Icons.verified_user_rounded, title: 'Trusted rides', subtitle: 'A smoother booking experience'),
      _Benefit(icon: Icons.support_agent_rounded, title: 'Helpful support', subtitle: 'We are here when you need us'),
      _Benefit(icon: Icons.currency_rupee_rounded, title: 'Simple booking', subtitle: 'Clear booking steps'),
    ])));

  Widget _footer() => const Padding(padding: EdgeInsets.fromLTRB(22, 24, 22, 105), child: Center(child: Column(children: [
    Text('PRIME RIDES PUNE', style: TextStyle(color: navy, fontWeight: FontWeight.w900, letterSpacing: 1.4, fontSize: 11)),
    SizedBox(height: 5), Text('Every journey starts with a good ride.', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 11)),
  ])));

  Widget _drawer() => Drawer(backgroundColor: Colors.white, child: SafeArea(child: Column(children: [
    Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [navy, Color(0xFF234A83)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 27, backgroundColor: Colors.white, child: Icon(Icons.directions_car_filled_rounded, color: blue, size: 29)),
        SizedBox(height: 15), Text('Prime Rides Pune', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        SizedBox(height: 5), Text('Comfortable rides. Memorable journeys.', style: TextStyle(color: Color(0xFFD8E4F7), fontSize: 12)),
      ])),
    const SizedBox(height: 10),
    _drawerItem(Icons.home_rounded, 'Home', () => Navigator.pop(context)),
    _drawerItem(Icons.receipt_long_rounded, 'Booking History', () { Navigator.pop(context); widget.onBookingHistoryTap != null ? widget.onBookingHistoryTap!() : _message('Booking history'); }),
    _drawerItem(Icons.local_offer_rounded, 'Offers & Packages', () { Navigator.pop(context); _message('Offers and packages'); }),
    _drawerItem(Icons.photo_library_rounded, 'Gallery', () { Navigator.pop(context); _message('Gallery'); }),
    _drawerItem(Icons.info_outline_rounded, 'About Us', () { Navigator.pop(context); _message('About Us'); }),
    _drawerItem(Icons.support_agent_rounded, 'Contact Us', () { Navigator.pop(context); widget.onWhatsAppTap != null ? widget.onWhatsAppTap!() : _message('Contact support'); }),
    const Spacer(), Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 20), child: SizedBox(width: double.infinity, height: 50,
      child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _book('One-way'); }, icon: const Icon(Icons.add_road_rounded), label: const Text('BOOK A RIDE', style: TextStyle(fontWeight: FontWeight.w800)),
        style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))),
  ])));

  Widget _drawerItem(IconData icon, String title, VoidCallback tap) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 22), leading: Icon(icon, color: muted, size: 22),
    title: Text(title, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w600)),
    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFB2BDCC)), onTap: tap);
}

class _Offer {
  const _Offer(this.title, this.subtitle, this.destination, this.tag, this.image);
  final String title, subtitle, destination, tag, image;
}
class _RideOption {
  const _RideOption(this.title, this.subtitle, this.icon, this.tint, this.iconColor, this.tripType);
  final String title, subtitle, tripType;
  final IconData icon;
  final Color tint, iconColor;
}
class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 13), child: Row(children: [
    Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
      child: Icon(icon, color: const Color(0xFF9DB8FF))), const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(color: Color(0xFFCBD5E5), fontSize: 11)),
    ])),
  ]));
}

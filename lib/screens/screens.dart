import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import '../models/ride_models.dart';
import '../data/mock_data.dart';
import '../navigation/app_routes.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Splash & onboarding
// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) go(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(24)),
                child: const Icon(Icons.bolt_rounded, size: 46, color: AppColors.navy),
              ),
              const SizedBox(height: 18),
              const Text('P-Ride', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text("Pune's Smart Ride", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _hero({double? height, double iconSize = 120}) => Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(32)),
        child: Center(child: Icon(Icons.route_rounded, color: AppColors.teal, size: iconSize)),
      );

  Widget _headline() => const Text(
        'Your city. Your ride.',
        style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: AppColors.ink),
      );

  Widget _body() => const Text(
        'Quick pickups, clear fares and a smarter way to move around Pune.',
        style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.5),
      );

  Widget _actions(BuildContext c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(label: 'Get started', onTap: () => go(c, '/login')),
          const SizedBox(height: 10),
          Center(child: TextButton(onPressed: () => go(c, '/login'), child: const Text('I already have an account'))),
        ],
      );

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          // Wide: hero on the left, copy + buttons on the right.
          if (box.maxWidth >= 840) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _hero(iconSize: 160)),
                  const SizedBox(width: 56),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _headline(),
                              const SizedBox(height: 10),
                              _body(),
                              const SizedBox(height: 36),
                              _actions(c),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // Phone / small tablet: stacked, hero height adapts to the screen.
          final heroHeight = (box.maxHeight * 0.3).clamp(180.0, 300.0).toDouble();
          return ContentWidth(
            maxWidth: 560,
            child: FormScroll(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  _hero(height: heroHeight),
                  const SizedBox(height: 28),
                  _headline(),
                  const SizedBox(height: 10),
                  _body(),
                  const Spacer(),
                  const SizedBox(height: 16),
                  _actions(c),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Login & OTP
// ─────────────────────────────────────────────────────────────────────────────

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Welcome to P-Ride',
        maxWidth: 480,
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PRideLogo(),
              const SizedBox(height: 36),
              Text('Enter your mobile number', style: Theme.of(c).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('We’ll send a demo OTP to continue.', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 24),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(prefixText: '+91  ', labelText: 'Mobile number', hintText: '98765 43210'),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Continue', onTap: () => go(c, '/otp')),
              const SizedBox(height: 12),
              const Center(
                child: Text('Demo only • no real authentication', style: TextStyle(fontSize: 11, color: AppColors.muted)),
              ),
            ],
          ),
        ),
      );
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Verify number',
        maxWidth: 480,
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter the 4-digit code', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Demo code: 2468', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 24),
              Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 10 : 0),
                      child: const TextField(
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(counterText: '', contentPadding: EdgeInsets.symmetric(vertical: 17)),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Verify & continue', onTap: () => go(c, '/home')),
              Center(child: TextButton(onPressed: () {}, child: const Text('Resend code'))),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Home (bottom nav on phones, side nav on tablets & desktop)
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int tab = 0;

  void _select(int i) => setState(() => tab = i);

  Widget _page() {
    switch (tab) {
      case 1:
        return const _TabFrame(title: 'Ride history', child: RideHistoryBody());
      case 2:
        return const _TabFrame(title: 'Offers', child: OffersBody());
      case 3:
        return const SafeArea(child: ProfileBody());
      default:
        return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext c) {
    if (c.useSplitLayout) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(child: SideNav(index: tab, onTap: _select)),
            const VerticalDivider(width: 1, color: AppColors.line),
            Expanded(child: _page()),
          ],
        ),
      );
    }
    return Scaffold(body: _page(), bottomNavigationBar: BottomNav(index: tab, onTap: _select));
  }
}

/// Title + width-limited body used by the Rides / Offers tabs.
class _TabFrame extends StatelessWidget {
  const _TabFrame({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext c) => SafeArea(
        child: ContentWidth(
          maxWidth: 1100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(title, style: Theme.of(c).textTheme.headlineMedium),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      );
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext c) {
    final hasSideNav = c.useSplitLayout;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
            child: Row(
              children: [
                if (hasSideNav) Text('Book a ride', style: Theme.of(c).textTheme.headlineMedium) else const PRideLogo(compact: true),
                const Spacer(),
                IconButton(onPressed: () => go(c, '/notifications'), icon: const Icon(Icons.notifications_none_rounded)),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              if (box.maxWidth >= 680) {
                final panelWidth = (box.maxWidth * 0.36).clamp(320.0, 420.0).toDouble();
                return _HomeSplit(panelWidth: panelWidth);
              }
              return const _HomeOverlay();
            }),
          ),
        ],
      ),
    );
  }
}

/// Phone / narrow layout: full-bleed map with floating cards.
class _HomeOverlay extends StatelessWidget {
  const _HomeOverlay();

  @override
  Widget build(BuildContext c) => Stack(
        children: [
          const Positioned.fill(child: Padding(padding: EdgeInsets.all(8), child: MockMap())),
          Positioned(
            top: 24,
            left: 20,
            right: 20,
            child: Center(
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: const _SearchBar()),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_PickupCard(), SizedBox(height: 10), _QuickActions()],
                ),
              ),
            ),
          ),
        ],
      );
}

/// Wide layout: booking panel on the left, map on the right.
class _HomeSplit extends StatelessWidget {
  const _HomeSplit({required this.panelWidth});
  final double panelWidth;

  @override
  Widget build(BuildContext c) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: panelWidth,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 20),
              children: [
                const _SearchBar(),
                const SizedBox(height: 12),
                const _PickupCard(),
                const SizedBox(height: 12),
                const _QuickActions(),
                const SizedBox(height: 24),
                SectionTitle(title: 'Recent rides', action: 'See all', onAction: () => go(c, '/history')),
                const SizedBox(height: 8),
                for (final r in recentRides) ...[
                  _RideCard(r),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const Expanded(child: Padding(padding: EdgeInsets.fromLTRB(4, 0, 16, 16), child: MockMap())),
        ],
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: () => go(c, '/destination'),
        child: const SoftCard(
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.teal),
              SizedBox(width: 12),
              Expanded(child: Text('Where to?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              Icon(Icons.tune_rounded, color: AppColors.muted),
            ],
          ),
        ),
      );
}

class _PickupCard extends StatelessWidget {
  const _PickupCard();

  @override
  Widget build(BuildContext c) => const SoftCard(
        child: Row(
          children: [
            Icon(Icons.location_on_rounded, color: AppColors.teal),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  Text('Pune Railway Station', style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded),
          ],
        ),
      );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext c) => Row(
        children: [
          Expanded(child: _Quick(label: 'History', icon: Icons.history_rounded, onTap: () => go(c, '/history'))),
          const SizedBox(width: 8),
          Expanded(child: _Quick(label: 'Wallet', icon: Icons.account_balance_wallet_outlined, onTap: () => go(c, '/wallet'))),
          const SizedBox(width: 8),
          Expanded(child: _Quick(label: 'Offers', icon: Icons.local_offer_outlined, onTap: () => go(c, '/offers'))),
        ],
      );
}

class _Quick extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _Quick({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: AppColors.navy),
              const SizedBox(width: 5),
              Flexible(
                child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Pickup / destination
// ─────────────────────────────────────────────────────────────────────────────

class PickupScreen extends StatelessWidget {
  const PickupScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Pickup location',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search pickup')),
              const SizedBox(height: 14),
              const SoftCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: Color(0xFFE6FBF8), child: Icon(Icons.my_location_rounded, color: AppColors.teal)),
                  title: Text('Use current location', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('Mock location • Pune', style: TextStyle(color: AppColors.muted)),
                ),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Popular in Pune'),
              Expanded(
                child: ListView(
                  children: locations
                      .map((x) => ListTile(onTap: () => go(c, '/destination'), leading: const Icon(Icons.location_on_outlined), title: Text(x)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Where to?',
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TextField(
                autofocus: true,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search destination', suffixIcon: Icon(Icons.mic_none_rounded)),
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: 'Popular destinations'),
              Expanded(
                child: ListView(
                  children: locations
                      .map((x) => ListTile(
                            onTap: () => go(c, '/choose'),
                            leading: const Icon(Icons.place_outlined),
                            title: Text(x),
                            subtitle: const Text('Pune, Maharashtra', style: TextStyle(color: AppColors.muted)),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Booking flow
// ─────────────────────────────────────────────────────────────────────────────

class ChooseRideScreen extends StatefulWidget {
  const ChooseRideScreen({super.key});
  @override
  State<ChooseRideScreen> createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRideScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Choose your ride',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(),
          footer: PrimaryButton(label: 'View fare estimate', onTap: () => go(c, '/fare')),
          children: [
            const Text('Available rides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            for (var i = 0; i < rideOptions.length; i++)
              _RideOptionTile(option: rideOptions[i], selected: selected == i, onTap: () => setState(() => selected = i)),
          ],
        ),
      );
}

class _RideOptionTile extends StatelessWidget {
  const _RideOptionTile({required this.option, required this.selected, required this.onTap});
  final RideOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.teal : AppColors.line, width: selected ? 1.7 : 1),
          ),
          child: Row(
            children: [
              Icon(option.icon, color: AppColors.navy, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text('${option.eta} • ${option.capacity}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              Text(option.fare, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
        ),
      );
}

class FareEstimateScreen extends StatelessWidget {
  const FareEstimateScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Fare estimate',
        body: FormScroll(
          child: Column(
            children: [
              const SoftCard(
                child: Column(
                  children: [
                    _InfoRow('Pickup', 'Pune Railway Station'),
                    _InfoRow('Destination', 'Koregaon Park'),
                    _InfoRow('Ride', 'P-Ride Go'),
                    _InfoRow('Estimated time', '24 min'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SoftCard(
                child: Column(
                  children: [
                    _FareRow('Base fare', '₹55'),
                    _FareRow('Distance', '₹102'),
                    _FareRow('Booking fee', '₹12'),
                    Divider(),
                    _FareRow('Estimated total', '₹189', strong: true),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Continue', onTap: () => go(c, '/confirm')),
            ],
          ),
        ),
      );
}

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Confirm ride',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(),
          footer: PrimaryButton(label: 'Confirm P-Ride', onTap: () => go(c, '/searching')),
          children: const [
            SoftCard(
              child: Column(
                children: [
                  _RouteLine(title: 'Pune Railway Station', subtitle: 'Pickup', icon: Icons.trip_origin),
                  SizedBox(height: 16),
                  _RouteLine(title: 'Koregaon Park', subtitle: 'Destination', icon: Icons.location_on),
                ],
              ),
            ),
            SizedBox(height: 12),
            SoftCard(child: _InfoRow('P-Ride Go', '₹189')),
          ],
        ),
      );
}

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});
  @override
  State<SearchingScreen> createState() => _SearchingState();
}

class _SearchingState extends State<SearchingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) go(context, '/accepted');
    });
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: CenteredScroll(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.teal),
                const SizedBox(height: 28),
                const Text('Finding your P-Ride', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Matching a nearby driver for your trip.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 28),
                OutlinedButton(onPressed: () => go(c, '/cancel'), child: const Text('Cancel ride')),
              ],
            ),
          ),
        ),
      );
}

class DriverAcceptedScreen extends StatelessWidget {
  const DriverAcceptedScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Driver found',
        maxWidth: double.infinity,
        body: MapPanelLayout(
          map: const MockMap(tracking: true),
          footer: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(label: 'Track driver', onTap: () => go(c, '/tracking')),
              TextButton(onPressed: () => go(c, '/cancel'), child: const Text('Cancel ride')),
            ],
          ),
          children: [_DriverCard(onTap: () => go(c, '/driver'))],
        ),
      );
}

class DriverTrackingScreen extends StatelessWidget {
  const DriverTrackingScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= Breakpoints.split;
            return Stack(
              children: [
                const Positioned.fill(child: MockMap(tracking: true)),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Align(
                    alignment: wide ? Alignment.bottomLeft : Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: wide ? 420 : 560, maxHeight: math.max(0.0, box.maxHeight - 32)),
                      child: SoftCard(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(radius: 25, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Amit is on the way', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                                      Text('Maruti Suzuki Dzire • MH 12 KT 4821', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                IconButton(onPressed: () => go(c, '/call'), icon: const Icon(Icons.call_outlined)),
                                IconButton(onPressed: () => go(c, '/chat'), icon: const Icon(Icons.chat_bubble_outline)),
                              ],
                            ),
                            const Divider(),
                            const _InfoRow('Arriving in', '4 min'),
                            const _InfoRow('Trip estimate', '₹189'),
                            PrimaryButton(label: 'Complete demo ride', onTap: () => go(c, '/complete')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Driver profile',
        body: FormScroll(
          child: Column(
            children: [
              const CircleAvatar(radius: 46, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 48)),
              const SizedBox(height: 14),
              const Text('Amit Patil', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const Text('4.9 ★ • 1,240 rides', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              const SoftCard(
                child: Column(
                  children: [
                    _InfoRow('Vehicle', 'Maruti Suzuki Dzire'),
                    _InfoRow('Plate', 'MH 12 KT 4821'),
                    _InfoRow('Member since', '2024'),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Chat with Amit', onTap: () => go(c, '/chat')),
            ],
          ),
        ),
      );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  final messages = <String>['Hi, I am near the station entrance.', 'Okay, I’m coming to the pickup point.'];
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send() {
    if (controller.text.trim().isEmpty) return;
    setState(() => messages.add(controller.text.trim()));
    controller.clear();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('Chat with Amit')),
        body: SafeArea(
          top: false,
          child: ContentWidth(
            maxWidth: 720,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, i) => Align(
                      alignment: i.isOdd ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: i.isOdd ? AppColors.navy : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Text(messages[i], style: TextStyle(color: i.isOdd ? Colors.white : AppColors.ink)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(hintText: 'Type a message'),
                        ),
                      ),
                      IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: AppColors.teal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        backgroundColor: AppColors.navy,
        body: SafeArea(
          child: CenteredScroll(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.navy, size: 50)),
                const SizedBox(height: 20),
                const Text('Amit Patil', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('Calling… • Demo UI', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.red,
                  child: IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.call_end, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
}

class CancelRideScreen extends StatelessWidget {
  const CancelRideScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Cancel ride',
        body: FormScroll(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Why are you cancelling?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              for (final x in const [
                'Driver is taking too long',
                'Changed my plans',
                'Wrong pickup location',
                'Found another ride',
                'Other',
              ])
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: SoftCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(x, style: const TextStyle(fontWeight: FontWeight.w800)),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Cancel ride', onTap: () => go(c, '/complete')),
            ],
          ),
        ),
      );
}

class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
        body: SafeArea(
          child: CenteredScroll(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: const BoxDecoration(color: Color(0xFFE6FBF8), shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: AppColors.teal, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Ride completed', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('You arrived at Koregaon Park', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 24),
                const SoftCard(
                  child: Column(
                    children: [
                      _InfoRow('Fare', '₹189'),
                      _InfoRow('Distance', '8.7 km'),
                      _InfoRow('Duration', '24 min'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                PrimaryButton(label: 'Rate your ride', onTap: () => go(c, '/rating')),
              ],
            ),
          ),
        ),
      );
}

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});
  @override
  State<RatingScreen> createState() => _RatingState();
}

class _RatingState extends State<RatingScreen> {
  int rating = 5;

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Rate your ride',
        body: FormScroll(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(radius: 38, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 38)),
              const SizedBox(height: 14),
              const Text('How was your ride?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const Text('Amit Patil', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => IconButton(
                      onPressed: () => setState(() => rating = i + 1),
                      icon: Icon(i < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.amber, size: 38),
                    ),
                  ),
                ),
              ),
              const TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Add a review (optional)')),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Submit review', onTap: () => go(c, '/home')),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment, history, offers, wallet, notifications
// ─────────────────────────────────────────────────────────────────────────────

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Payment method',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _PayTile(title: 'Cash', subtitle: 'Pay driver after the ride', icon: Icons.payments_outlined, selected: true),
            _PayTile(title: 'P-Ride Wallet', subtitle: 'Demo balance ₹540', icon: Icons.account_balance_wallet_outlined),
            _PayTile(title: 'UPI', subtitle: 'Google Pay • PhonePe • BHIM', icon: Icons.account_balance_outlined),
          ],
        ),
      );
}

class _PayTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final bool selected;
  const _PayTile({required this.title, required this.subtitle, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SoftCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: AppColors.navy),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            trailing: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.teal : AppColors.muted),
          ),
        ),
      );
}

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext c) => const AppShell(title: 'Ride history', maxWidth: 1100, body: RideHistoryBody());
}

/// Ride cards – one column on phones, two on tablets/desktop.
class RideHistoryBody extends StatelessWidget {
  const RideHistoryBody({super.key});

  @override
  Widget build(BuildContext c) => ResponsiveList(children: [for (final r in recentRides) _RideCard(r)]);
}

class _RideCard extends StatelessWidget {
  const _RideCard(this.ride);
  final Map<String, String> ride;

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: () => go(c, '/details'),
        child: SoftCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.route_rounded, color: AppColors.teal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ride['to']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                        Text(ride['date']!, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Text(ride['fare']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text('${ride['from']} → ${ride['to']}', style: const TextStyle(fontSize: 12, color: AppColors.muted))),
                  const SizedBox(width: 8),
                  const Text('Completed', style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      );
}

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Ride details',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SoftCard(
              child: Column(
                children: [
                  _RouteLine(title: 'Pune Railway Station', subtitle: 'Pickup', icon: Icons.trip_origin),
                  SizedBox(height: 18),
                  _RouteLine(title: 'Koregaon Park', subtitle: 'Destination', icon: Icons.location_on),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SoftCard(
              child: Column(
                children: [
                  _InfoRow('Ride type', 'P-Ride Go'),
                  _InfoRow('Date', 'Today, 10:42 AM'),
                  _InfoRow('Distance', '8.7 km'),
                  _InfoRow('Duration', '24 min'),
                  _InfoRow('Fare', '₹184'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _DriverCard(onTap: () => go(c, '/driver')),
          ],
        ),
      );
}

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext c) => const AppShell(title: 'Offers', maxWidth: 1100, body: OffersBody());
}

class OffersBody extends StatelessWidget {
  const OffersBody({super.key});

  @override
  Widget build(BuildContext c) => ResponsiveList(children: [for (final o in offers) _OfferCard(o)]);
}

class _OfferCard extends StatelessWidget {
  const _OfferCard(this.offer);
  final Map<String, String> offer;

  @override
  Widget build(BuildContext c) => SoftCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.local_offer_rounded, color: AppColors.teal),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer['title']!, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(offer['subtitle']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(offer['code']!, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.teal)),
                ],
              ),
            ),
          ],
        ),
      );
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'P-Ride Wallet',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(24)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available balance', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  Text('₹540.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  SizedBox(height: 18),
                  Text('P-Ride Wallet • Demo balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SoftCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Add money', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.receipt_long_outlined),
                    title: Text('Wallet activity', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Notifications',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _Note(icon: Icons.local_offer_outlined, title: 'New offer unlocked', body: 'Get ₹20 off your next weekday ride.', time: '10 min ago'),
            _Note(icon: Icons.check_circle_outline, title: 'Ride completed', body: 'Your ride to Koregaon Park is complete.', time: 'Today'),
            _Note(icon: Icons.security_outlined, title: 'Safety first', body: 'Share your trip with trusted contacts anytime.', time: 'Yesterday'),
          ],
        ),
      );
}

class _Note extends StatelessWidget {
  final IconData icon;
  final String title, body, time;
  const _Note({required this.icon, required this.title, required this.body, required this.time});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SoftCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: const Color(0xFFE8FBF7), child: Icon(icon, color: AppColors.teal)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(body, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 5),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile, settings, help
// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => const Scaffold(body: SafeArea(child: ProfileBody()));
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext c) => ContentWidth(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            Row(children: [const PRideLogo(), const Spacer(), IconButton(onPressed: () => go(c, '/settings'), icon: const Icon(Icons.settings_outlined))]),
            const SizedBox(height: 22),
            SoftCard(
              child: Row(
                children: [
                  const CircleAvatar(radius: 32, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 31)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanmay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        Text('+91 98765 43210', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => go(c, '/edit-profile'), icon: const Icon(Icons.edit_outlined)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _MenuItem(title: 'P-Ride Wallet', icon: Icons.account_balance_wallet_outlined, route: '/wallet'),
            const _MenuItem(title: 'Ride history', icon: Icons.receipt_long_outlined, route: '/history'),
            const _MenuItem(title: 'Offers', icon: Icons.local_offer_outlined, route: '/offers'),
            const _MenuItem(title: 'Notifications', icon: Icons.notifications_none_rounded, route: '/notifications'),
            const _MenuItem(title: 'Help & support', icon: Icons.help_outline_rounded, route: '/help'),
            const _MenuItem(title: 'Settings', icon: Icons.settings_outlined, route: '/settings'),
          ],
        ),
      );
}

class _MenuItem extends StatelessWidget {
  final String title, route;
  final IconData icon;
  const _MenuItem({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: SoftCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => go(c, route),
            leading: Icon(icon, color: AppColors.navy),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
      );
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Edit profile',
        body: FormScroll(
          child: Column(
            children: [
              const CircleAvatar(radius: 42, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white, size: 42)),
              const SizedBox(height: 22),
              const TextField(decoration: InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Mobile number', prefixIcon: Icon(Icons.phone_outlined))),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline))),
              const Spacer(),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Save changes', onTap: () => Navigator.pop(c)),
            ],
          ),
        ),
      );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final values = [true, true, true, false];
  final labels = ['Notifications', 'Sound & vibration', 'Save places', 'Location sharing'];
  final subtitles = ['Ride updates, offers and alerts', 'Driver arrival and ride sounds', 'Quick access to Home and Work', 'Demo only — no real tracking'];

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Settings',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (var i = 0; i < labels.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: SoftCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: values[i],
                    onChanged: (v) => setState(() => values[i] = v),
                    title: Text(labels[i], style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(subtitles[i], style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    activeThumbColor: AppColors.teal,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const SoftCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.privacy_tip_outlined),
                    title: Text('Privacy', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.info_outline),
                    title: Text('About P-Ride', style: TextStyle(fontWeight: FontWeight.w800)),
                    trailing: Text('v1.0.0', style: TextStyle(color: AppColors.muted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext c) => AppShell(
        title: 'Help & support',
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('How can we help?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search help topics')),
            const SizedBox(height: 18),
            for (final x in const [
              'I have an issue with my ride',
              'Payment & refunds',
              'Safety and emergency',
              'Account & profile',
              'Offers and promotions',
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                child: SoftCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(x, style: const TextStyle(fontWeight: FontWeight.w800)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need more help?', style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 5),
                  Text('Chat with P-Ride support in this UI prototype.', style: TextStyle(color: AppColors.muted)),
                  SizedBox(height: 12),
                  OutlinedButton(onPressed: null, child: Text('Contact support')),
                ],
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared row widgets
// ─────────────────────────────────────────────────────────────────────────────

class _RouteLine extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const _RouteLine({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext c) => Row(
        children: [
          Icon(icon, color: AppColors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      );
}

class _FareRow extends StatelessWidget {
  final String a, b;
  final bool strong;
  const _FareRow(this.a, this.b, {this.strong = false});

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(a, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w500))),
            Text(b, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w700, fontSize: strong ? 18 : 14)),
          ],
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final String a, b;
  const _InfoRow(this.a, this.b);

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Expanded(child: Text(a, style: const TextStyle(color: AppColors.muted))),
            const SizedBox(width: 12),
            Text(b, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _DriverCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DriverCard({required this.onTap});

  @override
  Widget build(BuildContext c) => Tappable(
        onTap: onTap,
        child: const SoftCard(
          child: Row(
            children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.navy, child: Icon(Icons.person, color: Colors.white)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amit Patil', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    Text('4.9 ★ • Maruti Suzuki Dzire', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    Text('MH 12 KT 4821', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
}

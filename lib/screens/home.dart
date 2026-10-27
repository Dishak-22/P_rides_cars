import 'package:flutter/material.dart';
import 'package:p_ride/navigation/app_routes.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/responsive.dart';
import 'offers.dart';
import 'profile.dart';
import 'ride_history.dart';

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
                  RideCard(r),
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

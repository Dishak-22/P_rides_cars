import 'package:flutter/material.dart';
import 'package:p_ride/prime/config.dart';
import 'package:p_ride/prime/models.dart';
import 'package:p_ride/prime/offers_repo.dart';
import 'package:p_ride/prime/screens/auth.dart';
import 'package:p_ride/prime/screens/booking_form.dart';
import 'package:p_ride/prime/store.dart';
import 'package:p_ride/prime/theme.dart';
import 'package:p_ride/prime/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: AppStore.instance.name);
  late final TextEditingController _email =
      TextEditingController(text: AppStore.instance.email);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await AppStore.instance.saveProfile(_name.text.trim(), _email.text.trim());
    if (mounted) snack(context, 'Profile saved');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: SafeArea(
          child: Form(
            key: _form,
            child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  const Center(
                      child: CircleAvatar(
                          radius: 42,
                          backgroundColor: P.navy,
                          child: Icon(Icons.person_rounded,
                              color: Colors.white, size: 44))),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v ?? '').trim().length < 2 ? 'Enter your name' : null,
                    decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_rounded)),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: '+91 ${AppStore.instance.phone}',
                    enabled: false,
                    decoration: const InputDecoration(
                        labelText: 'Mobile number',
                        prefixIcon: Icon(Icons.phone_rounded)),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return null;
                      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
                          ? null
                          : 'Enter a valid email';
                    },
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_rounded)),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                      onPressed: _save, child: const Text('Save changes')),
                ]),
          ),
        ),
      );
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late Future<List<Offer>> _future = OfferRepo.load();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Offers & Packages')),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() => _future = OfferRepo.load());
            await _future;
          },
          child: FutureBuilder<List<Offer>>(
            future: _future,
            builder: (context, snap) {
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final o = list[i];
                  return Panel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (o.imageUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(o.imageUrl,
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const SizedBox.shrink()),
                              ),
                            ),
                          Text(o.tag,
                              style: const TextStyle(
                                  color: P.blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .7)),
                          const SizedBox(height: 4),
                          Text(o.title,
                              style: const TextStyle(
                                  color: P.navy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(o.subtitle,
                              style:
                                  const TextStyle(color: P.muted, height: 1.4)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(130, 40)),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          BookingFormScreen(type: o.trip))),
                              child: const Text('Book Now'),
                            ),
                          ),
                        ]),
                  );
                },
              );
            },
          ),
        ),
      );
}

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _items = <(IconData, String, String, TripType)>[
    (
      Icons.flight_takeoff_rounded,
      'Airport transfers',
      'Pune airport pickup and drop, any time.',
      TripType.airport
    ),
    (
      Icons.arrow_forward_rounded,
      'One-way drops',
      'City and outstation drops. Pay one direction only.',
      TripType.oneWay
    ),
    (
      Icons.sync_alt_rounded,
      'Round trips',
      'Outstation trips with return journey.',
      TripType.roundTrip
    ),
    (
      Icons.schedule_rounded,
      'Hourly rentals',
      '4, 8 and 12 hour packages with driver.',
      TripType.hourly
    ),
    (
      Icons.landscape_rounded,
      'Tour packages',
      'Weekend getaways and seasonal packages.',
      TripType.roundTrip
    ),
    (
      Icons.favorite_rounded,
      'Weddings & events',
      'Cars and tempo travellers for functions.',
      TripType.hourly
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Our Services')),
        body: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final it = _items[i];
            return Panel(
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FF),
                        borderRadius: BorderRadius.circular(14)),
                    child: Icon(it.$1, color: P.blue),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.$2,
                              style: const TextStyle(
                                  color: P.navy, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(it.$3,
                              style: const TextStyle(
                                  color: P.muted, fontSize: 12)),
                        ]),
                  ),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 40)),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => BookingFormScreen(type: it.$4))),
                    child: const Text('Book Now'),
                  ),
                ),
              ]),
            );
          },
        ),
      );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Panel(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  ListTile(
                    leading: const Icon(Icons.chat_rounded, color: P.green),
                    title: const Text('Chat on WhatsApp',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text(AppConfig.phoneDisplay),
                    onTap: () => openWhatsApp(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.call_rounded, color: P.blue),
                    title: const Text('Call support',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text(AppConfig.phoneDisplay),
                    onTap: () => callSupport(context),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: P.muted),
                    title: Text('About',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${AppConfig.businessName} • v1.0.0'),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: P.red,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () async {
                  await AppStore.instance.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (r) => false);
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
            ]),
      );
}

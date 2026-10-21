import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'payment.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key, required this.type});
  final TripType type;
  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name, _contact, _email, _pickup, _drop, _note;
  DateTime? _pickupAt, _returnAt;
  Vehicle? _vehicle;
  bool _submitted = false;
  int _package = 0; // hourly
  int _airportDir = 0; // 0 = from airport, 1 = to airport

  static const _packages = ['4 hrs / 40 km', '8 hrs / 80 km', '12 hrs / 120 km'];
  static const _airport = 'Pune Airport (Lohegaon)';

  TripType get type => widget.type;

  @override
  void initState() {
    super.initState();
    final s = AppStore.instance;
    _name = TextEditingController(text: s.name);
    _contact = TextEditingController(text: s.phone);
    _email = TextEditingController(text: s.email);
    _pickup = TextEditingController(text: type == TripType.airport ? _airport : '');
    _drop = TextEditingController();
    _note = TextEditingController();
  }

  @override
  void dispose() {
    for (final c in [_name, _contact, _email, _pickup, _drop, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final start = _pickupAt ?? now.add(const Duration(hours: 2));
    final d = await showDatePicker(
      context: context,
      initialDate: start.isBefore(now) ? now : start,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(start));
    if (t == null || !mounted) return;
    setState(() => _pickupAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  Future<void> _pickReturn() async {
    final base = _pickupAt ?? DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _returnAt ?? base,
      firstDate: DateTime(base.year, base.month, base.day),
      lastDate: base.add(const Duration(days: 60)),
    );
    if (d != null) setState(() => _returnAt = d);
  }

  void _setAirportDir(int i) {
    setState(() {
      _airportDir = i;
      if (i == 0) {
        _pickup.text = _airport;
        if (_drop.text == _airport) _drop.clear();
      } else {
        _drop.text = _airport;
        if (_pickup.text == _airport) _pickup.clear();
      }
    });
  }

  String get _extra {
    switch (type) {
      case TripType.hourly:
        return _packages[_package];
      case TripType.roundTrip:
        return _returnAt == null ? '' : 'Return ${fmtDate(_returnAt!)}';
      case TripType.airport:
        return _airportDir == 0 ? 'Airport pickup' : 'Airport drop';
      case TripType.oneWay:
        return '';
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    final okForm = _form.currentState!.validate();
    final okDate = _pickupAt != null && _pickupAt!.isAfter(DateTime.now());
    final okRet = type != TripType.roundTrip || _returnAt != null;
    if (!okForm || !okDate || !okRet || _vehicle == null) {
      snack(context, _vehicle == null ? 'Please choose a vehicle' : 'Please complete the highlighted fields');
      return;
    }
    final v = _vehicle!;
    final booking = Booking(
      id: 'PRP${DateTime.now().millisecondsSinceEpoch % 100000000}',
      userPhone: AppStore.instance.phone,
      type: type,
      name: _name.text.trim(),
      contact: _contact.text.trim(),
      email: _email.text.trim(),
      pickupAt: _pickupAt!,
      pickup: _pickup.text.trim(),
      drop: _drop.text.trim(),
      vehicle: v.name,
      seats: v.seats,
      note: _note.text.trim(),
      extra: _extra,
      amount: AppConfig.fare,
      createdAt: DateTime.now(),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PaymentScreen(booking: booking)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Book • ${type.title}')),
        body: SafeArea(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
              children: [
                _field(_name, 'Name', Icons.person_rounded, validator: (v) => (v ?? '').trim().length < 2 ? 'Enter your name' : null),
                _field(_contact, 'Contact number', Icons.phone_rounded,
                    keyboard: TextInputType.phone,
                    formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    validator: (v) => RegExp(r'^\d{10}$').hasMatch((v ?? '').trim()) ? null : 'Enter a 10-digit number'),
                _field(_email, 'Email', Icons.mail_rounded,
                    keyboard: TextInputType.emailAddress,
                    validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim()) ? null : 'Enter a valid email'),
                if (type == TripType.airport) ...[
                  const SizedBox(height: 2),
                  Row(children: [
                    Expanded(child: _dirChip('From airport', 0)),
                    const SizedBox(width: 10),
                    Expanded(child: _dirChip('To airport', 1)),
                  ]),
                  const SizedBox(height: 14),
                ],
                _picker('Pickup date & time', Icons.event_rounded, _pickupAt == null ? null : fmtDateTime(_pickupAt!), _pickDateTime,
                    error: _submitted && (_pickupAt == null || !_pickupAt!.isAfter(DateTime.now()))
                        ? (_pickupAt == null ? 'Select pickup date & time' : 'Pickup must be in the future')
                        : null),
                if (type == TripType.roundTrip)
                  _picker('Return date', Icons.event_repeat_rounded, _returnAt == null ? null : fmtDate(_returnAt!), _pickReturn,
                      error: _submitted && _returnAt == null ? 'Select return date' : null),
                if (type == TripType.hourly) ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Rental package', style: TextStyle(color: P.navy, fontWeight: FontWeight.w800)),
                  ),
                  Wrap(spacing: 8, runSpacing: 4, children: [
                    for (var i = 0; i < _packages.length; i++)
                      ChoiceChip(label: Text(_packages[i]), selected: _package == i, onSelected: (_) => setState(() => _package = i)),
                  ]),
                  const SizedBox(height: 14),
                ],
                _field(_pickup, 'Pickup location', Icons.my_location_rounded,
                    validator: (v) => (v ?? '').trim().length < 3 ? 'Enter pickup location' : null),
                _field(_drop, type == TripType.hourly ? 'Drop location (optional)' : 'Drop location', Icons.location_on_rounded,
                    validator: type == TripType.hourly ? null : (v) => (v ?? '').trim().length < 3 ? 'Enter drop location' : null),
                const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 10),
                  child: Text('Vehicle type', style: TextStyle(color: P.navy, fontSize: 16, fontWeight: FontWeight.w900)),
                ),
                SizedBox(
                  height: 132,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _VehicleTile(
                      v: vehicles[i],
                      selected: _vehicle == vehicles[i],
                      onTap: () => setState(() => _vehicle = vehicles[i]),
                    ),
                  ),
                ),
                if (_vehicle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(children: [
                      const Icon(Icons.airline_seat_recline_normal_rounded, size: 18, color: P.blue),
                      const SizedBox(width: 6),
                      Text('${_vehicle!.name} • ${_vehicle!.seats} seater (${_vehicle!.model})',
                          style: const TextStyle(color: P.blue, fontWeight: FontWeight.w800, fontSize: 13)),
                    ]),
                  ),
                if (_submitted && _vehicle == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Please choose a vehicle', style: TextStyle(color: P.red, fontSize: 12)),
                  ),
                const SizedBox(height: 18),
                _field(_note, 'Special note (optional)', Icons.edit_note_rounded, lines: 3),
                const SizedBox(height: 4),
                ElevatedButton(onPressed: _submit, child: const Text('Book Now')),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Fixed fare ₹${AppConfig.fare} • payable on the next page', style: TextStyle(color: P.muted, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _dirChip(String label, int i) => ChoiceChip(
        label: SizedBox(width: double.infinity, child: Text(label, textAlign: TextAlign.center)),
        selected: _airportDir == i,
        onSelected: (_) => _setAirportDir(i),
      );

  Widget _field(TextEditingController c, String label, IconData icon,
      {String? Function(String?)? validator, TextInputType? keyboard, List<TextInputFormatter>? formatters, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        inputFormatters: formatters,
        maxLines: lines,
        textCapitalization: keyboard == TextInputType.emailAddress ? TextCapitalization.none : TextCapitalization.sentences,
        validator: validator,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }

  Widget _picker(String label, IconData icon, String? value, VoidCallback onTap, {String? error}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), errorText: error),
            child: Text(value ?? 'Tap to select',
                style: TextStyle(color: value == null ? P.muted : P.navy, fontWeight: FontWeight.w600)),
          ),
        ),
      );
}

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({required this.v, required this.selected, required this.onTap});
  final Vehicle v;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 124,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEAF0FF) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? P.blue : P.line, width: selected ? 2 : 1),
          ),
          child: Stack(children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 52, child: VehicleArt(v)),
              const SizedBox(height: 8),
              Text(v.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: P.navy, fontWeight: FontWeight.w900, fontSize: 13)),
              const SizedBox(height: 2),
              Text('${v.seats} Seater', style: const TextStyle(color: P.muted, fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
            if (selected)
              const Positioned(top: 0, right: 0, child: Icon(Icons.check_circle_rounded, color: P.blue, size: 20)),
          ]),
        ),
      );
}

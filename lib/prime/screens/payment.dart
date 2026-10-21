import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.booking});
  final Booking booking;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? _rz;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (!AppConfig.demoPayment) {
      _rz = Razorpay()
        ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
        ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError)
        ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onWallet);
    }
  }

  @override
  void dispose() {
    _rz?.clear();
    super.dispose();
  }

  Future<void> _finish(String paymentId) async {
    final done = widget.booking.copyWith(paymentId: paymentId, status: 'Confirmed');
    await AppStore.instance.addBooking(done);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => SuccessScreen(booking: done)), (r) => false);
  }

  void _onSuccess(PaymentSuccessResponse r) => _finish(r.paymentId ?? 'pay_unknown');

  void _onError(PaymentFailureResponse r) {
    if (!mounted) return;
    setState(() => _busy = false);
    snack(context, 'Payment failed or cancelled. ${r.message ?? ''}'.trim());
  }

  void _onWallet(ExternalWalletResponse r) {
    if (mounted) snack(context, 'Continuing with ${r.walletName ?? 'wallet'}…');
  }

  Future<void> _pay() async {
    final b = widget.booking;
    if (AppConfig.demoPayment) {
      final ok = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _DemoCheckout(amount: b.amount, phone: b.contact),
      );
      if (ok == true) await _finish('pay_demo_${DateTime.now().millisecondsSinceEpoch}');
      return;
    }
    setState(() => _busy = true);
    try {
      _rz!.open({
        'key': AppConfig.razorpayKey,
        'amount': b.amount * 100, // in paise
        'currency': 'INR',
        'name': AppConfig.businessName,
        'description': '${b.type.title} • ${b.vehicle}',
        'prefill': {'contact': b.contact, 'email': b.email, 'name': b.name},
        'theme': {'color': '#2457E6'},
      });
    } catch (e) {
      setState(() => _busy = false);
      snack(context, 'Could not start payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 20), children: [
              _razorpayCard(b),
              const SizedBox(height: 16),
              const Text('Final booking details', style: TextStyle(color: P.navy, fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Panel(child: BookingDetails(b)),
              const SizedBox(height: 14),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_rounded, size: 14, color: P.muted),
                SizedBox(width: 6),
                Text('Payments are secured by Razorpay', style: TextStyle(color: P.muted, fontSize: 12)),
              ]),
              if (AppConfig.demoPayment)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Center(child: Text('Demo mode: no real money is charged', style: TextStyle(color: P.muted, fontSize: 11))),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
            child: ElevatedButton(
              onPressed: _busy ? null : _pay,
              child: _busy
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text('Pay ₹${b.amount} & Book Ride'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _razorpayCard(Booking b) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: P.line),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            color: const Color(0xFF0B1F3A),
            child: Row(children: [
              const BrandLogo(size: 44, radius: 12),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppConfig.businessName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: .8)),
                  SizedBox(height: 2),
                  Text('Ride booking payment', style: TextStyle(color: Color(0xFFB9C7DD), fontSize: 12)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('Amount', style: TextStyle(color: Color(0xFFB9C7DD), fontSize: 11)),
                Text('₹${b.amount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
              ]),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 14, 18, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Fixed fare on every ride', style: TextStyle(color: P.green, fontWeight: FontWeight.w800, fontSize: 12)),
            ),
          ),
          const _Method(Icons.qr_code_2_rounded, 'UPI', 'Google Pay • PhonePe • Paytm • BHIM'),
          const _Method(Icons.credit_card_rounded, 'Cards', 'Visa • Mastercard • RuPay'),
          const _Method(Icons.account_balance_rounded, 'Netbanking', 'All major banks'),
          const _Method(Icons.account_balance_wallet_rounded, 'Wallets', 'Choose at checkout'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFFF4F7FC),
            child: const Center(
              child: Text('Secured by Razorpay', style: TextStyle(color: P.muted, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      );
}

class _Method extends StatelessWidget {
  const _Method(this.icon, this.title, this.sub);
  final IconData icon;
  final String title, sub;
  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: const Color(0xFFEAF0FF), borderRadius: BorderRadius.circular(11)),
          child: Icon(icon, color: P.blue, size: 21),
        ),
        title: Text(title, style: const TextStyle(color: P.navy, fontWeight: FontWeight.w800)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, color: P.muted),
      );
}

/// Simulated Razorpay sheet, only used while no real key is set.
class _DemoCheckout extends StatefulWidget {
  const _DemoCheckout({required this.amount, required this.phone});
  final int amount;
  final String phone;
  @override
  State<_DemoCheckout> createState() => _DemoCheckoutState();
}

class _DemoCheckoutState extends State<_DemoCheckout> {
  int _sel = 0;
  bool _paying = false;
  static const _m = ['UPI', 'Card', 'Netbanking', 'Wallet'];

  Future<void> _go() async {
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
        child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: P.line, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 14),
            Row(children: [
              const BrandLogo(size: 36, radius: 10),
              const SizedBox(width: 10),
              const Expanded(child: Text(AppConfig.businessName, style: TextStyle(color: P.navy, fontWeight: FontWeight.w900))),
              Text('₹${widget.amount}', style: const TextStyle(color: P.navy, fontWeight: FontWeight.w900, fontSize: 20)),
            ]),
            const SizedBox(height: 4),
            Text('+91 ${widget.phone}', style: const TextStyle(color: P.muted, fontSize: 12)),
            const SizedBox(height: 14),
            for (var i = 0; i < _m.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: _sel,
                onChanged: _paying ? null : (v) => setState(() => _sel = v ?? 0),
                contentPadding: EdgeInsets.zero,
                title: Text(_m[i], style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _paying ? null : _go,
              child: _paying
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text('Pay ₹${widget.amount}'),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('DEMO • Secured by Razorpay', style: TextStyle(color: P.muted, fontSize: 11))),
          ]),
        ),
      );
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(22), children: [
            const SizedBox(height: 10),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: const BoxDecoration(color: Color(0xFFE3F8EC), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: P.green, size: 54),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Center(child: Text('Ride booked!', style: TextStyle(color: P.navy, fontSize: 27, fontWeight: FontWeight.w900))),
            const SizedBox(height: 6),
            Center(child: Text('Booking ID: ${booking.id}', style: const TextStyle(color: P.muted, fontWeight: FontWeight.w700))),
            const SizedBox(height: 20),
            Panel(child: BookingDetails(booking)),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: P.green),
              onPressed: () => openWhatsApp(context, text: booking.whatsappText),
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Send details on WhatsApp'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
              child: const Text('Back to Home'),
            ),
          ]),
        ),
      );
}

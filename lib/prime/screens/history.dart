import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Booking History')),
        body: ListenableBuilder(
          listenable: AppStore.instance,
          builder: (context, _) {
            final list = AppStore.instance.bookings;
            if (list.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.receipt_long_rounded, size: 64, color: P.line),
                    SizedBox(height: 12),
                    Text('No bookings yet', style: TextStyle(color: P.navy, fontSize: 18, fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Your confirmed rides will appear here.', style: TextStyle(color: P.muted)),
                  ]),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _BookingCard(list[i]),
            );
          },
        ),
      );
}

class _BookingCard extends StatelessWidget {
  const _BookingCard(this.b);
  final Booking b;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (_) => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Booking ${b.id}', style: const TextStyle(color: P.navy, fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 10),
                BookingDetails(b),
                if (b.paymentId.isNotEmpty) InfoRow('Payment ID', b.paymentId),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: P.green),
                  onPressed: () => openWhatsApp(context, text: b.whatsappText),
                  icon: const Icon(Icons.chat_rounded),
                  label: const Text('Share on WhatsApp'),
                ),
              ]),
            ),
          ),
        ),
        child: Panel(
          child: Column(children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: b.type.color.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                child: Icon(b.type.icon, color: b.type.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.type.title, style: const TextStyle(color: P.navy, fontWeight: FontWeight.w900)),
                  Text(fmtDateTime(b.pickupAt), style: const TextStyle(color: P.muted, fontSize: 12)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${b.amount}', style: const TextStyle(color: P.navy, fontWeight: FontWeight.w900)),
                Text(b.status, style: const TextStyle(color: P.green, fontSize: 11, fontWeight: FontWeight.w800)),
              ]),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.trip_origin_rounded, size: 14, color: P.muted),
              const SizedBox(width: 6),
              Expanded(child: Text(b.drop.isEmpty ? b.pickup : '${b.pickup} → ${b.drop}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: P.muted))),
            ]),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${b.vehicle} • ${b.seats} seater • ${b.id}', style: const TextStyle(fontSize: 11, color: P.muted)),
            ),
          ]),
        ),
      );
}

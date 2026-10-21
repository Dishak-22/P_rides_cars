import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'models.dart';
import 'theme.dart';

void snack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
}

Future<void> openWhatsApp(BuildContext context, {String? text}) async {
  final q = text == null ? '' : '?text=${Uri.encodeComponent(text)}';
  final uri = Uri.parse('https://wa.me/${AppConfig.whatsapp}$q');
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) snack(context, 'Could not open WhatsApp');
  } catch (_) {
    if (context.mounted) snack(context, 'Could not open WhatsApp');
  }
}

Future<void> callSupport(BuildContext context) async {
  try {
    final ok = await launchUrl(Uri.parse('tel:+${AppConfig.whatsapp}'));
    if (!ok && context.mounted) snack(context, 'Could not open dialer');
  } catch (_) {
    if (context.mounted) snack(context, 'Could not open dialer');
  }
}

/// Business logo (from assets) with a safe fallback icon.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 44, this.radius = 14});
  final double size, radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/logo prime ride car.jpeg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: P.blue,
            child: Icon(Icons.directions_car_filled_rounded, color: Colors.white, size: size * .55),
          ),
        ),
      );
}

/// White rounded card used across pages.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: P.line),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .03), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: child,
      );
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key, this.bold = false});
  final String label, value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 108, child: Text(label, style: const TextStyle(color: P.muted, fontSize: 13))),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(color: P.navy, fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
          ),
        ]),
      );
}

/// Vehicle picture: real photo if imageUrl is set, else a drawn car.
class VehicleArt extends StatelessWidget {
  const VehicleArt(this.v, {super.key});
  final Vehicle v;

  @override
  Widget build(BuildContext context) {
    if (v.imageUrl.isNotEmpty) {
      return Image.network(v.imageUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => CarArt(kind: v.kind, color: v.color));
    }
    return CarArt(kind: v.kind, color: v.color);
  }
}

class CarArt extends StatelessWidget {
  const CarArt({super.key, required this.kind, required this.color});
  final int kind;
  final Color color;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 2.2,
        child: CustomPaint(painter: _CarPainter(kind, color)),
      );
}

class _CarPainter extends CustomPainter {
  _CarPainter(this.kind, this.color);
  final int kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    // cabin back x, cabin front x, roof y (fractions)
    final cfg = const [
      [0.24, 0.72, 0.22], // hatch
      [0.26, 0.66, 0.26], // sedan
      [0.14, 0.76, 0.14], // suv
      [0.06, 0.86, 0.10], // van
    ][kind.clamp(0, 3).toInt()];
    final back = cfg[0] * w, front = cfg[1] * w, roof = cfg[2] * h;
    final beltY = h * 0.52, bottomY = h * 0.82;

    // ground shadow
    canvas.drawOval(
      Rect.fromLTWH(w * .04, bottomY + h * .06, w * .92, h * .1),
      Paint()..color = Colors.black.withValues(alpha: .12),
    );

    final body = Paint()..color = color;
    final dark = Paint()..color = Color.alphaBlend(Colors.black.withValues(alpha: .18), color);

    // cabin
    final cabin = Path()
      ..moveTo(back - w * .03, beltY)
      ..lineTo(back + w * .06, roof)
      ..lineTo(front - w * .07, roof)
      ..lineTo(front + w * .05, beltY)
      ..close();
    canvas.drawPath(cabin, body);

    // windows
    final win = Paint()..color = const Color(0xFFDCEBFF);
    final windows = Path()
      ..moveTo(back + w * .005, beltY - h * .03)
      ..lineTo(back + w * .075, roof + h * .07)
      ..lineTo(front - w * .075, roof + h * .07)
      ..lineTo(front + w * .015, beltY - h * .03)
      ..close();
    canvas.drawPath(windows, win);
    final mid = (back + front) / 2;
    canvas.drawLine(Offset(mid, roof + h * .07), Offset(mid + w * .005, beltY - h * .03),
        Paint()..color = color..strokeWidth = w * .015);
    if (kind >= 2) {
      final mid2 = back + (front - back) * .28;
      canvas.drawLine(Offset(mid2, roof + h * .07), Offset(mid2, beltY - h * .03),
          Paint()..color = color..strokeWidth = w * .012);
    }

    // body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(w * .03, beltY - h * .02, w * .97, bottomY), Radius.circular(h * .12)),
      body,
    );
    // lower trim
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(w * .05, bottomY - h * .09, w * .95, bottomY), Radius.circular(h * .05)),
      dark,
    );
    // lights
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .915, beltY + h * .02, w * .05, h * .08), Radius.circular(h * .03)),
      Paint()..color = const Color(0xFFFFE27A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * .035, beltY + h * .02, w * .04, h * .08), Radius.circular(h * .03)),
      Paint()..color = const Color(0xFFFF5A5A),
    );
    // door line
    canvas.drawLine(Offset(mid, beltY), Offset(mid, bottomY - h * .1),
        Paint()..color = Colors.black.withValues(alpha: .15)..strokeWidth = 1.2);

    // wheels
    final r = h * .15;
    for (final cx in [w * .23, w * .77]) {
      canvas.drawCircle(Offset(cx, bottomY), r, Paint()..color = const Color(0xFF1B2433));
      canvas.drawCircle(Offset(cx, bottomY), r * .55, Paint()..color = const Color(0xFFC9D2E0));
      canvas.drawCircle(Offset(cx, bottomY), r * .2, Paint()..color = const Color(0xFF1B2433));
    }
  }

  @override
  bool shouldRepaint(covariant _CarPainter old) => old.kind != kind || old.color != color;
}

/// Booking summary rows (used on payment, success and history pages).
class BookingDetails extends StatelessWidget {
  const BookingDetails(this.b, {super.key});
  final Booking b;

  @override
  Widget build(BuildContext context) => Column(children: [
        InfoRow('Trip type', b.extra.isEmpty ? b.type.title : '${b.type.title} (${b.extra})'),
        InfoRow('Name', b.name),
        InfoRow('Contact', b.contact),
        InfoRow('Email', b.email),
        InfoRow('Pickup time', fmtDateTime(b.pickupAt)),
        InfoRow('Pickup', b.pickup),
        if (b.drop.isNotEmpty) InfoRow('Drop', b.drop),
        InfoRow('Vehicle', '${b.vehicle} • ${b.seats} seater'),
        if (b.note.isNotEmpty) InfoRow('Note', b.note),
        const Divider(height: 22),
        InfoRow('Fare', '₹${b.amount}', bold: true),
      ]);
}

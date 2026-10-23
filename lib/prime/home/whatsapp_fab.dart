import 'package:flutter/material.dart';
import '../config.dart';
import '../theme.dart';
import '../widgets.dart';

/// Green WhatsApp button with a very subtle floating motion.
/// Number comes from AppConfig.whatsapp; message from AppConfig.whatsappGreeting.
class WhatsAppFab extends StatefulWidget {
  const WhatsAppFab({super.key});
  @override
  State<WhatsAppFab> createState() => _WhatsAppFabState();
}

class _WhatsAppFabState extends State<WhatsAppFab> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) {
      _c.stop();
      _started = false;
    } else if (!_started) {
      _c.repeat(reverse: true);
      _started = true;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: 58,
      height: 58,
      child: FloatingActionButton(
        heroTag: 'wa',
        tooltip: 'Chat on WhatsApp',
        backgroundColor: P.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () => openWhatsApp(context, text: AppConfig.whatsappGreeting),
        child: const _WhatsAppGlyph(),
      ),
    );
    if (MediaQuery.of(context).disableAnimations) return button;
    return AnimatedBuilder(
      animation: _c,
      child: button,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -3 * Curves.easeInOut.transform(_c.value)),
        child: child,
      ),
    );
  }
}

/// Speech-bubble + handset glyph (Flutter has no built-in WhatsApp icon).
class _WhatsAppGlyph extends StatelessWidget {
  const _WhatsAppGlyph();
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 32,
        height: 32,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(size: const Size(32, 32), painter: _BubblePainter()),
          const Icon(Icons.call_rounded, color: Colors.white, size: 17),
        ]),
      );
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final c = Offset(s.width / 2, s.height / 2);
    final r = s.width / 2 - 2;
    final path = Path()
      ..moveTo(c.dx - r * .72, c.dy + r * .72)
      ..lineTo(c.dx - r * 1.0, c.dy + r * 1.05)
      ..lineTo(c.dx - r * .35, c.dy + r * .92);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -2.2, 5.6, false, p);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

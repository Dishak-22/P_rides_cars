import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// Background media for the promo banner.
///
/// Order of preference:
///   1. [mediaUrl]  - image/GIF uploaded by the admin (Supabase Storage)
///   2. the bundled car GIF at [bundledGif] (only if it exists in the app)
///   3. [fallback] - the built-in gradient + animated car drawing
///
/// GIFs keep animating and loop automatically. A navy gradient is drawn over
/// real media so white text stays readable.
class PromoBackdrop extends StatelessWidget {
  const PromoBackdrop({super.key, required this.mediaUrl, required this.fallback});

  final String mediaUrl;
  final Widget fallback;

  /// Put your car GIF here and list it under `assets:` in pubspec.yaml.
  static const bundledGif = 'assets/images/car_banner.gif';

  static Future<bool>? _bundledCheck;
  static Future<bool> _hasBundledGif() => _bundledCheck ??= () async {
        try {
          final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
          return manifest.listAssets().contains(bundledGif);
        } catch (_) {
          return false;
        }
      }();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      // Decode at display size, not full size: big GIFs otherwise eat memory.
      final cacheW = c.maxWidth.isFinite ? (c.maxWidth * dpr).round() : null;

      // Reduced-motion setting on: skip the moving GIF, show the calm static artwork.
      if (MediaQuery.disableAnimationsOf(context)) return fallback;

      if (mediaUrl.isNotEmpty) {
        return _withOverlay(Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: cacheW,
          gaplessPlayback: true,
          excludeFromSemantics: true,
          errorBuilder: (_, __, ___) => fallback,
          loadingBuilder: (_, child, progress) => progress == null ? child : fallback,
        ));
      }

      return FutureBuilder<bool>(
        future: _hasBundledGif(),
        builder: (_, snap) {
          if (snap.data != true) return fallback;
          return _withOverlay(Image.asset(
            bundledGif,
            fit: BoxFit.cover,
            alignment: const Alignment(0, .2), // keep grille + headlight in view
            width: double.infinity,
            height: double.infinity,
            cacheWidth: cacheW,
            gaplessPlayback: true,
            excludeFromSemantics: true,
            errorBuilder: (_, __, ___) => fallback,
          ));
        },
      );
    });
  }

  Widget _withOverlay(Widget media) => Stack(fit: StackFit.expand, children: [
        media,
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xE60B1F3A), Color(0x990B1F3A), Color(0x330B1F3A)],
              stops: [0, .55, 1],
            ),
          ),
        ),
      ]);
}

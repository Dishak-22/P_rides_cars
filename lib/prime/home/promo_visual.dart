import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// The animated car picture on the right-hand side of a promo banner.
///
/// Order of preference:
///   1. [mediaUrl]  - image/GIF uploaded by the admin (Supabase Storage)
///   2. the bundled car GIF at [bundledGif]
///   3. [fallback]  - the built-in drawn car
///
/// The picture is shown with BoxFit.cover (never stretched) and its left edge
/// fades into the banner colour, so it never competes with the text.
class PromoVisual extends StatelessWidget {
  const PromoVisual({
    super.key,
    required this.mediaUrl,
    required this.fallback,
    this.alignment = Alignment.topCenter,
    this.fadeLeft = true,
  });

  final String mediaUrl;
  final Widget fallback;

  /// Which part of the picture stays visible when it is cropped to fit.
  final Alignment alignment;

  /// Fade the left edge into the background (side-panel layout).
  final bool fadeLeft;

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
    // Reduced-motion setting on: skip the moving GIF and show calm static artwork.
    if (MediaQuery.disableAnimationsOf(context)) return fallback;

    return LayoutBuilder(builder: (context, c) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      // Decode at display size, not larger: keeps GIF memory use down.
      final cacheW = c.maxWidth.isFinite ? (c.maxWidth * dpr).round() : null;

      if (mediaUrl.isNotEmpty) {
        return _fade(Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          alignment: alignment,
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
          return _fade(Image.asset(
            bundledGif,
            fit: BoxFit.cover,
            alignment: alignment,
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

  /// Fades the picture's left edge into the banner gradient.
  Widget _fade(Widget media) => !fadeLeft ? media : ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
          stops: [0, .42],
        ).createShader(rect),
        child: media,
      );
}

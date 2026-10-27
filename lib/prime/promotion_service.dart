import 'package:flutter/foundation.dart';
import 'models.dart';
import 'supabase_service.dart';

/// Loads admin-managed promotions for the home banner from Supabase.
///
/// Table:   public.offers        (only published + in-schedule rows are shown)
/// Bucket:  offer-media          (public; images / GIFs uploaded by admins)
///
/// Returns null when Supabase is unreachable or the table is missing, so the
/// caller can fall back to the built-in defaults. Returns an empty list when
/// nothing is published.
class PromotionService {
  PromotionService._();

  static const _table = 'offers';
  static const _bucket = 'offer-media';

  static Future<List<Offer>?> load() async {
    try {
      final rows = await SupabaseService.client
          .from(_table)
          .select() // all columns, so it still works if optional columns (e.g. button_text) are missing
          .eq('is_published', true)
          .order('display_order', ascending: true)
          .limit(12)
          .timeout(const Duration(seconds: 8));

      final now = DateTime.now().toUtc();
      final out = <Offer>[];
      for (final r in rows) {
        final start = DateTime.tryParse('${r['starts_at'] ?? ''}');
        final end = DateTime.tryParse('${r['ends_at'] ?? ''}');
        if (start != null && start.toUtc().isAfter(now)) continue; // not started
        if (end != null && end.toUtc().isBefore(now)) continue; // expired

        final title = '${r['title'] ?? ''}'.trim();
        if (title.isEmpty) continue;
        final button = '${r['button_text'] ?? ''}'.trim();
        out.add(Offer(
          title,
          '${r['subtitle'] ?? ''}',
          '${r['tag'] ?? 'SPECIAL OFFER'}',
          imageUrl: _mediaUrl('${r['media_path'] ?? ''}'),
          trip: tripTypeFromName('${r['trip_type'] ?? ''}'),
          buttonText: button.isEmpty ? 'Book Now' : button,
          promoCode: '${r['promo_code'] ?? ''}'.trim(),
          destination: '${r['destination'] ?? ''}'.trim(),
          validUntil: end == null ? '' : fmtDate(end.toLocal()),
        ));
      }
      return out;
    } catch (e) {
      debugPrint('PromotionService.load failed: $e');
      return null;
    }
  }

  static String _mediaUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    try {
      return SupabaseService.client.storage.from(_bucket).getPublicUrl(path);
    } catch (_) {
      return '';
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'models.dart';

/// Offers shown in the home slider / Offers page.
/// Admin edits a JSON file hosted online (AppConfig.offersUrl); the app reads it.
class OfferRepo {
  static const defaults = <Offer>[
    Offer('Monsoon Special: Lonavala', 'Misty roads and green valleys. Weekend round trips from Pune.', 'MONSOON SPECIAL'),
    Offer('Mahabaleshwar Weekend Package', 'Hill-station getaway with a comfortable ride.', 'WEEKEND GETAWAY'),
    Offer('Shirdi & Shani Shingnapur', 'Pilgrimage round trip packages at a fixed fare.', 'DARSHAN PACKAGE'),
    Offer('Airport Transfers 24x7', 'On-time Pune airport pickup and drop.', 'AIRPORT', trip: TripType.airport),
  ];

  static Future<List<Offer>> load() async {
    if (AppConfig.offersUrl.isEmpty) return defaults;
    try {
      final r = await http.get(Uri.parse(AppConfig.offersUrl)).timeout(const Duration(seconds: 8));
      if (r.statusCode != 200) return defaults;
      final data = jsonDecode(utf8.decode(r.bodyBytes));
      final list = (data is Map ? data['offers'] : data) as List;
      final offers = list.map((e) => Offer.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return offers.isEmpty ? defaults : offers;
    } catch (_) {
      return defaults;
    }
  }
}

import 'package:flutter/material.dart';
import '../models.dart';

/// One promotional banner. Edit [PromoSlides.defaults] to change the home carousel.
/// No prices or discount figures are stored here on purpose - only labels you set.
class PromoSlide {
  const PromoSlide({
    required this.heading,
    required this.description,
    required this.trip,
    required this.gradient,
    this.badge = '',
    this.vehicleIndex = 1,
    this.mediaUrl = '',
    this.buttonText = 'Book Now',
    this.promoCode = '',
    this.destination = '',
    this.validUntil = '',
  });

  final String heading;
  final String description;

  /// Booking flow opened by the Book Now button.
  final TripType trip;

  /// Two colours for the banner background (start, end).
  final List<Color> gradient;

  /// Small label at the top of the banner. Leave empty for no badge.
  final String badge;

  /// Index into the `vehicles` list (models.dart) used for the car illustration.
  final int vehicleIndex;

  /// Public URL of an admin-uploaded image/GIF (Supabase Storage). Empty = use bundled GIF or car art.
  final String mediaUrl;

  /// Gold button label, e.g. 'Book Now' or 'Explore Offer'.
  final String buttonText;

  /// Optional extras, shown only in the details sheet when the banner is tapped.
  final String promoCode, destination, validUntil;

  bool get hasDetails => promoCode.isNotEmpty || destination.isNotEmpty || validUntil.isNotEmpty;
}

class PromoSlides {
  PromoSlides._();

  static const _blue = [Color(0xFF123A70), Color(0xFF1769C2)];
  static const _teal = [Color(0xFF0B4F6C), Color(0xFF1B8AA6)];
  static const _indigo = [Color(0xFF1E3A8A), Color(0xFF3F6FD8)];
  static const _slate = [Color(0xFF16324F), Color(0xFF2F6EA8)];

  static const defaults = <PromoSlide>[
    PromoSlide(
      heading: 'Airport Transfers',
      description: 'Reliable airport pickup and drop-off.',
      trip: TripType.airport,
      gradient: _blue,
      badge: 'AIRPORT',
      vehicleIndex: 1,
    ),
    PromoSlide(
      heading: 'Weekend Getaways',
      description: 'Comfortable outstation travel.',
      trip: TripType.oneWay,
      gradient: _teal,
      badge: 'OUTSTATION',
      vehicleIndex: 2,
    ),
    PromoSlide(
      heading: 'Special Offers',
      description: 'Seasonal promotions and discounts.',
      trip: TripType.roundTrip,
      gradient: _indigo,
      badge: 'OFFERS',
      vehicleIndex: 3,
    ),
    PromoSlide(
      heading: 'Book Your Next Ride',
      description: 'Comfortable rides. Trusted drivers. Seamless travel.',
      trip: TripType.roundTrip,
      gradient: _slate,
      badge: 'ROUND TRIP',
      vehicleIndex: 0,
    ),
  ];

  /// Builds slides from remote offers (AppConfig.offersUrl). Falls back to [defaults].
  static List<PromoSlide> fromOffers(List<Offer> offers, {required bool remote}) {
    if (!remote || offers.isEmpty) return defaults;
    const palettes = [_blue, _teal, _indigo, _slate];
    return [
      for (var i = 0; i < offers.length; i++)
        PromoSlide(
          heading: offers[i].title,
          description: offers[i].subtitle,
          trip: offers[i].trip,
          gradient: palettes[i % palettes.length],
          badge: offers[i].tag,
          vehicleIndex: (i + 1) % vehicles.length,
          mediaUrl: offers[i].imageUrl,
          buttonText: offers[i].buttonText,
          promoCode: offers[i].promoCode,
          destination: offers[i].destination,
          validUntil: offers[i].validUntil,
        ),
    ];
  }
}

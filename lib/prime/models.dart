import 'package:flutter/material.dart';

enum TripType { oneWay, hourly, roundTrip, airport }

extension TripTypeX on TripType {
  String get label => const {
        TripType.oneWay: 'ONE WAY',
        TripType.hourly: 'HOURLY RENTAL',
        TripType.roundTrip: 'ROUND TRIP',
        TripType.airport: 'AIRPORT',
      }[this]!;

  String get title => const {
        TripType.oneWay: 'One Way',
        TripType.hourly: 'Hourly Rental',
        TripType.roundTrip: 'Round Trip',
        TripType.airport: 'Airport Transfer',
      }[this]!;

  String get description => const {
        TripType.oneWay: 'Pay only for one direction',
        TripType.hourly: 'Keep a car with driver by the hour',
        TripType.roundTrip: 'Go and return, made easy',
        TripType.airport: 'Airport pickup or drop',
      }[this]!;

  IconData get icon => const {
        TripType.oneWay: Icons.arrow_forward_rounded,
        TripType.hourly: Icons.schedule_rounded,
        TripType.roundTrip: Icons.sync_alt_rounded,
        TripType.airport: Icons.flight_takeoff_rounded,
      }[this]!;

  Color get color => const {
        TripType.oneWay: Color(0xFF1769C2),
        TripType.hourly: Color(0xFFB57F00),
        TripType.roundTrip: Color(0xFF123A70),
        TripType.airport: Color(0xFF0E7C86),
      }[this]!;
}

TripType tripTypeFromName(String? n) =>
    TripType.values.firstWhere((t) => t.name == n, orElse: () => TripType.roundTrip);

class Vehicle {
  final String name;
  final String model;
  final int seats;
  final int kind; // 0 hatch, 1 sedan, 2 suv, 3 van  (drives the drawn picture)
  final Color color;
  final String imageUrl; // optional: real photo URL, overrides the drawing
  const Vehicle(this.name, this.model, this.seats, this.kind, this.color, {this.imageUrl = ''});
}

/// Edit this list to change the vehicles customers can pick.
/// To use real photos set imageUrl: 'https://...'
const vehicles = <Vehicle>[
  Vehicle('Hatchback', 'Swift / WagonR', 4, 0, Color(0xFFE45454)),
  Vehicle('Sedan', 'Dzire / Etios', 4, 1, Color(0xFF1769C2)),
  Vehicle('SUV', 'Ertiga / XL6', 6, 2, Color(0xFF15966B)),
  Vehicle('Innova', 'Innova Crysta', 7, 2, Color(0xFF6B7788)),
  Vehicle('Tempo Traveller', '12 seater van', 12, 3, Color(0xFFE47B22)),
];

class Offer {
  final String title, subtitle, tag, imageUrl, buttonText, promoCode, destination, validUntil;
  final TripType trip;
  const Offer(this.title, this.subtitle, this.tag, {this.imageUrl = '', this.trip = TripType.roundTrip, this.buttonText = 'Book Now', this.promoCode = '', this.destination = '', this.validUntil = ''});

  factory Offer.fromJson(Map<String, dynamic> j) => Offer(
        (j['title'] ?? '').toString(),
        (j['subtitle'] ?? '').toString(),
        (j['tag'] ?? 'SPECIAL OFFER').toString(),
        imageUrl: (j['imageUrl'] ?? '').toString(),
        trip: tripTypeFromName(j['trip']?.toString()),
        buttonText: (j['buttonText'] ?? 'Book Now').toString(),
      );
}

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
}

String fmtDateTime(DateTime d) => '${fmtDate(d)}, ${fmtTime(d)}';

class Booking {
  final String id, userPhone, name, contact, email, pickup, drop, vehicle, note, extra, paymentId, status;
  final TripType type;
  final int seats, amount;
  final DateTime pickupAt, createdAt;

  const Booking({
    required this.id,
    required this.userPhone,
    required this.type,
    required this.name,
    required this.contact,
    required this.email,
    required this.pickupAt,
    required this.pickup,
    required this.drop,
    required this.vehicle,
    required this.seats,
    required this.note,
    required this.extra,
    required this.amount,
    required this.createdAt,
    this.paymentId = '',
    this.status = 'Pending',
  });

  Booking copyWith({String? paymentId, String? status}) => Booking(
        id: id,
        userPhone: userPhone,
        type: type,
        name: name,
        contact: contact,
        email: email,
        pickupAt: pickupAt,
        pickup: pickup,
        drop: drop,
        vehicle: vehicle,
        seats: seats,
        note: note,
        extra: extra,
        amount: amount,
        createdAt: createdAt,
        paymentId: paymentId ?? this.paymentId,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userPhone': userPhone,
        'type': type.name,
        'name': name,
        'contact': contact,
        'email': email,
        'pickupAt': pickupAt.toIso8601String(),
        'pickup': pickup,
        'drop': drop,
        'vehicle': vehicle,
        'seats': seats,
        'note': note,
        'extra': extra,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
        'paymentId': paymentId,
        'status': status,
      };

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
        id: j['id'] as String,
        userPhone: (j['userPhone'] ?? '') as String,
        type: tripTypeFromName(j['type'] as String?),
        name: (j['name'] ?? '') as String,
        contact: (j['contact'] ?? '') as String,
        email: (j['email'] ?? '') as String,
        pickupAt: DateTime.parse(j['pickupAt'] as String),
        pickup: (j['pickup'] ?? '') as String,
        drop: (j['drop'] ?? '') as String,
        vehicle: (j['vehicle'] ?? '') as String,
        seats: (j['seats'] ?? 0) as int,
        note: (j['note'] ?? '') as String,
        extra: (j['extra'] ?? '') as String,
        amount: (j['amount'] ?? 0) as int,
        createdAt: DateTime.parse(j['createdAt'] as String),
        paymentId: (j['paymentId'] ?? '') as String,
        status: (j['status'] ?? 'Pending') as String,
      );

  String get whatsappText {
    String two(int n) => n.toString().padLeft(2, '0');
    final date = '${pickupAt.year}-${two(pickupAt.month)}-${two(pickupAt.day)}';
    final time = '${two(pickupAt.hour)}:${two(pickupAt.minute)}';
    final trip = extra.isEmpty ? type.title : '${type.title} ($extra)';
    return '🚖 *NEW CAB BOOKING*\n\n'
        '👤 Name: $name\n'
        '📞 Mobile: $contact\n'
        '📧 Email: $email\n\n'
        '🚘 Trip Type: $trip\n'
        '🚗 Vehicle: $vehicle ($seats seater)\n\n'
        '📍 Pickup: $pickup\n'
        '${drop.isEmpty ? '' : '📍 Drop: $drop\n'}\n'
        '📅 Date: $date\n'
        '⏰ Time: $time\n\n'
        '💰 Booking advance paid: ₹$amount (Razorpay)\n'
        '🧾 Payment ID: ${paymentId.isEmpty ? '-' : paymentId}\n'
        '🆔 Booking ID: $id\n\n'
        '📝 Message: $note';
  }
}

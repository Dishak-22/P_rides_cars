import 'package:flutter/foundation.dart';

/// ─────────── EDIT THESE VALUES ───────────
class AppConfig {
  static const businessName = 'PRIME RIDES PUNE';
  static const tagline = 'Your ride, your way';

  /// WhatsApp number with country code, digits only.
  static const whatsapp = '919112000112';
  /// First message pre-filled when the customer taps the WhatsApp button.
  static const whatsappGreeting = 'Hello PRIME RIDES PUNE, I need help with a ride.';
  static const phoneDisplay = '+91 91120 00112';

  /// Booking advance amount charged at booking (in rupees).
  static const fare = 1000;

  /// Demo OTP used until a real SMS provider is connected.
  static const demoOtp = '123456';

  /// Put your Razorpay KEY ID here (Dashboard -> Settings -> API Keys).
  /// While it still contains "YOUR_KEY", the app runs a DEMO payment sheet.
  static const razorpayKey = 'rzp_test_YOUR_KEY_HERE';

  /// URL of a JSON file the admin edits to show offers / packages on the
  /// home slider (see offers_sample.json in the project root).
  /// Leave empty to use the built-in sample offers.
  static const offersUrl = '';

  static bool get demoPayment => kIsWeb || razorpayKey.contains('YOUR_KEY');
}

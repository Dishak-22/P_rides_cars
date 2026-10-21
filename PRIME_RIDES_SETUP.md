# PRIME RIDES PUNE – setup notes

1. `flutter pub get`
2. `flutter run`  (or `flutter build apk --release`)

## Things you must edit (lib/prime/config.dart)
- `razorpayKey`  → your Razorpay KEY ID. While it contains "YOUR_KEY" the app shows a DEMO payment sheet.
- `offersUrl`    → link to a hosted JSON file like offers_sample.json. Edit that file to change the home-slider offers/packages.
- `demoOtp`      → demo OTP (123456) until a real SMS OTP service is connected.

## Vehicles
lib/prime/models.dart → `vehicles` list. Add `imageUrl: 'https://...'` to show a real photo instead of the drawn car.

## Before going live
- Create the Razorpay order on a server and verify the payment signature (client-only checkout can be faked).
- Replace demo OTP with a real provider (Firebase Auth phone, MSG91, etc.).
- Bookings are stored on the phone only. To receive them as admin, add a backend (e.g. Firebase). Currently the customer can send details to your WhatsApp from the success page.

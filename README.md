# P-Ride — Pune's Smart Ride

A polished Flutter UI/MVP prototype for a Pune-focused ride-booking application.

## Run
```bash
flutter pub get
flutter run
```

## Release APK
```bash
flutter build apk --release
```

## Scope
- Local/mock data only
- No Firebase, backend, maps API, authentication, payments, driver matching or realtime tracking
- Mock map rendered with Flutter CustomPainter
- Original P-Ride visual system inspired by modern ride-hailing UX patterns

## Demo flow
Splash → Onboarding → Login → OTP → Home → Destination → Ride → Fare → Confirm → Searching → Driver Found → Tracking → Complete → Rating

Secondary screens are accessible from Profile and Home quick actions.

## Responsive layout
The UI adapts to phones, tablets and desktop/web windows.

| Width | Layout |
|---|---|
| < 600 (mobile) | Single column, bottom navigation bar |
| 600–719 (small tablet) | Content centred in a readable column, bottom navigation |
| 720–1199 (tablet / small window) | Side navigation rail, map + details side-by-side on booking screens |
| ≥ 1200 (desktop) | Extended side navigation (icons + labels), wider multi-column lists |

Helpers live in `lib/widgets/responsive.dart`:
`Breakpoints`, `ContentWidth`, `FormScroll`, `CenteredScroll`, `ResponsiveList`, `MapPanelLayout`.

### Run on desktop / web
This project currently only contains the Android platform folder. To try the
desktop and tablet layouts, add the other platforms once:
```bash
flutter create . --platforms=web,windows,macos,linux
flutter run -d chrome      # or -d windows / macos / linux
```
Resize the window to see the layouts switch.

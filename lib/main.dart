import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'prime/config.dart';
import 'prime/screens/auth.dart';
import 'prime/store.dart';
import 'prime/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStore.instance.load();
  runApp(const PrimeRidesApp());
}

class _ScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class PrimeRidesApp extends StatelessWidget {
  const PrimeRidesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.businessName,
        theme: primeTheme(),
        scrollBehavior: _ScrollBehavior(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(textScaler: mq.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.2)),
            child: child!,
          );
        },
        home: const SplashScreen(),
      );
}

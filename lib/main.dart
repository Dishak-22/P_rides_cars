import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(const PRideApp());
}

/// Lets mouse, trackpad and stylus drag-scroll like touch (desktop & web).
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class PRideApp extends StatelessWidget {
  const PRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'P-Ride',
      theme: AppTheme.light,
      scrollBehavior: _AppScrollBehavior(),
      // Keep the layout usable when the user has a very large/small system font.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: mq.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.3)),
          child: child!,
        );
      },
      initialRoute: '/splash',
      onGenerateRoute: AppRoutes.route,
    );
  }
}

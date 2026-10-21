import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static Route<dynamic> route(RouteSettings settings) {
    final pages = <String, Widget>{
      '/splash': const SplashScreen(),
      '/onboarding': const OnboardingScreen(),
      '/login': const LoginScreen(),
      '/otp': const OtpScreen(),
      '/home': const HomeScreen(),
      '/pickup': const PickupScreen(),
      '/destination': const DestinationScreen(),
      '/choose': const ChooseRideScreen(),
      '/fare': const FareEstimateScreen(),
      '/confirm': const ConfirmBookingScreen(),
      '/searching': const SearchingScreen(),
      '/accepted': const DriverAcceptedScreen(),
      '/tracking': const DriverTrackingScreen(),
      '/driver': const DriverProfileScreen(),
      '/chat': const ChatScreen(),
      '/call': const CallScreen(),
      '/cancel': const CancelRideScreen(),
      '/complete': const RideCompletedScreen(),
      '/rating': const RatingScreen(),
      '/payment': const PaymentMethodScreen(),
      '/history': const RideHistoryScreen(),
      '/details': const RideDetailsScreen(),
      '/offers': const OffersScreen(),
      '/wallet': const WalletScreen(),
      '/notifications': const NotificationsScreen(),
      '/profile': const ProfileScreen(),
      '/edit-profile': const EditProfileScreen(),
      '/settings': const SettingsScreen(),
      '/help': const HelpSupportScreen(),
    };
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => pages[settings.name] ?? const HomeScreen(),
    );
  }
}

void go(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}

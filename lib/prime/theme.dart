import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Short colour aliases used across lib/prime/*. Values come from the brand palette.
class P {
  static const navy = AppColors.darkBlue;
  static const blue = AppColors.royalBlue;
  static const gold = AppColors.gold;
  static const goldDark = AppColors.goldDark;
  static const ink = AppColors.textPrimary;
  static const pale = AppColors.card;
  static const muted = AppColors.textSecondary;
  static const line = AppColors.border;
  static const green = AppColors.whatsapp;
  static const red = AppColors.error;
}

ThemeData primeTheme() => AppTheme.lightTheme;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// Keeps login state, profile and booking history on the phone.
class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  SharedPreferences? _p;
  bool loggedIn = false;
  String phone = '', name = '', email = '';
  List<Booking> _all = [];

  List<Booking> get bookings => _all.where((b) => b.userPhone == phone).toList();

  Future<void> load() async {
    final p = _p = await SharedPreferences.getInstance();
    loggedIn = p.getBool('loggedIn') ?? false;
    phone = p.getString('phone') ?? '';
    name = p.getString('name') ?? '';
    email = p.getString('email') ?? '';
    try {
      final raw = p.getString('bookings');
      if (raw != null) {
        _all = (jsonDecode(raw) as List)
            .map((e) => Booking.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {
      _all = [];
    }
  }

  Future<void> login(String phoneNo) async {
    if (phone != phoneNo) {
      name = '';
      email = '';
    }
    phone = phoneNo;
    loggedIn = true;
    await _p?.setBool('loggedIn', true);
    await _p?.setString('phone', phone);
    await _p?.setString('name', name);
    await _p?.setString('email', email);
    notifyListeners();
  }

  Future<void> saveProfile(String n, String e) async {
    name = n;
    email = e;
    await _p?.setString('name', n);
    await _p?.setString('email', e);
    notifyListeners();
  }

  Future<void> addBooking(Booking b) async {
    _all.insert(0, b);
    await _p?.setString('bookings', jsonEncode(_all.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> logout() async {
    loggedIn = false;
    await _p?.setBool('loggedIn', false);
    notifyListeners();
  }
}

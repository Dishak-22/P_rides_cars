import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home.dart';
import '../supabase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      // A local saved flag is not proof of Supabase authentication.
      final hasSupabaseSession = SupabaseService.client.auth.currentSession != null;
      final next = hasSupabaseSession ? const HomeScreen() : const LoginScreen();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => next));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: P.navy,
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.scale(scale: .7 + .3 * v, child: child),
            ),
            child: const Column(mainAxisSize: MainAxisSize.min, children: [
              BrandLogo(size: 110, radius: 28),
              SizedBox(height: 20),
              Text(AppConfig.businessName,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              SizedBox(height: 6),
              Text(AppConfig.tagline, style: TextStyle(color: Colors.white70)),
            ]),
          ),
        ),
      );
}

/// Login: mobile number -> Get OTP -> enter OTP -> Submit.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpSent = false;
  bool _busy = false;
  String? _phoneError, _otpError;
  int _resend = 0;
  Timer? _timer;

  String get _e164Phone => '+91${_phone.text.trim()}';

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  Future<void> _getOtp() async {
    final p = _phone.text.trim();
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(p)) {
      setState(() => _phoneError = 'Enter a valid 10-digit mobile number');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _phoneError = null;
      _otpError = null;
    });

    try {
      // Supabase's configured test phone number bypasses SMS delivery and
      // accepts its configured fixed OTP during development.
      await SupabaseService.client.auth.signInWithOtp(phone: _e164Phone);
      if (!mounted) return;
      setState(() {
        _otpSent = true;
        _otp.clear();
        _resend = 30;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        setState(() => _resend--);
        if (_resend <= 0) t.cancel();
      });
      snack(context, 'OTP request accepted. Enter the configured test OTP.');
    } catch (e) {
      if (mounted) {
        setState(() => _phoneError = 'Could not request OTP: ${_authError(e)}');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final token = _otp.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(token)) {
      setState(() => _otpError = 'Enter the 6-digit OTP');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _otpError = null;
    });

    try {
      final response = await SupabaseService.client.auth.verifyOTP(
        phone: _e164Phone,
        token: token,
        type: OtpType.sms,
      );
      final user = response.user ?? SupabaseService.client.auth.currentUser;
      if (user == null || SupabaseService.client.auth.currentSession == null) {
        throw StateError('Supabase did not return an authenticated session.');
      }

      await AppStore.instance.login(_phone.text.trim());
      if (!mounted) return;
      snack(context, 'Signed in successfully.');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (r) => false,
      );
    } catch (e) {
      if (mounted) setState(() => _otpError = 'OTP verification failed: ${_authError(e)}');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _authError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    return message.length > 220 ? '${message.substring(0, 220)}…' : message;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Center(child: BrandLogo(size: 96, radius: 26)),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(AppConfig.businessName,
                        style: TextStyle(color: P.navy, fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
                  ),
                  const SizedBox(height: 32),
                  const Text('Login', style: TextStyle(color: P.navy, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text('Enter your mobile number to receive an OTP.', style: TextStyle(color: P.muted)),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _phone,
                    enabled: !_otpSent && !_busy,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    decoration: InputDecoration(
                      labelText: 'Contact number',
                      prefixText: '+91  ',
                      prefixIcon: const Icon(Icons.phone_rounded),
                      errorText: _phoneError,
                      suffixIcon: _otpSent
                          ? IconButton(
                              tooltip: 'Change number',
                              icon: const Icon(Icons.edit_rounded),
                              onPressed: _busy ? null : () => setState(() {
                                _otpSent = false;
                                _otp.clear();
                              }),
                            )
                          : null,
                    ),
                  ),
                  if (!_otpSent) ...[
                    const SizedBox(height: 18),
                    ElevatedButton(onPressed: _busy ? null : _getOtp, child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Get OTP')),
                  ] else ...[
                    const SizedBox(height: 14),
                    TextField(
                      controller: _otp,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                      decoration: InputDecoration(
                        labelText: 'Enter 6-digit OTP',
                        prefixIcon: const Icon(Icons.lock_rounded),
                        errorText: _otpError,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (_resend > 0 || _busy) ? null : _getOtp,
                        child: Text(_resend > 0 ? 'Resend OTP in ${_resend}s' : 'Resend OTP'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(onPressed: _busy ? null : _submit, child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Submit')),
                  ],
                  const SizedBox(height: 18),
                  const Center(
                    child: Text('Development test OTP: ${AppConfig.demoOtp}', style: TextStyle(fontSize: 11, color: P.muted)),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

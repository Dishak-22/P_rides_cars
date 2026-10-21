import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config.dart';
import '../store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home.dart';

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
      final next = AppStore.instance.loggedIn ? const HomeScreen() : const LoginScreen();
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
  String? _phoneError, _otpError;
  int _resend = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _getOtp() {
    final p = _phone.text.trim();
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(p)) {
      setState(() => _phoneError = 'Enter a valid 10-digit mobile number');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _phoneError = null;
      _otpSent = true;
      _otpError = null;
      _otp.clear();
      _resend = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _resend--);
      if (_resend <= 0) t.cancel();
    });
    snack(context, 'Demo OTP sent: ${AppConfig.demoOtp}');
  }

  Future<void> _submit() async {
    if (_otp.text.trim() != AppConfig.demoOtp) {
      setState(() => _otpError = 'Incorrect OTP. Demo OTP is ${AppConfig.demoOtp}');
      return;
    }
    await AppStore.instance.login(_phone.text.trim());
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
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
                    enabled: !_otpSent,
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
                              onPressed: () => setState(() {
                                _otpSent = false;
                                _otp.clear();
                              }),
                            )
                          : null,
                    ),
                  ),
                  if (!_otpSent) ...[
                    const SizedBox(height: 18),
                    ElevatedButton(onPressed: _getOtp, child: const Text('Get OTP')),
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
                        onPressed: _resend > 0 ? null : _getOtp,
                        child: Text(_resend > 0 ? 'Resend OTP in ${_resend}s' : 'Resend OTP'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(onPressed: _submit, child: const Text('Submit')),
                  ],
                  const SizedBox(height: 18),
                  const Center(
                    child: Text('Demo mode: OTP is ${AppConfig.demoOtp}', style: TextStyle(fontSize: 11, color: P.muted)),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

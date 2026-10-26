
import 'package:flutter/material.dart';
import 'supabase_service.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() =>
      _SupabaseTestScreenState();
}

class _SupabaseTestScreenState
    extends State<SupabaseTestScreen> {
  bool _loading = false;
  String _result = 'Tap the button to test Supabase.';

  Future<void> _testConnection() async {
    setState(() {
      _loading = true;
      _result = 'Testing connection...';
    });

    try {
      final result = await SupabaseService.testConnection();

      if (!mounted) return;

      setState(() {
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _result = 'TEST FAILED\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = _result.startsWith('SUCCESS');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'P-Ride database diagnostic',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This test reads at most one row from bookings. '
              'It does not change database records.',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loading ? null : _testConnection,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.cloud_done),
              label: Text(
                _loading
                    ? 'Testing...'
                    : 'Test Supabase Connection',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: success ? Colors.green : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                _result,
                style: TextStyle(
                  fontSize: 14,
                  color: success ? Colors.green : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  /// Read-only test: does not insert, update, or delete anything.
  static Future<String> testConnection() async {
    try {
      await client
          .from('bookings')
          .select()
          .limit(1)
          .timeout(const Duration(seconds: 15));

      return 'SUCCESS\n'
          'Connected to Supabase.\n'
          'The bookings table query succeeded.';
    } on PostgrestException catch (e) {
      return 'DATABASE / PERMISSION ERROR\n'
          'Message: ${e.message}\n'
          'Code: ${e.code ?? "not provided"}\n'
          'Details: ${e.details ?? "none"}\n'
          'Hint: ${e.hint ?? "none"}';
    } on Exception catch (e) {
      return 'CONNECTION / CLIENT ERROR\n$e';
    } catch (e) {
      return 'UNEXPECTED ERROR\n$e';
    }
  }
}

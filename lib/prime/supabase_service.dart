import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client =
      Supabase.instance.client;

  static Future<String> testConnection() async {
    try {
      // Test access to the existing bookings table.
      await client
          .from('bookings')
          .select()
          .limit(1);

      return 'SUCCESS: Connected to Supabase and queried bookings.';
    } on PostgrestException catch (error) {
      return 'DATABASE ERROR: ${error.message}';
    } catch (error) {
      return 'CONNECTION ERROR: $error';
    }
  }
}
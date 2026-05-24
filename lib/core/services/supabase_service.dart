import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    // setup awal supabase, wajib dipanggil sebelum query database
    await Supabase.initialize(
      url: 'https://dvuwtjicxjhrpaxwnerw.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2dXd0amljeGpocnBheHduZXJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4NDM2MTgsImV4cCI6MjA5NDQxOTYxOH0.0kq7OIV7Az4QY0x5eepVsOrWP0kh41_mz6R6bLvrwBM',
    );
  }

  // shortcut biar manggil client supabase lebih gampang
  static SupabaseClient get client => Supabase.instance.client;
}

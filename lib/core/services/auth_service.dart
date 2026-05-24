import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  // client supabase buat akses auth/database
  final supabase = Supabase.instance.client;

  Future<void> testConnection() async {

    // test doang buat cek table profiles kebaca apa ngga
    final response =
        await supabase.from('profiles').select();

    print(response);
  }
}

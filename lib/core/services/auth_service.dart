import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase = Supabase.instance.client;

  Future<void> testConnection() async {

    final response =
        await supabase.from('profiles').select();

    print(response);
  }
}
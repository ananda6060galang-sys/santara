import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/supabase_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // nyalain koneksi supabase dulu sebelum app jalan
  await SupabaseService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // pantau status login/logout dari supabase
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      // kalau berhasil login, langsung masuk home
      if (event == AuthChangeEvent.signedIn) {
        Get.offAllNamed('/home');
      }

      // kalau logout, balikin ke halaman login
      if (event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Santara',

      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: false),

      initialRoute: AppPages.INITIAL,

      // semua route/page app ngambil dari sini
      getPages: AppPages.routes,
    );
  }
}

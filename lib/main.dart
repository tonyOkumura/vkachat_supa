import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vkachat_supa/pages/splash_page.dart';
import 'package:vkachat_supa/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://epykueokyykdbwfaipjb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVweWt1ZW9reXlrZGJ3ZmFpcGpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg3NjQ0MTcsImV4cCI6MjAxNDM0MDQxN30.kwRucapaG-qCBEj-AnOLTOM9OfariBH31HEdEQR9w4Y',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Chat App',
      themeMode: ThemeMode.dark,
      darkTheme: darkAppTheme,
      home: const SplashPage(),
    );
  }
}

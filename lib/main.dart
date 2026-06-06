import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_tracker/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rpanjzzegtaczyznavdu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwYW5qenplZ3RhY3p5em5hdmR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxOTI3MTEsImV4cCI6MjA5Mjc2ODcxMX0.0t4NIhZaDaoTmdjM9QJSTqqwNcBJOwjWRMuKIZRuzLo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

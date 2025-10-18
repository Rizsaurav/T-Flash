import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/env_config.dart';
import 'screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  runApp(const InsidePulseApp());
}

final supabase = Supabase.instance.client;

class InsidePulseApp extends StatelessWidget {
  const InsidePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsidePulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black87,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        fontFamily: '.AppleSystemUIFont', // Uses Mac/iOS system font if available
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.black87,
          secondary: Colors.grey[700]!,
          background: const Color(0xFFF2F2F7),
          surface: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white.withOpacity(0.95),
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: '.AppleSystemUIFont',
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: '.AppleSystemUIFont',
            ),
          ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}

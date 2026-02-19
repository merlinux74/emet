import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';
import 'services/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MusikaApp());
}

class MusikaApp extends StatelessWidget {
  const MusikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController(),
      builder: (context, _) {
        final themeController = ThemeController();
        
        return MaterialApp(
          title: 'Musika - Emet',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode,
          // Tema Scuro (Esistente)
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F0E17),
            primaryColor: const Color(0xFF6C63FF),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C63FF),
              secondary: Color(0xFF00D2FF),
              surface: Color(0xFF1B1A23),
              onSurface: Colors.white,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            useMaterial3: true,
          ),
          // Tema Chiaro (Bianco e Celeste)
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFF007BFF),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007BFF),
              secondary: Color(0xFF00D2FF),
              surface: Color(0xFFF8F9FA),
              onSurface: Color(0xFF0F0E17),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF0F0E17),
              elevation: 0,
            ),
          ),
          home: const OnboardingScreen(),
        );
      },
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const EmetApp());
}

class EmetApp extends StatelessWidget {
  const EmetApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('CurrentPage: main.dart');
    return MaterialApp(
      title: 'Emet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007BFF),
          primary: const Color(0xFF007BFF),
          secondary: const Color(0xFF6C63FF), // Neon Purple/Blue accent
          tertiary: const Color(0xFF00D2FF),  // Cyan accent
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: const Color(0xFF001F3F), // Deep Space Blue for text
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF007BFF),
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF007BFF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 180, left: 20, right: 20, bottom: 120),
      children: [
        Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ciao, Esploratore! 🚀',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF001F3F),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Pronto per un nuovo viaggio spirituale?',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 35),
        _buildFeatureCard(
          'Nuovi Beat',
          'Scopri le ultime tracce cristiane',
          Icons.auto_awesome_rounded,
          const Color(0xFF6C63FF),
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          'Live Worship',
          'Unisciti alla lode in diretta',
          Icons.sensors_rounded,
          const Color(0xFF007BFF),
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          'Space Community',
          'Connettiti con altri giovani',
          Icons.rocket_launch_rounded,
          const Color(0xFF00D2FF),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.05), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[400],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueGrey[200], size: 16),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    const Center(child: Text('Beat Cristiani', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)))),
    const Center(child: Text('Live Worship', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)))),
    const Center(child: Text('Il Mio Profilo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildOrbitalAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: const Color(0xFF007BFF), size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('CurrentPage: home_page (main.dart)');
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            // Elemento decorativo "Nebula" in alto a sinistra
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C63FF).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
              child: Row(
                children: [
                  // Logo futuristico
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF007BFF), Color(0xFF6C63FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome_mosaic_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMET',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          letterSpacing: -0.5,
                          color: Color(0xFF001F3F),
                        ),
                      ),
                      Text(
                        'SPACE EDITION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Actions minimaliste e moderne
                  _buildOrbitalAction(Icons.search_rounded),
                  const SizedBox(width: 12),
                  _buildOrbitalAction(Icons.notifications_none_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFE3F2FD), // Light blue space theme
            ],
          ),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF007BFF).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch_outlined),
                activeIcon: Icon(Icons.rocket_launch),
                label: 'Esplora',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                activeIcon: Icon(Icons.music_note),
                label: 'Beat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline),
                activeIcon: Icon(Icons.play_circle),
                label: 'Live',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Io',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'player_screen.dart';
import 'profile_screen.dart';
import 'privacy_screen.dart';
import '../services/player_controller.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final PlayerController _playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    _playerController.addListener(_onPlayerChanged);
  }

  @override
  void dispose() {
    _playerController.removeListener(_onPlayerChanged);
    super.dispose();
  }

  void _onPlayerChanged() {
    // Re-build navigation to update ProfileScreen when artist is loaded
    setState(() {});
    
    if (_playerController.hasTrack && _selectedIndex != 1) {
      setState(() {
        _selectedIndex = 1; // Passa automaticamente al tab player quando un brano viene selezionato
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeScreen(),
          _playerController.hasTrack 
            ? PlayerScreen(
                brano: _playerController.currentBrano!, 
                release: _playerController.currentRelease!,
                isTab: true,
              )
            : const PlayerPlaceholder(),
          _playerController.artist != null 
            ? ProfileScreen(artist: _playerController.artist!)
            : Center(child: CircularProgressIndicator(color: theme.primaryColor)),
          const PrivacyScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.05), width: 0.5)),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.3),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Player'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.privacy_tip_outlined), label: 'Privacy'),
          ],
        ),
      ),
    );
  }
}

class PlayerPlaceholder extends StatelessWidget {
  const PlayerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.05)),
            const SizedBox(height: 16),
            Text(
              'Seleziona un brano per iniziare',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}

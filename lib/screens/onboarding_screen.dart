import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/player_controller.dart';
import '../models/release.dart';
import 'main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class FlashingText extends StatefulWidget {
  final String text;
  final Color color;

  const FlashingText({super.key, required this.text, required this.color});

  @override
  State<FlashingText> createState() => _FlashingTextState();
}

class _FlashingTextState extends State<FlashingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: widget.color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late Future<List<Release>> _dataFuture;
  VersionStatus? _versionStatus;

  @override
  void initState() {
    super.initState();
    print('CurrentPage: onboarding_screen.dart');
    _dataFuture = ApiService.fetchReleases();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCookieConsent();
      _checkVersion();
    });
  }

  Future<void> _checkVersion() async {
    final newVersion = NewVersionPlus(
      androidId: 'com.emet.musika', // Sostituire con il vero package name
      iOSId: 'com.emet.musika', // Sostituire con il vero bundle ID
    );

    try {
      final status = await newVersion.getVersionStatus();
      if (status != null && status.canUpdate) {
        setState(() {
          _versionStatus = status;
        });
      }
    } catch (e) {
      print('Errore controllo versione: $e');
    }
  }

  Future<void> _checkCookieConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final bool accepted = prefs.getBool('cookie_consent') ?? false;

    if (!accepted && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final theme = Theme.of(context);
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Informativa sui Cookie',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              content: Text(
                'Utilizziamo i cookie per migliorare la tua esperienza su Emet. Continuando a utilizzare l\'applicazione, accetti la nostra politica sui cookie e sulla privacy.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await prefs.setBool('cookie_consent', true);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(
                    'ACCETTA',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildUpdateBanner(ThemeData theme) {
    return GestureDetector(
      onTap: () async {
        if (_versionStatus != null && _versionStatus!.appStoreLink.isNotEmpty) {
          final uri = Uri.parse(_versionStatus!.appStoreLink);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: theme.primaryColor),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: FlashingText(
          text: 'AGGIORNAMENTO DISPONIBILE! CLICCA QUI',
          color: theme.primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: FutureBuilder<List<Release>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          String? imageUrl;
          
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final firstRelease = snapshot.data!.first;
            if (firstRelease.artist != null) {
              imageUrl = firstRelease.artist!.imageUrl;
              
              // Pre-initialize data once
              final player = PlayerController();
              if (player.allReleases.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  player.setAllReleases(snapshot.data!);
                  player.setArtist(firstRelease.artist!);
                });
              }
            }
          }

          return Stack(
            children: [
              // Background with glow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.2),
                      radius: 1.2,
                      colors: isDark ? [
                        const Color(0xFF2D1B4E),
                        const Color(0xFF0F0E17),
                      ] : [
                        const Color(0xFFE3F2FD),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),

              // Artist Image at the bottom (Local Asset)
              Positioned(
                bottom: -20,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.75,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, isDark ? Colors.black : Colors.white],
                      stops: const [0.0, 0.4],
                    ).createShader(rect);
                  },
                  blendMode: isDark ? BlendMode.dstIn : BlendMode.dstOut,
                  child: Image.asset(
                    'assets/images/imgstart.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to network image if asset is missing
                      if (imageUrl != null) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      // "Emet" stylized title
                      Text(
                        'Emet',
                        style: GoogleFonts.ruslanDisplay(
                          color: isDark ? Colors.white : theme.primaryColor,
                          fontSize: 72,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4,
                      ),
                    ),
                    const Spacer(),
                      
                      if (_versionStatus != null && _versionStatus!.canUpdate)
                        _buildUpdateBanner(theme),

                      // Gradient "Get Start" Button
                      Container(
                        width: 180,
                        height: 54,
                        margin: const EdgeInsets.only(bottom: 50),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark ? [
                              const Color(0xFF6C63FF),
                              const Color(0xFF3B2667),
                            ] : [
                              const Color(0xFF00D2FF),
                              const Color(0xFF007BFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const MainNavigation()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                          child: Text(
                            'Get Start',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Loading indicator
              if (snapshot.connectionState == ConnectionState.waiting)
                Positioned.fill(
                  child: Container(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

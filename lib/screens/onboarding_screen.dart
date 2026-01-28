import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../services/player_controller.dart';
import '../models/release.dart';
import 'main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late Future<List<Release>> _dataFuture;

  @override
  void initState() {
    super.initState();
    print('CurrentPage: onboarding_screen.dart');
    _dataFuture = ApiService.fetchReleases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
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
              // Background with purple glow
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.2),
                      radius: 1.2,
                      colors: [
                        Color(0xFF2D1B4E),
                        Color(0xFF0F0E17),
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
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                      stops: [0.0, 0.4],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
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
                          color: Colors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4,
                      ),
                    ),
                    const Spacer(),
                      
                      // Gradient "Get Start" Button
                      Container(
                        width: 180,
                        height: 54,
                        margin: const EdgeInsets.only(bottom: 50),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFF3B2667),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
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
                    color: const Color(0xFF0F0E17).withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
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

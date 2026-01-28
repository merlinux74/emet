import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artist.dart';

class ProfileScreen extends StatelessWidget {
  final Artist? artist;

  const ProfileScreen({super.key, this.artist});

  @override
  Widget build(BuildContext context) {
    if (artist == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0E17),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsing Header with Artist Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color(0xFF0F0E17),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: artist!.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFF0F0E17),
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Artist Info Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    artist!.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${artist!.genere} • ${artist!.etichetta}',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C63FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Verse Section
                  if (artist!.versoBibbia != null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1A23),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_stories, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              artist!.versoBibbia!,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Biography
                  Text(
                    'BIOGRAFIA',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    artist!.biografia,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Social Links
                  Text(
                    'SOCIAL',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (artist!.instagram != null) _buildSocialIcon(Icons.camera_alt, artist!.instagram!),
                      if (artist!.youtube != null) _buildSocialIcon(Icons.play_circle_filled, artist!.youtube!),
                      if (artist!.spotify != null) _buildSocialIcon(Icons.music_note, artist!.spotify!),
                      if (artist!.tiktok != null) _buildSocialIcon(Icons.video_library, artist!.tiktok!),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1A23),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

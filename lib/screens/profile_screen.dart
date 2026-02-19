import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/artist.dart';

class ProfileScreen extends StatelessWidget {
  final Artist? artist;

  const ProfileScreen({super.key, this.artist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (artist == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.primaryColor),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsing Header with Artist Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/immagineprofilo.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CachedNetworkImage(
                        imageUrl: artist!.imageUrl,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor,
                        ],
                        stops: const [0.6, 1.0],
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
                      color: theme.colorScheme.onSurface,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${artist!.genere} • ${artist!.etichetta}',
                    style: GoogleFonts.poppins(
                      color: theme.primaryColor,
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
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_stories, color: theme.primaryColor),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              artist!.versoBibbia!,
                              style: GoogleFonts.poppins(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    artist!.biografia,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Social Links
                  Text(
                    'SOCIAL',
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (artist!.instagram != null && artist!.instagram!.isNotEmpty) 
                        _buildSocialIcon(context, FontAwesomeIcons.instagram, artist!.instagram!),
                      if (artist!.youtube != null && artist!.youtube!.isNotEmpty) 
                        _buildSocialIcon(context, FontAwesomeIcons.youtube, artist!.youtube!),
                      if (artist!.spotify != null && artist!.spotify!.isNotEmpty) 
                        _buildSocialIcon(context, FontAwesomeIcons.spotify, artist!.spotify!),
                      if (artist!.tiktok != null && artist!.tiktok!.isNotEmpty) 
                        _buildSocialIcon(context, FontAwesomeIcons.tiktok, artist!.tiktok!),
                      if (artist!.appleMusic != null && artist!.appleMusic!.isNotEmpty) 
                        _buildSocialIcon(context, FontAwesomeIcons.apple, artist!.appleMusic!),
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

  Widget _buildSocialIcon(BuildContext context, IconData icon, String url) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FaIcon(icon, color: theme.colorScheme.onSurface, size: 28),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/release.dart';
import '../services/api_service.dart';
import '../services/player_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Release>> _releasesFuture;

  @override
  void initState() {
    super.initState();
    _releasesFuture = ApiService.fetchReleases();
  }

  void _retryFetch() {
    setState(() {
      _releasesFuture = ApiService.fetchReleases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedBuilder(
          animation: PlayerController(),
          builder: (context, _) {
            final artistName = PlayerController().artist?.name ?? 'HEMET';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  artistName.toUpperCase(),
                  style: GoogleFonts.ruslanDisplay(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'RAP CRISTIANO',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6C63FF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Release>>(
        future: _releasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Errore nel caricamento: ${snapshot.error}', 
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _retryFetch,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nessuna release trovata', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryFetch,
                    child: const Text('Aggiorna'),
                  ),
                ],
              ),
            );
          }

          final releases = snapshot.data!;
          
          // Imposta i dati nel controller globale se disponibili
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final player = PlayerController();
            player.setAllReleases(releases);
            if (releases.isNotEmpty && releases.first.artist != null) {
              player.setArtist(releases.first.artist!);
            }
          });

          final featuredRelease = releases.first;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Artist / Release
                Container(
                  height: 220,
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(featuredRelease.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FEATURED ARTIST',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          featuredRelease.nome,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recently Played Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSectionHeader('RECENTLY PLAYED'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: releases.length,
                    itemBuilder: (context, index) {
                      return _buildRecentCard(context, releases[index]);
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Tracks Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSectionHeader('TRACKS'),
                ),
                const SizedBox(height: 16),
                _buildTracksList(releases),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTracksList(List<Release> releases) {
    final List<Map<String, dynamic>> allTracks = [];
    for (var release in releases) {
      for (var brano in release.brani) {
        allTracks.add({
          'brano': brano,
          'release': release,
        });
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: allTracks.length,
      itemBuilder: (context, index) {
        final item = allTracks[index];
        final Brano brano = item['brano'];
        final Release release = item['release'];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1A23),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: release.imageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.white10),
                errorWidget: (context, url, error) => const Icon(Icons.music_note, color: Colors.white38),
              ),
            ),
            title: Text(
              brano.titolo,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${release.nome} • Emet',
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.play_circle_fill, color: Color(0xFF6C63FF), size: 32),
            onTap: () => _openPlayer(context, brano, release),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildRecentCard(BuildContext context, Release release) {
    return GestureDetector(
      onTap: () => _openPlayer(context, release.brani.first, release),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: release.imageUrl,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.white10),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              release.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(BuildContext context, Release release) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A23),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: release.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          release.nome,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Emet • 2025',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.favorite_border, color: Color(0xFF6C63FF)),
        onTap: () => _openPlayer(context, release.brani.first, release),
      ),
    );
  }

  void _openPlayer(BuildContext context, Brano brano, Release release) {
    if (brano.youtubeId != null) {
      PlayerController().setTrack(release, brano);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video non disponibile per questa traccia')),
      );
    }
  }
}

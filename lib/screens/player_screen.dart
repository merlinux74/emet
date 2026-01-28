import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/release.dart';

class PlayerScreen extends StatefulWidget {
  final Brano brano;
  final Release release;
  final bool isTab;

  const PlayerScreen({
    super.key,
    required this.brano,
    required this.release,
    this.isTab = false,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.brano.youtubeId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void didUpdateWidget(PlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.brano.youtubeId != widget.brano.youtubeId) {
      _controller.load(widget.brano.youtubeId!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isTab 
          ? null 
          : IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
        title: Text(
          'NOW PLAYING',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // YouTube Player Container with custom styling
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFF6C63FF),
                  progressColors: const ProgressBarColors(
                    playedColor: Color(0xFF6C63FF),
                    handleColor: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Title and Artist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.brano.titolo,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Emet • ${widget.release.nome}',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Controls (Custom UI to match "Now Play" in image)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Progress Bar (Placeholder for now, YouTube player has its own but we can add one for UI)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('00:00', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                      Text('03:45', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.repeat, color: Colors.white38),
                      const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C63FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.pause_rounded, color: Colors.white, size: 40),
                      ),
                      const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                      const Icon(Icons.shuffle, color: Colors.white38),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Lyrics hint
            Column(
              children: [
                Text(
                  'LYRICS',
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_up, color: Colors.white38),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

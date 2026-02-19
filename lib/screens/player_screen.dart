import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/release.dart';
import '../services/player_controller.dart';

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
  final PlayerController _playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    _initController();
    _playerController.addListener(_onPlayerStateChanged);
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      final currentBrano = _playerController.currentBrano;
      if (currentBrano != null && currentBrano.youtubeId != null) {
        _controller.load(currentBrano.youtubeId!);
      }
      setState(() {});
    }
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
    _playerController.removeListener(_onPlayerStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brano = _playerController.currentBrano ?? widget.brano;
    final release = _playerController.currentRelease ?? widget.release;
    final sortMode = _playerController.currentSortMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isTab 
          ? null 
          : IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
        title: Text(
          'NOW PLAYING',
          style: GoogleFonts.poppins(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortMode>(
            icon: Icon(Icons.sort, color: theme.colorScheme.onSurface),
            onSelected: (mode) => _playerController.setSortMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortMode.newest, child: Text('Più nuovi')),
              const PopupMenuItem(value: SortMode.alphabetical, child: Text('A-Z')),
              const PopupMenuItem(value: SortMode.random, child: Text('Random')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // YouTube Player Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
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
                  progressIndicatorColor: theme.primaryColor,
                  onReady: () => setState(() {}),
                  onEnded: (meta) => _playerController.playNext(),
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
                    brano.titolo,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Emet • ${release.nome}',
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.repeat, 
                          color: sortMode == SortMode.newest ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.3)
                        ),
                        onPressed: () => _playerController.setSortMode(SortMode.newest),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous_rounded, color: theme.colorScheme.onSurface, size: 40),
                        onPressed: () => _playerController.playPrevious(),
                      ),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 
                            color: Colors.white, 
                            size: 40
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next_rounded, color: theme.colorScheme.onSurface, size: 40),
                        onPressed: () => _playerController.playNext(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.shuffle, 
                          color: sortMode == SortMode.random ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.3)
                        ),
                        onPressed: () => _playerController.setSortMode(SortMode.random),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Sort Indicator
                  Text(
                    'MODALITÀ: ${sortMode == SortMode.newest ? "CRONOLOGICO" : sortMode == SortMode.alphabetical ? "ALFABETICO" : "RANDOM"}',
                    style: GoogleFonts.poppins(color: theme.colorScheme.onSurface.withOpacity(0.2), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Lyrics hint
            Column(
              children: [
                Text(
                  'LYRICS',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Icon(Icons.keyboard_arrow_up, color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

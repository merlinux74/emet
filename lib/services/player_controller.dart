import 'package:flutter/material.dart';
import '../models/release.dart';
import '../models/artist.dart';

enum SortMode { newest, alphabetical, random }

class TrackInfo {
  final Brano brano;
  final Release release;

  TrackInfo({required this.brano, required this.release});
}

class PlayerController extends ChangeNotifier {
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() => _instance;
  PlayerController._internal();

  List<Release> _allReleases = [];
  List<TrackInfo> _playQueue = [];
  int _currentIndex = -1;
  Artist? _artist;
  SortMode _currentSortMode = SortMode.newest;

  Artist? get artist => _artist;
  SortMode get currentSortMode => _currentSortMode;
  
  Brano? get currentBrano => _currentIndex != -1 ? _playQueue[_currentIndex].brano : null;
  Release? get currentRelease => _currentIndex != -1 ? _playQueue[_currentIndex].release : null;
  
  bool get hasTrack => _currentIndex != -1;

  void setAllReleases(List<Release> releases) {
    _allReleases = releases;
    if (_playQueue.isEmpty) {
      _buildQueue();
    }
  }

  void _buildQueue() {
    List<TrackInfo> allTracks = [];
    for (var release in _allReleases) {
      for (var brano in release.brani) {
        allTracks.add(TrackInfo(brano: brano, release: release));
      }
    }

    // Default sort: Newest to oldest (assuming ID order or reverse list)
    allTracks.sort((a, b) => b.release.id.compareTo(a.release.id));
    
    _playQueue = allTracks;
    _applyCurrentSort();
  }

  void _applyCurrentSort() {
    if (_playQueue.isEmpty) return;

    final currentTrack = _currentIndex != -1 ? _playQueue[_currentIndex] : null;

    switch (_currentSortMode) {
      case SortMode.newest:
        _playQueue.sort((a, b) => b.release.id.compareTo(a.release.id));
        break;
      case SortMode.alphabetical:
        _playQueue.sort((a, b) => a.brano.titolo.toLowerCase().compareTo(b.brano.titolo.toLowerCase()));
        break;
      case SortMode.random:
        _playQueue.shuffle();
        break;
    }

    // Maintain current track index after sorting
    if (currentTrack != null) {
      _currentIndex = _playQueue.indexWhere((t) => t.brano.id == currentTrack.brano.id);
    }
    notifyListeners();
  }

  void setSortMode(SortMode mode) {
    _currentSortMode = mode;
    _applyCurrentSort();
  }

  void setTrack(Release release, Brano brano) {
    if (_playQueue.isEmpty) {
      _buildQueue();
    }
    
    _currentIndex = _playQueue.indexWhere((t) => t.brano.id == brano.id);
    
    if (release.artist != null) {
      _artist = release.artist;
    }
    notifyListeners();
  }

  void playNext() {
    if (_playQueue.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _playQueue.length;
    notifyListeners();
  }

  void playPrevious() {
    if (_playQueue.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playQueue.length) % _playQueue.length;
    notifyListeners();
  }

  void setArtist(Artist artist) {
    _artist = artist;
    notifyListeners();
  }
}

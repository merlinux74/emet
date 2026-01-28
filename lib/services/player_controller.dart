import 'package:flutter/material.dart';
import '../models/release.dart';
import '../models/artist.dart';

class PlayerController extends ChangeNotifier {
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() => _instance;
  PlayerController._internal();

  Release? _currentRelease;
  Brano? _currentBrano;
  Artist? _artist;

  Release? get currentRelease => _currentRelease;
  Brano? get currentBrano => _currentBrano;
  Artist? get artist => _artist;

  void setTrack(Release release, Brano brano) {
    _currentRelease = release;
    _currentBrano = brano;
    if (release.artist != null) {
      _artist = release.artist;
    }
    notifyListeners();
  }

  void setArtist(Artist artist) {
    _artist = artist;
    notifyListeners();
  }

  bool get hasTrack => _currentRelease != null && _currentBrano != null;
}

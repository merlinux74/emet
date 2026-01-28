import 'package:flutter/material.dart';
import '../models/release.dart';

class PlayerController extends ChangeNotifier {
  static final PlayerController _instance = PlayerController._internal();
  factory PlayerController() => _instance;
  PlayerController._internal();

  Release? _currentRelease;
  Brano? _currentBrano;

  Release? get currentRelease => _currentRelease;
  Brano? get currentBrano => _currentBrano;

  void setTrack(Release release, Brano brano) {
    _currentRelease = release;
    _currentBrano = brano;
    notifyListeners();
  }

  bool get hasTrack => _currentRelease != null && _currentBrano != null;
}

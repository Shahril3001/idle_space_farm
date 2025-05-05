import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class AudioManager with ChangeNotifier {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isInitialized = false;
  double _bgmVolume = 0.5;
  double _sfxVolume = 1.0;
  bool _isMuted = false;
  String? _currentBgmPath; // Track currently playing BGM

  // Public getters
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;
  bool get isMuted => _isMuted;
  double get effectiveBgmVolume => _isMuted ? 0 : _bgmVolume;
  double get effectiveSfxVolume => _isMuted ? 0 : _sfxVolume;
  String? get currentBgmPath => _currentBgmPath;
  bool get isBgmPlaying => _currentBgmPath != null;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final settingsBox = await Hive.openBox('audio_settings');
      _bgmVolume = settingsBox.get('bgmVolume', defaultValue: 0.5);
      _sfxVolume = settingsBox.get('sfxVolume', defaultValue: 1.0);
      _isMuted = settingsBox.get('isMuted', defaultValue: false);

      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(effectiveBgmVolume);
      await _sfxPlayer.setVolume(effectiveSfxVolume);

      // Handle player completion
      _bgmPlayer.onPlayerComplete.listen((_) {
        _currentBgmPath = null;
        notifyListeners();
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('AudioManager initialization error: $e');
    }
  }

  Future<void> playBGM(String path) async {
    if (!_isInitialized) await initialize();

    // Don't restart if same BGM is already playing
    if (_currentBgmPath == path) return;

    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.play(AssetSource(path));
      _currentBgmPath = path;
      notifyListeners();
    } catch (e) {
      debugPrint('BGM play error: $e');
      _currentBgmPath = null;
      notifyListeners();
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer.stop();
      _currentBgmPath = null;
      notifyListeners();
    } catch (e) {
      debugPrint('BGM stop error: $e');
    }
  }

  Future<void> pauseBGM() async {
    try {
      await _bgmPlayer.pause();
      notifyListeners();
    } catch (e) {
      debugPrint('BGM pause error: $e');
    }
  }

  Future<void> resumeBGM() async {
    if (_currentBgmPath == null) return;
    try {
      await _bgmPlayer.resume();
      notifyListeners();
    } catch (e) {
      debugPrint('BGM resume error: $e');
    }
  }

  Future<void> playSFX(String path) async {
    if (!_isInitialized) await initialize();
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint('SFX play error: $e');
    }
  }

  Future<void> setBGMVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(effectiveBgmVolume);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setSFXVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(effectiveSfxVolume);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _bgmPlayer.setVolume(effectiveBgmVolume);
    await _sfxPlayer.setVolume(effectiveSfxVolume);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    try {
      final settingsBox = await Hive.openBox('audio_settings');
      await settingsBox.putAll({
        'bgmVolume': _bgmVolume,
        'sfxVolume': _sfxVolume,
        'isMuted': _isMuted,
      });
    } catch (e) {
      debugPrint('Save settings error: $e');
    }
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
    _currentBgmPath = null;
    notifyListeners();
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Added for WidgetsBinding

/// 効果音管理クラス
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  AudioPlayer? _correctSoundPlayer;
  AudioPlayer? _incorrectSoundPlayer;
  AudioPlayer? _gameStartSoundPlayer;
  AudioPlayer? _gameEndSoundPlayer;
  bool _isSoundEnabled = true;

  /// 効果音の有効/無効を設定
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  /// 効果音が有効かどうかを取得
  bool get isSoundEnabled => _isSoundEnabled;

  /// テスト環境かどうかを判定
  bool get _isTestMode =>
      kDebugMode && !WidgetsBinding.instance.isRootWidgetAttached;

  /// 正解音を再生
  Future<void> playCorrectSound() async {
    if (!_isSoundEnabled || _isTestMode) return;

    try {
      _correctSoundPlayer ??= AudioPlayer();
      await _correctSoundPlayer!.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      // 効果音ファイルが見つからない場合は無視
      debugPrint('正解音の再生に失敗しました: $e');
    }
  }

  /// 不正解音を再生
  Future<void> playIncorrectSound() async {
    if (!_isSoundEnabled || _isTestMode) return;

    try {
      _incorrectSoundPlayer ??= AudioPlayer();
      await _incorrectSoundPlayer!.play(AssetSource('sounds/incorrect.mp3'));
    } catch (e) {
      // 効果音ファイルが見つからない場合は無視
      debugPrint('不正解音の再生に失敗しました: $e');
    }
  }

  /// ゲーム開始音を再生
  Future<void> playGameStartSound() async {
    if (!_isSoundEnabled || _isTestMode) return;

    try {
      _gameStartSoundPlayer ??= AudioPlayer();
      await _gameStartSoundPlayer!.play(AssetSource('sounds/game_start.mp3'));
    } catch (e) {
      // 効果音ファイルが見つからない場合は無視
      debugPrint('ゲーム開始音の再生に失敗しました: $e');
    }
  }

  /// ゲーム終了音を再生
  Future<void> playGameEndSound() async {
    if (!_isSoundEnabled || _isTestMode) return;

    try {
      _gameEndSoundPlayer ??= AudioPlayer();
      await _gameEndSoundPlayer!.play(AssetSource('sounds/game_end.mp3'));
    } catch (e) {
      // 効果音ファイルが見つからない場合は無視
      debugPrint('ゲーム終了音の再生に失敗しました: $e');
    }
  }

  /// リソースを解放
  void dispose() {
    _correctSoundPlayer?.dispose();
    _incorrectSoundPlayer?.dispose();
    _gameStartSoundPlayer?.dispose();
    _gameEndSoundPlayer?.dispose();
    _correctSoundPlayer = null;
    _incorrectSoundPlayer = null;
    _gameStartSoundPlayer = null;
    _gameEndSoundPlayer = null;
  }
}

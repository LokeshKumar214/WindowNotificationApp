import 'package:audioplayers/audioplayers.dart';

class AlertSound {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAlertSound() async {
    await _player.play(AssetSource('sounds/AlarmSound.wav'), volume: 1.0);
  }
}

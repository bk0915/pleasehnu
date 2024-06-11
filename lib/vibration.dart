import 'package:vibration/vibration.dart';
import 'mainPage.dart';

class VibrationService {
  // 0.5초 동안 진동
  static Future<void> vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);  // 500ms 동안 진동
    }
  }

  // 진동 패턴
  static Future<void> vibratePattern() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
  }

  // 진동 취소
  static Future<void> cancel() async {
    Vibration.cancel();
  }
}

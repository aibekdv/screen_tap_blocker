import 'screen_tap_blocker_platform_interface.dart';

class ScreenTapBlocker {
  static Future<void> enable() => ScreenTapBlockerPlatform.instance.enable();

  static Future<void> disable() => ScreenTapBlockerPlatform.instance.disable();

  static Future<void> blockFor(Duration duration) =>
      ScreenTapBlockerPlatform.instance.blockFor(duration);
}

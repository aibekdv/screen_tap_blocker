import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_tap_blocker_method_channel.dart';

abstract class ScreenTapBlockerPlatform extends PlatformInterface {
  ScreenTapBlockerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenTapBlockerPlatform _instance = MethodChannelScreenTapBlocker();

  static ScreenTapBlockerPlatform get instance => _instance;

  static set instance(ScreenTapBlockerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> enable() {
    throw UnimplementedError('enable() has not been implemented.');
  }

  Future<void> disable() {
    throw UnimplementedError('disable() has not been implemented.');
  }

  Future<void> blockFor(Duration duration) {
    throw UnimplementedError('blockFor() has not been implemented.');
  }
}

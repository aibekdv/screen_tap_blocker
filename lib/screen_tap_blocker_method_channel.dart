import 'dart:async';
import 'package:flutter/services.dart';
import 'screen_tap_blocker_platform_interface.dart';

class MethodChannelScreenTapBlocker extends ScreenTapBlockerPlatform {
  final MethodChannel _channel = const MethodChannel('screen_tap_blocker');

  @override
  Future<void> enable() async {
    await _channel.invokeMethod('enable');
  }

  @override
  Future<void> disable() async {
    await _channel.invokeMethod('disable');
  }

  @override
  Future<void> blockFor(Duration duration) async {
    await enable();
    Future.delayed(duration, () => disable());
  }
}

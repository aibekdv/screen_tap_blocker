import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_tap_blocker/screen_tap_blocker_method_channel.dart';

void main() {
  const MethodChannel channel = MethodChannel('screen_tap_blocker');
  final plugin = MethodChannelScreenTapBlocker();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Очистка моков перед тестом
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('enable calls enable method on platform channel', () async {
    bool called = false;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'enable') {
            called = true;
          }
          return null;
        });

    await plugin.enable();

    expect(called, true);
  });

  test('disable calls disable method on platform channel', () async {
    bool called = false;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'disable') {
            called = true;
          }
          return null;
        });

    await plugin.disable();

    expect(called, true);
  });

  test('blockFor calls enable and disable with delay', () async {
    final List<String> calls = [];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          calls.add(methodCall.method);
          return null;
        });

    await plugin.blockFor(const Duration(milliseconds: 10));

    expect(calls.contains('enable'), true);

    await Future.delayed(const Duration(milliseconds: 20));

    expect(calls.contains('disable'), true);
  });
}

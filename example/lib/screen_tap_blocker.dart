import 'package:flutter/material.dart';
import 'package:screen_tap_blocker/screen_tap_blocker.dart';

class ScreenTapBlockerExamplePage extends StatefulWidget {
  const ScreenTapBlockerExamplePage({super.key});

  @override
  State<ScreenTapBlockerExamplePage> createState() =>
      _ScreenTapBlockerExamplePageState();
}

class _ScreenTapBlockerExamplePageState
    extends State<ScreenTapBlockerExamplePage> {
  bool _isBlocked = false;
  String _statusMessage = 'Taps allowed';

  Future<void> _enableBlocker() async {
    try {
      await ScreenTapBlocker.enable();
      setState(() {
        _isBlocked = true;
        _statusMessage = 'Taps blocked';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to block taps: $e';
      });
    }
  }

  Future<void> _disableBlocker() async {
    try {
      await ScreenTapBlocker.disable();
      setState(() {
        _isBlocked = false;
        _statusMessage = 'Taps allowed';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to unblock taps: $e';
      });
    }
  }

  Future<void> _blockForDuration() async {
    try {
      await ScreenTapBlocker.blockFor(const Duration(seconds: 5));
      setState(() {
        _isBlocked = true;
        _statusMessage = 'Taps blocked for 5 seconds';
      });
      // Автоматически обновим статус через 5 секунд
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _isBlocked = false;
          _statusMessage = 'Taps allowed';
        });
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to block taps for duration: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Tap Blocker Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 20,
                  color: _isBlocked ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isBlocked ? null : _enableBlocker,
                child: const Text('Block taps'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isBlocked ? _disableBlocker : null,
                child: const Text('Unblock taps'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isBlocked ? null : _blockForDuration,
                child: const Text('Block taps for 5 seconds'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

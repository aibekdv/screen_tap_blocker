# screen\_tap\_blocker

[![pub package](https://img.shields.io/pub/v/screen_tap_blocker.svg)](https://pub.dev/packages/screen_tap_blocker)
[![GitHub stars](https://img.shields.io/github/stars/aibekdv/screen_tap_blocker.svg)](https://github.com/aibekdv/screen_tap_blocker/stargazers)
[![License](https://img.shields.io/github/license/aibekdv/screen_tap_blocker.svg)](https://github.com/aibekdv/screen_tap_blocker/blob/main/LICENSE)

Flutter plugin to temporarily block all screen taps on Android and iOS.

---

## Features

* Block all taps on the screen
* Unblock taps
* Block taps for a specified duration
* Supports Android and iOS
* Simple Dart API

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  screen_tap_blocker: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

```dart
import 'package:screen_tap_blocker/screen_tap_blocker.dart';

void main() async {
  // Block all taps
  await ScreenTapBlocker.enable();

  // Unblock taps
  await ScreenTapBlocker.disable();

  // Block taps for 10 seconds
  await ScreenTapBlocker.blockFor(Duration(seconds: 10));
}
```

---

## API

| Method               | Description                                                       |
| -------------------- | ----------------------------------------------------------------- |
| `enable()`           | Enable blocking of all screen taps                                |
| `disable()`          | Disable blocking and allow taps again                             |
| `blockFor(Duration)` | Block taps for the specified duration, then automatically unblock |

---

## Example

```dart
import 'package:flutter/material.dart';
import 'package:screen_tap_blocker/screen_tap_blocker.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _isBlocked = false;

  Future<void> _blockTaps() async {
    await ScreenTapBlocker.enable();
    setState(() => _isBlocked = true);
  }

  Future<void> _unblockTaps() async {
    await ScreenTapBlocker.disable();
    setState(() => _isBlocked = false);
  }

  Future<void> _blockTapsFor5Sec() async {
    await ScreenTapBlocker.blockFor(Duration(seconds: 5));
    setState(() => _isBlocked = true);
    Future.delayed(Duration(seconds: 5), () {
      setState(() => _isBlocked = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen Tap Blocker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isBlocked ? 'Taps are blocked' : 'Taps are allowed',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBlocked ? null : _blockTaps,
              child: Text('Block taps'),
            ),
            ElevatedButton(
              onPressed: !_isBlocked ? null : _unblockTaps,
              child: Text('Unblock taps'),
            ),
            ElevatedButton(
              onPressed: _isBlocked ? null : _blockTapsFor5Sec,
              child: Text('Block taps for 5 seconds'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Platform Support

| Platform | Support         |
| -------- | --------------- |
| Android  | ✔ Supported     |
| iOS      | ✔ Supported     |
| Web      | ❌ Not supported |
| Desktop  | ❌ Not supported |

---

## License

This project is licensed under the MIT License — see the [LICENSE](https://github.com/aibekdv/screen_tap_blocker/blob/main/LICENSE) file for details.

---

## Repository and Support

Source code available on GitHub:
[https://github.com/aibekdv/screen\_tap\_blocker](https://github.com/aibekdv/screen_tap_blocker)

If you have questions, feature requests, or bug reports, please open an issue or submit a pull request.

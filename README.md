<p align="center">
  <a href="https://pub.dev/packages/state_button">
    <img src="https://img.shields.io/pub/v/state_button?color=blueviolet"/>
  </a>
  <a href="https://pub.dev/packages/state_button/score">
    <img src="https://img.shields.io/pub/points/state_button?logo=dart"/>
  </a>
  <a href="https://pub.dev/packages/state_button/score">
    <img src="https://img.shields.io/pub/likes/state_button?logo=dart"/>
  </a>
  <img src="https://img.shields.io/badge/Platform-Flutter-blue?logo=flutter"/>
  <a href="https://github.com/ashiqu-ali/state_button/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/ashiqu-ali/state_button"/>
  </a>
  <a href="https://github.com/ashiqu-ali/state_button">
    <img src="https://img.shields.io/github/stars/ashiqu-ali/state_button?style=social"/>
  </a>
</p>

# state_button

An animated Flutter button that transitions through **idle → loading → success / failure → idle** with zero boilerplate.

---

## Features

- 🎯 Four phases: `idle`, `loading`, `success`, `failure`
- ✨ Animated tick (✓) and cross (✗) drawn with `CustomPainter`
- 🔒 Tap-lock during loading – no double-submission guard needed
- 🔄 Auto-resets to idle after success or failure
- 🎨 Fully customisable: colours, radius, shadow, size, duration
- 🌀 **Six built-in loader styles** – from classic iOS spinner to modern animated dots
- 📦 Zero external dependencies beyond Flutter itself

---

## Installation

Run this command:

```bash
flutter pub add state_button
```

Or add manually to `pubspec.yaml`:

```yaml
dependencies:
  state_button: ^latest-version
```

Then run `flutter pub get` and import:

```dart
import 'package:state_button/state_button.dart';
```

---

## Previews

### 1 · Primary filled button

> Solid indigo fill, white label. Demonstrates a **failure** flow.

<p align="center">
  <img src="https://raw.githubusercontent.com/ashiqu-ali/state_button/refs/heads/main/assets/fill-button.gif"/>
</p>

```dart
StateButton(
  controller: _ctrl,
  width: double.infinity,
  onPressed: () async {
    _ctrl.setLoading();
    await Future.delayed(const Duration(seconds: 2));
    _ctrl.setFailure();
  },
  child: const Text(
    'Submit',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),
)
```

---

### 2 · Outlined / custom decoration button

> White background with a coloured border. Success and failure icons use matching brand colours instead of white.

<p align="center">
  <img src="https://raw.githubusercontent.com/ashiqu-ali/state_button/refs/heads/main/assets/outlined-button.gif" />
</p>

```dart
StateButton(
  controller: _ctrl,
  width: double.infinity,
  backgroundColor: Colors.white,
  successColor: const Color(0xFF22C55E),
  failureColor: const Color(0xFFEF4444),
  successIconColor: const Color(0xFF22C55E),
  failureIconColor: const Color(0xFFEF4444),
  loadingColor: const Color(0xFF6366F1),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ],
  onPressed: () async {
    _ctrl.setLoading();
    await Future.delayed(const Duration(seconds: 2));
    _ctrl.setSuccess();
  },
  child: const Text(
    'Upload File',
    style: TextStyle(color: Color(0xFF6366F1), fontSize: 15),
  ),
)
```

---

### 3 · Button with icon + label

> Fully rounded pill shape with a dark background and an icon-label row child. Demonstrates a **success** flow with a custom `autoResetDuration`.

<p align="center">
  <img src="https://raw.githubusercontent.com/ashiqu-ali/state_button/refs/heads/main/assets/icon-with-label.gif" />
</p>

```dart
StateButton(
  controller: _ctrl,
  borderRadius: 999,
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  backgroundColor: const Color(0xFF0F172A),
  autoResetDuration: const Duration(seconds: 2),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ],
  onPressed: () async {
    _ctrl.setLoading();
    await Future.delayed(const Duration(milliseconds: 1500));
    _ctrl.setSuccess();
  },
  child: const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 18),
      SizedBox(width: 8),
      Text(
        'Deploy',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    ],
  ),
)
```

---

## Loader Types

`state_button` ships with **six built-in loading indicators** via `SbLoaderType`. Pass the desired style to the `loaderType` parameter — it defaults to `cupertinoSpinner` for full backward compatibility.

```dart
StateButton(
  controller: _ctrl,
  loaderType: SbLoaderType.spinningArc, // ← pick any style
  onPressed: () async {
    _ctrl.setLoading();
    await Future.delayed(const Duration(seconds: 2));
    _ctrl.setSuccess();
  },
  child: const Text('Submit'),
)
```

| Loader | `SbLoaderType` value | Description |
|--------|----------------------|-------------|
| iOS-style spinner | `cupertinoSpinner` *(default)* | Uses `CupertinoActivityIndicator` — preserves original behaviour |
| Circular progress | `circular` | Continuously rotating full-circle stroke via `CircularProgressIndicator` |
| Wave dots | `dotsWave` | Three dots animated in a smooth sine-based wave with phase shifts |
| Pulse dots | `dotsPulse` | Three dots that scale in and out sequentially — a rhythmic "breathing" effect |
| Progressive dots | `progressiveDots` | Four dots shifting right-to-left; leading dot fades out as a new one appears |
| Spinning arc | `spinningArc` | A partial arc with a rounded cap that rotates — modern and minimal |


---

## API Reference

### `SbController`

| Member | Type | Description |
|--------|------|-------------|
| `phase` | `SbPhase` | Current phase (read-only) |
| `setIdle()` | `void` | Reset to tappable idle state |
| `setLoading()` | `void` | Show spinner, block taps |
| `setSuccess()` | `void` | Show animated ✓, then auto-reset |
| `setFailure()` | `void` | Show animated ✗, then auto-reset |
| `dispose()` | `void` | Release resources — call in `dispose()` |

### `SbPhase`

```dart
enum SbPhase { idle, loading, success, failure }
```

### `SbLoaderType`

```dart
enum SbLoaderType {
  cupertinoSpinner, // default
  circular,
  dotsWave,
  dotsPulse,
  progressiveDots,
  spinningArc,
}
```

### `StateButton` parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `SbController` | **required** | Drives phase transitions |
| `onPressed` | `VoidCallback` | **required** | Called on tap (idle phase only) |
| `child` | `Widget` | `Text('Submit')` | Widget shown in idle phase |
| `loaderType` | `SbLoaderType` | `cupertinoSpinner` | Style of loading indicator shown during loading phase |
| `width` | `double?` | `null` | Fixed width; `null` = stretch |
| `height` | `double` | `52` | Fixed height in logical pixels |
| `padding` | `EdgeInsetsGeometry` | `h:24 v:12` | Inner padding |
| `margin` | `EdgeInsetsGeometry` | `zero` | Outer margin |
| `borderRadius` | `double` | `12` | Corner radius; use `999` for pill |
| `backgroundColor` | `Color` | `#6366F1` | Fill colour in idle phase |
| `successColor` | `Color` | `#22C55E` | Fill colour in success phase |
| `failureColor` | `Color` | `#EF4444` | Fill colour in failure phase |
| `splashColor` | `Color?` | white 15% | Ink splash on tap |
| `highlightColor` | `Color?` | white 8% | Ink highlight on long-press |
| `decoration` | `BoxDecoration?` | `null` | Overrides all container decoration |
| `boxShadow` | `List<BoxShadow>?` | `null` | Drop shadows (ignored if `decoration` set) |
| `indicatorSize` | `double` | `26` | Diameter of spinner / tick / cross |
| `loadingColor` | `Color` | `white` | Spinner colour |
| `successIconColor` | `Color` | `white` | Tick + circle stroke colour |
| `failureIconColor` | `Color` | `white` | Cross + circle stroke colour |
| `autoResetDuration` | `Duration` | `1 800 ms` | Time before auto-reset to idle |
| `animationDuration` | `Duration` | `300 ms` | Colour fade + content crossfade speed |

---

## ☕ Support

<p align="center">
  <a href="https://www.buymeacoffee.com/ashiqu.ali">
    <img src="https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=%E2%98%95&slug=ashiqu.ali&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff"/>
  </a>
</p>

---

## 🌐 Connect

<p align="center">
  <a href="https://www.linkedin.com/in/ashiqu-ali">
    <img src="https://cdn-icons-png.flaticon.com/512/174/174857.png" width="30"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://ashiqu-ali.medium.com/">
    <img src="https://cdn-icons-png.flaticon.com/512/5968/5968906.png" width="30"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://www.instagram.com/ashiqu_ali_">
    <img src="https://cdn-icons-png.flaticon.com/512/174/174855.png" width="30"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://x.com/ashiquali007">
    <img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" width="30"/>
  </a>
</p>
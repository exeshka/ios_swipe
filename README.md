# 🌀 ios_swipe

A lightweight Flutter package that brings **iOS-style swipe-back navigation** with **parallax effect** to your Flutter apps — just like native iPhone navigation. Perfect for **GoRouter** integration.

---

## 🎥 Demo

<p align="center">
  <img src="video/gif1.gif" alt="iOS Swipe Demo" width="300"/>
</p>
---

## ✨ Features

- 🧭 **iOS-native swipe gesture** — Pull from the edge to go back
- 💫 **Parallax effect** — Previous page slides smoothly like in iPhone
- 🎯 **GoRouter ready** — Drop-in replacement for standard transitions
- 🔥 **Fully interactive** — Page follows your finger in real-time
- 🎨 **Rounded corners** — Automatically adds iOS-style border radius during swipe
- ⚡ **Lightweight** — Zero dependencies, pure Flutter

---

## 🚀 Getting Started

Add this package directly from PUB.DEV:

```yaml
dependencies:
  ios_swipe:
```

Or from GitHub:

```yaml
dependencies:
  ios_swipe:
    git:
      url: https://github.com/exeshka/ios_swipe.git
      ref: main 
```

---

## 🧩 Usage Example

### Basic Usage with GoRouter

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ios_swipe/ios_swipe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData.dark(),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildIosSwipeTransition(
        child: HomePage(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/details',
      pageBuilder: (context, state) => buildIosSwipeTransition(
        child: DetailsPage(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => buildIosSwipeTransition(
        child: ProfilePage(),
        state: state,
      ),
    ),
  ],
);
```

### Custom Configuration

```dart
GoRoute(
  path: '/settings',
  pageBuilder: (context, state) => buildIosSwipeTransition(
    child: SettingsPage(),
    state: state,
    maintainState: true,        // Keep state when navigating away
    fullscreenDialog: false,    // Not a modal dialog
  ),
),
```

---

## 🎮 How It Works

1. **Swipe from left edge** — Start dragging from the left side of the screen
2. **Page follows** — Current page moves right, previous page slides from behind
3. **Release** — If you swiped more than 30% or with velocity > 500px/s, page pops
4. **Snap back** — Otherwise, it smoothly returns to position

**Just like iPhone! 📱**

---

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| iOS      | ✅ Full support |
| Android  | ✅ Full support |
| Web      | ❌ Not supported |
| Desktop  | ⚠️ Experimental |

---


## 🙏 Credits

Made with ❤️ by [exeshka](https://github.com/exeshka)

Inspired by iOS native navigation and the Flutter community.

---

## 📚 Additional Resources

- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation Guide](https://docs.flutter.dev/development/ui/navigation)
- [CustomTransitionPage API](https://api.flutter.dev/flutter/widgets/CustomTransitionPage-class.html)

---

**Star ⭐ this repo if you found it useful!** 
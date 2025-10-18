
# 🌀 ios_swipe

A lightweight Flutter package that brings **iOS-style swipe-back navigation** (like in native iPhone apps) to your Flutter pages — especially useful when using **GoRouter**.

---

## ✨ Features

- 🧭 Smooth iOS-style back-swipe gesture  
- 💫 Seamless integration with `GoRouter`  
- 🧱 Fully customizable transition  
- 🔥 Works on both Android and iOS  

---

## 🚀 Getting Started

Add this package directly from GitHub:

```yaml
dependencies:
  ios_swipe:
    git:
      url: https://github.com/exeshka/ios_swipe.git
      ref: main
```

⸻

## 🧩 Usage Example

# Integrate with GoRouter easily:
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ios_swipe/ios_swipe.dart';

final goRouter = GoRouter(
  initialLocation: FirstPage.path,
  routes: [
    GoRoute(
      path: FirstPage.path,
      name: FirstPage.name,
      pageBuilder: (context, state) => IosSwipePage(
        key: state.pageKey,
        child: const FirstPage(),
      ),
    ),
    GoRoute(
      path: SecondPage.path,
      name: SecondPage.name,
      pageBuilder: (context, state) => IosSwipePage(
        key: state.pageKey,
        child: const SecondPage(),
      ),
      routes: [
        GoRoute(
          path: OtherScreen.path,
          name: OtherScreen.name,
          pageBuilder: (context, state) => IosSwipePage(
            key: state.pageKey,
            child: const OtherScreen(),
          ),
        ),
      ],
    ),
  ],
);
```
⸻

# 📱 Platform Support

# iOS	✅
# Android	✅
# Web	❌
# Desktop	⚠️ (Experimental)


⸻

❤️ Contributing

Pull requests and improvements are always welcome!
If you find a bug or have an idea for improvement — feel free to open an issue.

⸻

# 📄 License

This package is distributed under the MIT License.
See the LICENSE file for more information.

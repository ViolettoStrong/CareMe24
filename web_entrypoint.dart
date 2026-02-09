import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:careme24/main.dart' as app;

void main() async {
  // Web does NOT support Firebase for this project → skip
  if (kIsWeb) {
    debugPrint(
        "🔥 WEB MODE: Firebase, notifications, background service DISABLED");
  }

  // Runs the Flutter app without any heavy initialization
  app.mainForWeb();
}

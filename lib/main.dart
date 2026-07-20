import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/macro_tracker_app.dart';
import 'core/providers/providers.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables (if .env file exists)
  // await dotenv.load(fileName: '.env');
  
  runApp(
    ProviderScope(
      observers: [AppRiverpodObserver()],
      child: const MacroTrackerApp(),
    ),
  );
}

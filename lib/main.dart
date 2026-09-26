import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await bootstrap();
  runApp(
    ProviderScope(
      overrides: overrides,
      // All data is local: an error won't fix itself by retrying, and each
      // screen offers its own retry action.
      retry: (retryCount, error) => null,
      child: const HadeelApp(),
    ),
  );
}

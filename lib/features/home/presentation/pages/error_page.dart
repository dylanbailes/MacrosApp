// Path: pages\error_page.dart
import 'package:flutter/material.dart';

/// Error page displayed when a route is not found.
class ErrorPage extends StatelessWidget {
  final String routePath;

  const ErrorPage({required this.routePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Route: $routePath',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

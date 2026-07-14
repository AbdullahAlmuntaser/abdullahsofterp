import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessDenied)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              l10n.accessDeniedMessage,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text(l10n.backToHome),
            ),
          ],
        ),
      ),
    );
  }
}

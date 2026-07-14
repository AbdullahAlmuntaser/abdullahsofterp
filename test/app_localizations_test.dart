import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('AppLocalizations loads Arabic strings', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          expect(l10n.dashboard, isNotEmpty);
          expect(l10n.products, isNotEmpty);
          expect(l10n.sales, isNotEmpty);
          return const SizedBox();
        },
      ),
    ));
  });

  testWidgets('AppLocalizations loads English strings', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          expect(l10n.dashboard, isNotEmpty);
          expect(l10n.products, isNotEmpty);
          expect(l10n.sales, isNotEmpty);
          return const SizedBox();
        },
      ),
    ));
  });

  test('All supported locales are valid', () {
    const locales = AppLocalizations.supportedLocales;
    expect(locales, contains(const Locale('ar')));
    expect(locales, contains(const Locale('en')));
  });
}

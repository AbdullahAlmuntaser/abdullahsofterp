#!/usr/bin/env dart
// Utility to find hardcoded Arabic strings in presentation files
// Run: dart tool/find_hardcoded_arabic.dart

import 'dart:io';

void main() {
  var total = 0;
  for (final file in Directory('lib').listSync(recursive: true)) {
    if (file is! File || !file.path.endsWith('.dart')) continue;
    final content = file.readAsStringSync();
    final arabicMatches = RegExp(r"'(?:[^'\\]|\\.)*[\u0600-\u06FF][^']*'").allMatches(content);
    
    if (arabicMatches.isNotEmpty) {
      stderr.writeln('\n${file.path}:');
      for (final match in arabicMatches) {
        final line = content.substring(0, match.start).split('\n').length;
        stderr.writeln('  L$line: ${match.group(0)}');
        total++;
      }
    }
  }
  stderr.writeln('\nTotal hardcoded Arabic strings found: $total');
}

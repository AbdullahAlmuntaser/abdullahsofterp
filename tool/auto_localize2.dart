// dart run tool/auto_localize2.dart
// Replaces hardcoded Arabic strings with AppLocalizations.
// Only handles strings WITHOUT Dart interpolation ($ or ${}).

import 'dart:io';

final arabicRegex = RegExp(r'[\u0600-\u06FF]');
final interpolation = RegExp(r'\$');
final hasInterpolation = RegExp(r'\$\{|\$\w');

void main() {
  final dartFiles = <String>[];
  _collectFiles('lib/presentation', dartFiles);

  // First pass: collect ALL simple (non-interpolated) Arabic strings
  final stringMap = <String, _Info>{};
  final usedKeys = <String>{};

  for (final filePath in dartFiles) {
    final content = File(filePath).readAsStringSync();
    final lines = content.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (!arabicRegex.hasMatch(line)) continue;
      final strings = _extractSimpleStrings(line);
      for (final s in strings) {
        if (hasInterpolation.hasMatch(s)) continue; // skip interpolated
        if (s.trim().isEmpty) continue;
        final key = _toKey(s);
        var finalKey = key;
        // Ensure uniqueness
        var suffix = 0;
        while (usedKeys.contains(finalKey)) {
          suffix++;
          finalKey = '${key}_$suffix';
        }
        usedKeys.add(finalKey);
        if (!stringMap.containsKey(finalKey)) {
          stringMap[finalKey] = _Info(text: s, key: finalKey);
        }
        stringMap[finalKey]!.files.add(filePath);
      }
    }
  }

  stderr.writeln('Unique simple (non-interpolated) Arabic strings: ${stringMap.length}');

  // Read existing ARB keys
  final existingKeysAr = <String>{};
  final arbAr = File('lib/l10n/app_ar.arb').readAsStringSync();
  for (final m in RegExp(r'"(\w+)":\s*"').allMatches(arbAr)) {
    existingKeysAr.add(m.group(1)!);
  }
  final existingKeysEn = <String>{};
  final arbEn = File('lib/l10n/app_en.arb').readAsStringSync();
  for (final m in RegExp(r'"(\w+)":\s*"').allMatches(arbEn)) {
    existingKeysEn.add(m.group(1)!);
  }

  // Add new keys to ARB
  final newKeys = stringMap.keys.where((k) => !existingKeysAr.contains(k)).toList();
  // Sort by key for consistency
  newKeys.sort();

  if (newKeys.isNotEmpty) {
    final arLines = <String>[];
    final enLines = <String>[];
    for (final key in newKeys) {
      final text = stringMap[key]!.text;
      // Escape backslashes and double quotes for JSON
      var escaped = text.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
      arLines.add('  "$key": "$escaped"');
      // For English, use the same text (or could transliterate)
      enLines.add('  "$key": "$escaped"');
    }

    // Append to ARB files
    for (final entry in [
      {'lines': arLines, 'path': 'lib/l10n/app_ar.arb'},
      {'lines': enLines, 'path': 'lib/l10n/app_en.arb'},
    ]) {
      final path = entry['path'] as String;
      var content = File(path).readAsStringSync().trim();
      // Insert before closing brace
      final lines = (entry['lines'] as List<String>).join(',\n');
      content = '${content.substring(0, content.length - 1)},\n$lines\n}';
      File(path).writeAsStringSync(content);
    }
    stderr.writeln('Added ${newKeys.length} new keys to ARB files.');
  }

  // Replace in Dart files
  for (final filePath in dartFiles) {
    var content = File(filePath).readAsStringSync();
    final lines = content.split('\n');
    var modified = false;

    final newLines = <String>[];
    for (final line in lines) {
      if (!arabicRegex.hasMatch(line)) {
        newLines.add(line);
        continue;
      }

      var newLine = line;
      final strings = _extractSimpleStrings(line);
      for (final s in strings) {
        if (hasInterpolation.hasMatch(s)) continue;
        final key = _findKey(stringMap, s);
        if (key == null) continue;

        // Escape for regex matching
        final escaped = RegExp.escape(s);
        // Replace quoted string with AppLocalizations call
        newLine = newLine.replaceAllMapped(
          RegExp("'$escaped'"),
          (_) => "AppLocalizations.of(context)!.$key",
        );
        newLine = newLine.replaceAllMapped(
          RegExp('"$escaped"'),
          (_) => "AppLocalizations.of(context)!.$key",
        );
      }

      if (newLine != line) {
        modified = true;
        // Remove `const` before `AppLocalizations.of(context)`
        newLine = newLine.replaceAllMapped(
          RegExp(r'\bconst\s+(?=AppLocalizations\.of\(context\))'),
          (_) => '',
        );
      }
      newLines.add(newLine);
    }

    if (modified) {
      content = newLines.join('\n');
      // Add import if needed
      if (!content.contains("import 'package:flutter_gen/gen_l10n/app_localizations.dart'")) {
        content = content.replaceAllMapped(
          RegExp(r'^(import .+)$', multiLine: true),
          (m) {
            // Find last import
            return m.group(0)!;
          },
        );
        // Add after last import
        final importLines = content.split('\n');
        var lastImport = -1;
        for (var i = 0; i < importLines.length; i++) {
          if (importLines[i].startsWith('import ')) {
            lastImport = i;
          }
        }
        if (lastImport >= 0) {
          importLines.insert(
            lastImport + 1,
            "import 'package:flutter_gen/gen_l10n/app_localizations.dart';",
          );
          content = importLines.join('\n');
        }
      }

      // Fix: remove `const ` before `AppLocalizations.of(context)` (in case any remain)
      content = content.replaceAll(
        'const AppLocalizations.of(context)',
        'AppLocalizations.of(context)',
      );

      File(filePath).writeAsStringSync(content);
      stderr.writeln('Updated: $filePath');
    }
  }

  stderr.writeln('\nDone! Now run: flutter gen-l10n && flutter analyze');
}

String? _findKey(Map<String, _Info> map, String text) {
  for (final entry in map.entries) {
    if (entry.value.text == text) return entry.key;
  }
  return null;
}

List<String> _extractSimpleStrings(String line) {
  final result = <String>[];
  // Match single-quoted strings containing Arabic
  // Using a simpler approach: find strings between quotes that contain Arabic
  var i = 0;
  while (i < line.length) {
    // Find opening quote
    if (line[i] == "'" || line[i] == '"') {
      final quote = line[i];
      var j = i + 1;
      var sb = StringBuffer();
      var escape = false;
      while (j < line.length) {
        if (escape) {
          sb.write(line[j]);
          escape = false;
          j++;
          continue;
        }
        if (line[j] == '\\') {
          sb.write(line[j]);
          escape = true;
          j++;
          continue;
        }
        if (line[j] == quote) {
          // End of string
          final s = sb.toString();
          if (arabicRegex.hasMatch(s)) {
            result.add(s);
          }
          break;
        }
        sb.write(line[j]);
        j++;
      }
      i = j + 1;
    } else {
      i++;
    }
  }
  return result;
}

void _collectFiles(String dir, List<String> result) {
  final entities = Directory(dir).listSync(recursive: true);
  for (final e in entities) {
    if (e is File &&
        e.path.endsWith('.dart') &&
        !e.path.contains('.g.dart') &&
        !e.path.contains('.freezed.dart')) {
      result.add(e.path);
    }
  }
}

String _toKey(String s) {
  // Build camelCase key from Arabic text
  var key = '';
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (_isArabic(c) || c == ' ') {
      // Convert Arabic character to Latin approximation
      final latin = _arabicToLatin(c);
      if (c == ' ' && key.isNotEmpty) {
        key += latin; // space becomes underscore in Latin mapping
      } else {
        key += latin;
      }
    } else if (c == '_' || c == '-') {
      key += '_';
    } else {
      key += c;
    }
  }

  // Clean up: remove consecutive underscores, trim trailing/leading underscores
  key = key.replaceAll(RegExp(r'_+'), '_');
  key = key.replaceAll(RegExp(r'^_|_$'), '');

  // Ensure it doesn't start with a digit
  if (key.isNotEmpty && RegExp(r'^\d').hasMatch(key[0])) {
    key = 'n$key';
  }

  // Ensure lowercase start
  if (key.isNotEmpty && key[0].toUpperCase() == key[0] && RegExp(r'^[A-Z]').hasMatch(key[0])) {
    key = key[0].toLowerCase() + key.substring(1);
  }

  // Ensure min length and validity
  if (key.isEmpty || key.length < 2) {
    key = 'str_${s.hashCode.abs()}';
  }

  // Truncate if too long (max 60 chars)
  if (key.length > 60) {
    key = key.substring(0, 60);
    // Remove trailing underscore if any
    key = key.replaceAll(RegExp(r'_+$'), '');
  }

  return key;
}

bool _isArabic(String c) {
  return c.codeUnitAt(0) >= 0x0600 && c.codeUnitAt(0) <= 0x06FF;
}

String _arabicToLatin(String c) {
  if (c == ' ') return '_';
  final map = <String, String>{
    'ا': 'a', 'أ': 'a', 'آ': 'a', 'ب': 'b', 'ت': 't',
    'ث': 'th', 'ج': 'j', 'ح': 'h', 'خ': 'kh', 'د': 'd',
    'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh',
    'ص': 's', 'ض': 'd', 'ط': 't', 'ظ': 'z', 'ع': 'a',
    'غ': 'gh', 'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l',
    'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w', 'ي': 'y',
    'ة': 'h', 'ى': 'a', 'ئ': 'e', 'ء': 'a', 'ؤ': 'w',
    'إ': 'i', '؟': '', '،': '', '.': '', ':': '', '!': '',
    '0': '0', '1': '1', '2': '2', '3': '3', '4': '4',
    '5': '5', '6': '6', '7': '7', '8': '8', '9': '9',
  };
  return map[c] ?? c;
}

class _Info {
  final String text;
  final String key;
  final List<String> files;
  _Info({required this.text, required this.key}) : files = [];
}

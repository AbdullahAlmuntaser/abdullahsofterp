// dart run tool/build_arb_dict.dart
// Safely builds ARB dictionary from hardcoded Arabic strings.
// ONLY adds simple strings without ICU-incompatible characters.

import 'dart:io';

final arabicRegex = RegExp(r'[\u0600-\u06FF]');

void main() {
  final dartFiles = <String>[];
  _collectFiles('lib/presentation', dartFiles);

  // Collect all unique simple Arabic strings
  final allStrings = <String>{};
  for (final filePath in dartFiles) {
    final content = File(filePath).readAsStringSync();
    for (final m in _extractAllStrings(content)) {
      if (m.contains(r'$') || m.contains('{') || m.contains('}')) continue;
      if (m.trim().isEmpty) continue;
      if (m.length < 2) continue;
      allStrings.add(m);
    }
  }

  final sorted = allStrings.toList()..sort();
  stderr.writeln('Simple Arabic strings to add: ${sorted.length}');

  // Read existing keys
  final existingKeys = <String>{};
  for (final lang in ['ar', 'en']) {
    final content = File('lib/l10n/app_$lang.arb').readAsStringSync();
    for (final m in RegExp(r'"(\w+)":\s*"').allMatches(content)) {
      existingKeys.add(m.group(1)!);
    }
  }

  // Generate new entries
  final arEntries = <String>[];
  final enEntries = <String>[];
  var added = 0;

  for (final text in sorted) {
    final key = _genKey(text, existingKeys);
    if (key == null) continue;
    existingKeys.add(key);
    final escaped = text.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
    arEntries.add('  "$key": "$escaped"');
    enEntries.add('  "$key": "$escaped"');
    added++;
  }

  // Append to ARB files
  for (final entry in [
    {'path': 'lib/l10n/app_ar.arb', 'lines': arEntries},
    {'path': 'lib/l10n/app_en.arb', 'lines': enEntries},
  ]) {
    var content = File(entry['path'] as String).readAsStringSync().trim();
    final lines = (entry['lines'] as List<String>).join(',\n');
    content = '${content.substring(0, content.length - 1)},\n$lines\n}';
    File(entry['path'] as String).writeAsStringSync(content);
  }

  stderr.writeln('Added $added new keys to ARB files.');
}

String? _genKey(String text, Set<String> existing) {
  var latin = StringBuffer();
  var nextUpper = false;
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (RegExp(r'[a-zA-Z0-9]').hasMatch(c)) {
      if (nextUpper) {
        latin.write(c.toUpperCase());
        nextUpper = false;
      } else {
        latin.write(c);
      }
    } else if (c == ' ' || c == '-' || c == '.') {
      nextUpper = true;
    } else if (_isArabic(c)) {
      final l = _toLatin(c);
      if (nextUpper) {
        latin.write(l.toUpperCase());
        nextUpper = false;
      } else {
        latin.write(l);
      }
    }
  }

  var key = latin.toString();
  if (key.isEmpty || key.length < 2) return null;
  if (RegExp(r'^\d').hasMatch(key)) key = 'n$key';
  if (RegExp(r'^[A-Z]').hasMatch(key[0])) {
    key = key[0].toLowerCase() + key.substring(1);
  }
  if (key.length > 50) key = key.substring(0, 50);

  // Ensure uniqueness
  var finalKey = key;
  var suffix = 0;
  while (existing.contains(finalKey)) {
    suffix++;
    finalKey = '${key}_$suffix';
  }

  return finalKey;
}

bool _isArabic(String c) =>
    c.codeUnitAt(0) >= 0x0600 && c.codeUnitAt(0) <= 0x06FF;

String _toLatin(String c) {
  const map = {
    'ا': 'a', 'أ': 'a', 'آ': 'a', 'ب': 'b', 'ت': 't',
    'ث': 'th', 'ج': 'j', 'ح': 'h', 'خ': 'kh', 'د': 'd',
    'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh',
    'ص': 's', 'ض': 'd', 'ط': 't', 'ظ': 'z', 'ع': 'a',
    'غ': 'gh', 'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l',
    'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w', 'ي': 'y',
    'ة': 'h', 'ى': 'a', 'ئ': 'e', 'ء': 'a', 'ؤ': 'w',
    'إ': 'i',
  };
  return map[c] ?? '';
}

List<String> _extractAllStrings(String content) {
  final result = <String>[];
  var i = 0;
  while (i < content.length) {
    if (content[i] == "'" || content[i] == '"') {
      final quote = content[i];
      var j = i + 1;
      var sb = StringBuffer();
      var escape = false;
      while (j < content.length) {
        if (escape) { sb.write(content[j]); escape = false; j++; continue; }
        if (content[j] == '\\') { sb.write(content[j]); escape = true; j++; continue; }
        if (content[j] == quote) break;
        sb.write(content[j]);
        j++;
      }
      final s = sb.toString();
      if (arabicRegex.hasMatch(s)) {
        result.add(s);
      }
      i = j + 1;
    } else {
      i++;
    }
  }
  return result;
}

void _collectFiles(String dir, List<String> result) {
  for (final e in Directory(dir).listSync(recursive: true)) {
    if (e is File && e.path.endsWith('.dart') &&
        !e.path.contains('.g.dart') && !e.path.contains('.freezed.dart')) {
      result.add(e.path);
    }
  }
}

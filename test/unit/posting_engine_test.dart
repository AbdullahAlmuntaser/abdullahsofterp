import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket/core/services/posting_engine.dart';

void main() {
  group('PostingEngine - Validation Tests', () {
    test('PostingLine constructor works', () {
      final line = PostingLine(
        account: '1010',
        debit: Decimal.fromInt(100),
        credit: Decimal.zero,
      );
      expect(line.account, equals('1010'));
      expect(line.debit, equals(Decimal.fromInt(100)));
      expect(line.credit, equals(Decimal.zero));
    });

    test('PostingLine accepts negative debit', () {
      final line = PostingLine(
        account: '1010',
        debit: Decimal.fromInt(-100),
        credit: Decimal.zero,
      );
      expect(line.debit, equals(Decimal.fromInt(-100)));
    });

    test('PostingLine accepts both debit and credit', () {
      final line = PostingLine(
        account: '1010',
        debit: Decimal.fromInt(100),
        credit: Decimal.fromInt(100),
      );
      expect(line.debit, equals(Decimal.fromInt(100)));
      expect(line.credit, equals(Decimal.fromInt(100)));
    });

    test('PostingLine accepts zero values', () {
      final line = PostingLine(
        account: '1010',
        debit: Decimal.zero,
        credit: Decimal.zero,
      );
      expect(line.account, equals('1010'));
    });

    test('PostingLine accepts empty account', () {
      final line = PostingLine(account: '', debit: Decimal.zero, credit: Decimal.zero);
      expect(line.account, isEmpty);
    });
  });

  group('PostingEngine - Balance Validation', () {
    test('validatePostingLines throws on unbalanced entry', () {
      final lines = [
        PostingLine(
          account: '1010',
          debit: Decimal.fromInt(100),
          credit: Decimal.zero,
        ),
        PostingLine(
          account: '4010',
          debit: Decimal.zero,
          credit: Decimal.fromInt(90),
        ),
      ];

      expect(
        () => PostingEngine.validatePostingLines(lines),
        throwsA(isA<Exception>()),
      );
    });

    test('validatePostingLines accepts balanced entry', () {
      final lines = [
        PostingLine(
          account: '1010',
          debit: Decimal.fromInt(100),
          credit: Decimal.zero,
        ),
        PostingLine(
          account: '4010',
          debit: Decimal.zero,
          credit: Decimal.fromInt(100),
        ),
      ];

      expect(
        () => PostingEngine.validatePostingLines(lines),
        returnsNormally,
      );
    });

    test('validatePostingLines accepts entry within tolerance', () {
      final lines = [
        PostingLine(
          account: '1010',
          debit: Decimal.parse('100.00'),
          credit: Decimal.zero,
        ),
        PostingLine(
          account: '4010',
          debit: Decimal.zero,
          credit: Decimal.parse('100.001'),
        ),
      ];

      expect(
        () => PostingEngine.validatePostingLines(lines),
        returnsNormally,
      );
    });

    test('validatePostingLines throws on empty lines', () {
      expect(
        () => PostingEngine.validatePostingLines([]),
        throwsA(isA<Exception>()),
      );
    });

    test('validatePostingLines throws on single line', () {
      final lines = [
        PostingLine(
          account: '1010',
          debit: Decimal.fromInt(100),
          credit: Decimal.zero,
        ),
      ];

      expect(
        () => PostingEngine.validatePostingLines(lines),
        throwsA(isA<Exception>()),
      );
    });
  });
}

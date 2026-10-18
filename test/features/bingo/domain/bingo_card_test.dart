import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_card.dart';

void main() {
  group('CardId', () {
    test('serializes to and from string JSON', () {
      final CardId cardId = CardId.fromJson('1');

      expect(cardId, const CardId('1'));
      expect(cardId.toJson(), '1');
    });
  });

  group('CardIdMapConverter', () {
    const CardIdMapConverter converter = CardIdMapConverter();

    test('converts JSON map with string keys to CardId map', () {
      final Map<String, Object?> json = <String, Object?>{'1': 2, '2': 5};

      final Map<CardId, int> map = converter.fromJson(json);

      expect(map, <CardId, int>{const CardId('1'): 2, const CardId('2'): 5});
    });

    test('falls back to 0 count for non-integer JSON values', () {
      final Map<String, Object?> json = <String, Object?>{
        '1': 'invalid',
        '2': null,
      };

      final Map<CardId, int> map = converter.fromJson(json);

      expect(map, <CardId, int>{const CardId('1'): 0, const CardId('2'): 0});
    });

    test('converts CardId map to JSON string map', () {
      final Map<CardId, int> map = <CardId, int>{
        const CardId('1'): 3,
        const CardId('2'): 1,
      };

      final Map<String, Object?> json = converter.toJson(map);

      expect(json, <String, Object?>{'1': 3, '2': 1});
    });
  });

  group('BingoCard', () {
    test('type1 card initialized with correct ID and 25 numbers', () {
      const BingoCard card1 = BingoCard.type1();

      expect(card1.id, const CardId('1'));
      expect(card1.numbers, hasLength(25));
    });

    test('type2 card initialized with correct ID and 25 numbers', () {
      const BingoCard card2 = BingoCard.type2();

      expect(card2.id, const CardId('2'));
      expect(card2.numbers, hasLength(25));
    });

    test('officialCards contains type1 and type2 cards', () {
      expect(BingoCard.officialCards, <BingoCard>[
        const BingoCard.type1(),
        const BingoCard.type2(),
      ]);
    });
  });
}

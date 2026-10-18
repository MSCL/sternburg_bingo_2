import 'package:freezed_annotation/freezed_annotation.dart';

extension type const CardId(String id) implements String {
  factory fromJson(String json) => CardId(json);

  String toJson() => id;
}

final class CardIdMapConverter
    implements JsonConverter<Map<CardId, int>, Map<String, Object?>> {
  const new();

  @override
  Map<CardId, int> fromJson(Map<String, Object?> json) =>
      json.map((String key, Object? value) {
        final int count = value is int ? value : 0;
        return MapEntry<CardId, int>(CardId(key), count);
      });

  @override
  Map<String, Object?> toJson(Map<CardId, int> object) => object.map(
    (CardId key, int value) => MapEntry<String, Object?>(key.id, value),
  );
}

final class BingoCard {
  const new(this.id, this.numbers);

  const new type1()
    : id = const CardId('1'),
      numbers = const <int>[
        3,
        27,
        36,
        89,
        70,
        54,
        90,
        60,
        11,
        48,
        19,
        45,
        2,
        73,
        24,
        67,
        30,
        52,
        26,
        98,
        71,
        13,
        84,
        5,
        33,
      ];

  const new type2()
    : id = const CardId('2'),
      numbers = const <int>[
        10,
        81,
        54,
        29,
        47,
        64,
        4,
        76,
        13,
        92,
        70,
        95,
        50,
        44,
        16,
        28,
        26,
        33,
        77,
        40,
        11,
        53,
        89,
        56,
        2,
      ];

  final CardId id;
  final List<int> numbers;

  static const List<BingoCard> officialCards = <BingoCard>[
    BingoCard.type1(),
    BingoCard.type2(),
  ];
}

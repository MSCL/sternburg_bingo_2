enum FeatureFlag {
  enableNewBingoLayout('enable_new_bingo_layout', defaultValue: false);

  new(this.key, {required this.defaultValue});

  final String key;
  final bool defaultValue;
}

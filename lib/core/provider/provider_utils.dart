Never throwUnimplementedProviderError(String providerName) =>
    throw UnimplementedError(
      '$providerName must be overridden in ProviderScope!',
    );

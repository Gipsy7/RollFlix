class WatchProvider {
  final int providerId;
  final String providerName;
  final String logoPath;
  final int displayPriority;

  WatchProvider({
    required this.providerId,
    required this.providerName,
    required this.logoPath,
    required this.displayPriority,
  });

  factory WatchProvider.fromJson(Map<String, dynamic> json) {
    return WatchProvider(
      providerId: json['provider_id'] ?? 0,
      providerName: json['provider_name'] ?? 'Provedor não disponível',
      logoPath: json['logo_path'] ?? '',
      displayPriority: json['display_priority'] ?? 999,
    );
  }

  String get fullLogoUrl {
    if (logoPath.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w92$logoPath';
    }
    return '';
  }
}

class WatchProviders {
  final String link;
  final List<WatchProvider> flatrate;
  final List<WatchProvider> rent;
  final List<WatchProvider> buy;

  WatchProviders({
    required this.link,
    required this.flatrate,
    required this.rent,
    required this.buy,
  });

  factory WatchProviders.fromJson(Map<String, dynamic> json) {
    return WatchProviders(
      link: json['link'] ?? '',
      flatrate: (json['flatrate'] as List? ?? [])
          .map((provider) => WatchProvider.fromJson(provider))
          .toList(),
      rent: (json['rent'] as List? ?? [])
          .map((provider) => WatchProvider.fromJson(provider))
          .toList(),
      buy: (json['buy'] as List? ?? [])
          .map((provider) => WatchProvider.fromJson(provider))
          .toList(),
    );
  }

  bool get hasProviders {
    return flatrate.isNotEmpty || rent.isNotEmpty || buy.isNotEmpty;
  }
}
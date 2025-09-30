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

  // URLs dos principais provedores de streaming
  String getProviderUrl(String movieTitle, int movieId) {
    switch (providerId) {
      // Netflix
      case 8:
        return 'https://www.netflix.com/search?q=${Uri.encodeComponent(movieTitle)}';
      // Amazon Prime Video
      case 119:
        return 'https://www.primevideo.com/search/ref=atv_nb_sr?phrase=${Uri.encodeComponent(movieTitle)}';
      // Disney+
      case 337:
        return 'https://www.disneyplus.com/search?q=${Uri.encodeComponent(movieTitle)}';
      // HBO Max
      case 384:
        return 'https://www.max.com/search?q=${Uri.encodeComponent(movieTitle)}';
      // Apple TV+
      case 350:
        return 'https://tv.apple.com/search?term=${Uri.encodeComponent(movieTitle)}';
      // Paramount+
      case 531:
        return 'https://www.paramountplus.com/search/?query=${Uri.encodeComponent(movieTitle)}';
      // Globoplay
      case 307:
        return 'https://globoplay.globo.com/busca/?q=${Uri.encodeComponent(movieTitle)}';
      // Crunchyroll
      case 283:
        return 'https://www.crunchyroll.com/search?q=${Uri.encodeComponent(movieTitle)}';
      // YouTube
      case 192:
        return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(movieTitle)}+filme';
      // Google Play Movies
      case 3:
        return 'https://play.google.com/store/search?q=${Uri.encodeComponent(movieTitle)}&c=movies';
      // Apple iTunes
      case 2:
        return 'https://itunes.apple.com/search?term=${Uri.encodeComponent(movieTitle)}&media=movie';
      // Microsoft Store
      case 68:
        return 'https://www.microsoft.com/search/shop/movies?q=${Uri.encodeComponent(movieTitle)}';
      // Vudu
      case 7:
        return 'https://www.vudu.com/content/movies/search/${Uri.encodeComponent(movieTitle)}';
      // Amazon Video
      case 10:
        return 'https://www.amazon.com/s?k=${Uri.encodeComponent(movieTitle)}&i=instant-video';
      default:
        // Busca genérica no Google para provedores não mapeados
        return 'https://www.google.com/search?q=${Uri.encodeComponent(movieTitle)}+${Uri.encodeComponent(providerName)}+filme+assistir';
    }
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
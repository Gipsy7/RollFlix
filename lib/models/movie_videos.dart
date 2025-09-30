class MovieVideo {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;
  final String publishedAt;

  MovieVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
    required this.publishedAt,
  });

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? 'Vídeo não disponível',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
      publishedAt: json['published_at'] ?? '',
    );
  }

  String get youtubeUrl {
    if (site == 'YouTube' && key.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$key';
    }
    return '';
  }

  String get youtubeThumbnailUrl {
    if (site == 'YouTube' && key.isNotEmpty) {
      return 'https://img.youtube.com/vi/$key/maxresdefault.jpg';
    }
    return '';
  }

  bool get isTrailer {
    return type.toLowerCase() == 'trailer';
  }

  bool get isTeaser {
    return type.toLowerCase() == 'teaser';
  }

  bool get isYouTube {
    return site == 'YouTube';
  }
}

class MovieVideos {
  final List<MovieVideo> results;

  MovieVideos({required this.results});

  factory MovieVideos.fromJson(Map<String, dynamic> json) {
    return MovieVideos(
      results: (json['results'] as List? ?? [])
          .map((videoJson) => MovieVideo.fromJson(videoJson))
          .toList(),
    );
  }

  List<MovieVideo> get trailers {
    return results
        .where((video) => video.isTrailer && video.isYouTube)
        .toList();
  }

  List<MovieVideo> get teasers {
    return results
        .where((video) => video.isTeaser && video.isYouTube)
        .toList();
  }

  MovieVideo? get officialTrailer {
    final officialTrailers = trailers
        .where((video) => video.official)
        .toList();
    
    if (officialTrailers.isNotEmpty) {
      return officialTrailers.first;
    }
    
    if (trailers.isNotEmpty) {
      return trailers.first;
    }
    
    if (teasers.isNotEmpty) {
      return teasers.first;
    }
    
    return null;
  }

  bool get hasTrailer {
    return officialTrailer != null;
  }
}
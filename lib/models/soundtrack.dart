class SoundtrackInfo {
  final String movieTitle;
  final String? spotifyPlaylistId;
  final String? youtubePlaylistId;
  final String? themeSongTitle;
  final String? themeSongArtist;
  final String? themeSongSpotifyId;
  final String? themeSongYoutubeId;

  SoundtrackInfo({
    required this.movieTitle,
    this.spotifyPlaylistId,
    this.youtubePlaylistId,
    this.themeSongTitle,
    this.themeSongArtist,
    this.themeSongSpotifyId,
    this.themeSongYoutubeId,
  });

  String? get spotifyPlaylistUrl => spotifyPlaylistId != null 
    ? 'https://open.spotify.com/playlist/$spotifyPlaylistId' 
    : null;

  String? get youtubePlaylistUrl => youtubePlaylistId != null 
    ? 'https://www.youtube.com/playlist?list=$youtubePlaylistId' 
    : null;

  String? get themeSongSpotifyUrl => themeSongSpotifyId != null 
    ? 'https://open.spotify.com/track/$themeSongSpotifyId' 
    : null;

  String? get themeSongYoutubeUrl => themeSongYoutubeId != null 
    ? 'https://www.youtube.com/watch?v=$themeSongYoutubeId' 
    : null;

  // URLs de busca quando não temos IDs específicos
  String get spotifySearchUrl => 
    'https://open.spotify.com/search/${Uri.encodeComponent("$movieTitle soundtrack")}';

  String get youtubeSearchUrl => 
    'https://www.youtube.com/results?search_query=${Uri.encodeComponent("$movieTitle soundtrack playlist")}';

  String? get themeSongSearchSpotifyUrl => themeSongTitle != null && themeSongArtist != null
    ? 'https://open.spotify.com/search/${Uri.encodeComponent("$themeSongTitle $themeSongArtist")}'
    : null;

  String? get themeSongSearchYoutubeUrl => themeSongTitle != null && themeSongArtist != null
    ? 'https://www.youtube.com/results?search_query=${Uri.encodeComponent("$themeSongTitle $themeSongArtist")}'
    : null;
}
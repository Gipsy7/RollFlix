import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';
import '../models/soundtrack.dart';
import '../models/actor_details.dart';
import '../utils/app_logger.dart';
import '../controllers/locale_controller.dart';

class MovieService {
  // Use constants from AppConstants - agora via getter
  static String get _apiKey => AppConstants.tmdbApiKey;
  static const String _baseUrl = AppConstants.tmdbBaseUrl;

  // Mapeamento de códigos de idioma do app para códigos TMDB
  static String get _getCurrentLanguageCode {
    final locale = LocaleController.instance.locale;
    switch (locale?.languageCode) {
      case 'pt':
        return 'pt-BR';
      case 'en':
        return 'en-US';
      case 'es':
        return 'es-ES';
      case 'fr':
        return 'fr-FR';
      default:
        return 'en-US'; // Fallback para inglês
    }
  }

  // Use genre mapping from constants
  static const Map<String, List<int>> _genreMap = {
    'Novidades': [], // Special case - uses now_playing endpoint
    'Ação': [28], // Action
    'Aventura': [12], // Adventure
    'Animação': [16], // Animation
    'Comédia': [35], // Comedy
    'Crime': [80], // Crime
    'Documentário': [99], // Documentary
    'Drama': [18], // Drama
    'Família': [10751], // Family
    'Fantasia': [14], // Fantasy
    'História': [36], // History
    'Terror': [27], // Horror
    'Música': [10402], // Music
    'Mistério': [9648], // Mystery
    'Romance': [10749], // Romance
    'Ficção Científica': [878], // Science Fiction
    'Suspense': [53], // Thriller
    'Guerra': [10752], // War
    'Western': [37], // Western
  };

  // Gêneros específicos para séries de TV
  static const Map<String, List<int>> _tvGenreMap = {
    'Novidades': [], // Special case - uses on_the_air endpoint
    'Ação & Aventura': [10759], // Action & Adventure
    'Animação': [16], // Animation
    'Comédia': [35], // Comedy
    'Crime': [80], // Crime
    'Documentário': [99], // Documentary
    'Drama': [18], // Drama
    'Família': [10751], // Family
    'Infantil': [10762], // Kids
    'Mistério': [9648], // Mystery
    'Novela': [10766], // Soap
    'Ficção Científica & Fantasia': [10765], // Sci-Fi & Fantasy
    'Talk Show': [10767], // Talk
    'Guerra & Política': [10768], // War & Politics
    'Western': [37], // Western
    'Reality': [10764], // Reality
  };

  static Future<List<Movie>> getMoviesByGenre(
    String genre, {
    int? minYear,
    int? maxYear,
    bool? allowAdult,
  }) async {
    try {
      // Caso especial para "Novidades" - busca filmes em cartaz/recentes
      if (genre == 'Novidades') {
        return await _getNowPlayingMovies(
          minYear: minYear,
          maxYear: maxYear,
          allowAdult: allowAdult,
        );
      }

      final genreIds = _genreMap[genre];
      if (genreIds == null || genreIds.isEmpty) {
        throw Exception('Gênero não encontrado');
      }

      // Tenta até 3 páginas diferentes se não encontrar resultados
      List<Movie> validMovies = [];
      int attempts = 0;
      const maxAttempts = 3;

      while (validMovies.isEmpty && attempts < maxAttempts) {
        attempts++;
        final randomPage =
            Random().nextInt(5) + attempts; // Varia entre páginas diferentes

        // Constrói a URL base
        var urlString =
            '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=${genreIds.join(',')}&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&page=$randomPage';

        // Adiciona filtro de classificação indicativa
        // Se NÃO permite adulto (allowAdult=false), exclui conteúdo adulto
        if (allowAdult != null && !allowAdult) {
          urlString += '&include_adult=false';
          AppLogger.debug(
            '🔞 Filtro aplicado: Apenas conteúdo não adulto (include_adult=false)',
          );
        }

        // Adiciona filtros de preferências
        if (minYear != null) {
          urlString += '&primary_release_date.gte=$minYear-01-01';
        }

        if (maxYear != null) {
          urlString += '&primary_release_date.lte=$maxYear-12-31';
        }

        final url = Uri.parse(urlString);
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final moviesResponse = MoviesResponse.fromJson(jsonData);

          // Filtra filmes que tenham título em português ou pelo menos um título válido
      validMovies = moviesResponse.results
        .where(
        (movie) =>
          movie.title.trim().isNotEmpty &&
          !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
            .hasMatch(movie.title),
        )
        .toList();

          if (validMovies.isEmpty && attempts < maxAttempts) {
            AppLogger.debug(
              'Tentativa $attempts: Nenhum filme encontrado, tentando outra página...',
            );
          }
        } else {
          throw Exception('Erro ao buscar filmes: ${response.statusCode}');
        }
      }

      return validMovies;
    } catch (e, stack) {
      AppLogger.error('Erro no MovieService', error: e, stackTrace: stack);
      // Fallback para lista estática em caso de erro
      return _getFallbackMovies(genre);
    }
  }

  // Função auxiliar para buscar filmes em cartaz/novidades
  static Future<List<Movie>> _getNowPlayingMovies({
    int? minYear,
    int? maxYear,
    bool? allowAdult,
  }) async {
    try {
      // Tenta até 3 páginas diferentes se não encontrar resultados
      List<Movie> validMovies = [];
      int attempts = 0;
      const maxAttempts = 3;

      while (validMovies.isEmpty && attempts < maxAttempts) {
        attempts++;
        final randomPage = attempts; // Páginas 1, 2, 3

        // Usa now_playing sem filtros (mais rápido)
        var urlString =
            '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$randomPage&region=BR';

        // Adiciona filtro de classificação indicativa
        if (allowAdult != null && !allowAdult) {
          urlString += '&include_adult=false';
          AppLogger.debug(
            '🔞 Filtro aplicado (Novidades): Apenas conteúdo não adulto (include_adult=false)',
          );
        }

        if (minYear != null) {
          urlString += '&primary_release_date.gte=$minYear-01-01';
        }

        if (maxYear != null) {
          urlString += '&primary_release_date.lte=$maxYear-12-31';
        }

        final url = Uri.parse(urlString);
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final moviesResponse = MoviesResponse.fromJson(jsonData);

          // Filtra filmes que tenham título válido (evita placeholders como 'not available' em qualquer idioma)
          validMovies = moviesResponse.results
              .where(
                (movie) =>
                    movie.title.trim().isNotEmpty &&
                    !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
                        .hasMatch(movie.title),
              )
              .toList();

          if (validMovies.isEmpty && attempts < maxAttempts) {
            AppLogger.debug(
              'Tentativa $attempts (Novidades): Nenhum filme encontrado, tentando outra página...',
            );
          }
        } else {
          throw Exception(
            'Erro ao buscar filmes em cartaz: ${response.statusCode}',
          );
        }
      }

      return validMovies;
    } catch (e, stack) {
      AppLogger.error('Erro ao buscar novidades', error: e, stackTrace: stack);
      return await _getRecentPopularMovies();
    }
  }

  // Função auxiliar para buscar filmes populares recentes
  static Future<List<Movie>> _getRecentPopularMovies() async {
    try {
      final currentYear = DateTime.now().year;
      final randomPage = Random().nextInt(3) + 1;

      final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&primary_release_year=$currentYear&page=$randomPage',
      );

      final response = await http.get(url);

    if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final moviesResponse = MoviesResponse.fromJson(jsonData);

    final validMovies = moviesResponse.results
      .where(
        (movie) =>
          movie.title.trim().isNotEmpty &&
          !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
            .hasMatch(movie.title),
      )
      .toList();

    return validMovies;
      } else {
        return [];
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar filmes populares recentes',
        error: e,
        stackTrace: stack,
      );
      return [];
    }
  }

  static Future<Movie> getRandomMovieByGenre(String genre) async {
    final movies = await getMoviesByGenre(genre);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o gênero $genre');
    }

    final randomIndex = Random().nextInt(movies.length);
    return movies[randomIndex];
  }

  static Future<Movie> getMovieDetails(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception(
          'Erro ao buscar detalhes do filme: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar detalhes do filme $movieId',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  static Future<MovieCredits> getMovieCredits(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MovieCredits.fromJson(jsonData);
      } else {
        throw Exception('Erro ao buscar elenco: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar elenco do filme $movieId',
        error: e,
        stackTrace: stack,
      );
      return MovieCredits(cast: [], crew: []);
    }
  }

  static Future<WatchProviders?> getWatchProviders(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/watch/providers?api_key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as Map<String, dynamic>?;

        // Verifica primeiro BR (Brasil), depois US (Estados Unidos)
        if (results?['BR'] != null) {
          return WatchProviders.fromJson(results!['BR']);
        } else if (results?['US'] != null) {
          return WatchProviders.fromJson(results!['US']);
        }
        return null;
      } else {
        return null;
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar provedores do filme $movieId',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<MovieVideos?> getMovieVideos(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final movieVideos = MovieVideos.fromJson(jsonData);

        // Se não encontrar vídeos em português, tenta em inglês
        if (movieVideos.results.isEmpty) {
          final urlEn = Uri.parse(
            '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US',
          );

          final responseEn = await http.get(urlEn);
          if (responseEn.statusCode == 200) {
            final jsonDataEn = json.decode(responseEn.body);
            return MovieVideos.fromJson(jsonDataEn);
          }
        }

        return movieVideos;
      } else {
        throw Exception('Erro ao buscar vídeos: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar vídeos do filme $movieId',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // Lista de fallback caso a API não funcione
  static List<Movie> _getFallbackMovies(String genre) {
    final fallbackData = {
      'Novidades': [
        {'title': 'Oppenheimer', 'year': '2023'},
        {'title': 'Barbie', 'year': '2023'},
        {'title': 'Guardiões da Galáxia Vol. 3', 'year': '2023'},
        {
          'title': 'Missão: Impossível - Acerto de Contas Parte 1',
          'year': '2023',
        },
        {'title': 'Elementos', 'year': '2023'},
      ],
      'Ação': [
        {'title': 'John Wick', 'year': '2014'},
        {'title': 'Mad Max: Fury Road', 'year': '2015'},
        {'title': 'Matrix', 'year': '1999'},
        {'title': 'Vingadores: Ultimato', 'year': '2019'},
        {'title': 'Die Hard', 'year': '1988'},
      ],
      'Aventura': [
        {'title': 'Indiana Jones', 'year': '1981'},
        {'title': 'Piratas do Caribe', 'year': '2003'},
        {'title': 'Jurassic Park', 'year': '1993'},
        {'title': 'O Senhor dos Anéis', 'year': '2001'},
        {'title': 'Avatar', 'year': '2009'},
      ],
      'Animação': [
        {'title': 'Toy Story', 'year': '1995'},
        {'title': 'Procurando Nemo', 'year': '2003'},
        {'title': 'Frozen', 'year': '2013'},
        {'title': 'Moana', 'year': '2016'},
        {'title': 'Coco', 'year': '2017'},
      ],
      'Comédia': [
        {'title': 'Se Beber, Não Case', 'year': '2009'},
        {'title': 'Superbad', 'year': '2007'},
        {'title': 'Debi & Lóide', 'year': '1994'},
        {'title': 'Borat', 'year': '2006'},
        {'title': 'Escola de Rock', 'year': '2003'},
      ],
      'Crime': [
        {'title': 'Goodfellas', 'year': '1990'},
        {'title': 'O Poderoso Chefão', 'year': '1972'},
        {'title': 'Pulp Fiction', 'year': '1994'},
        {'title': 'Cidade de Deus', 'year': '2002'},
        {'title': 'Scarface', 'year': '1983'},
      ],
      'Documentário': [
        {'title': 'March of the Penguins', 'year': '2005'},
        {'title': 'An Inconvenient Truth', 'year': '2006'},
        {'title': 'Free Solo', 'year': '2018'},
        {'title': 'Won\'t You Be My Neighbor?', 'year': '2018'},
        {'title': 'The Act of Killing', 'year': '2012'},
      ],
      'Terror': [
        {'title': 'O Exorcista', 'year': '1973'},
        {'title': 'Psicose', 'year': '1960'},
        {'title': 'Halloween', 'year': '1978'},
        {'title': 'Sexta-feira 13', 'year': '1980'},
        {'title': 'A Hora do Pesadelo', 'year': '1984'},
      ],
      'Família': [
        {'title': 'E.T.', 'year': '1982'},
        {'title': 'Os Incríveis', 'year': '2004'},
        {'title': 'Harry Potter', 'year': '2001'},
        {'title': 'Matilda', 'year': '1996'},
        {'title': 'O Rei Leão', 'year': '1994'},
      ],
      'Fantasia': [
        {'title': 'O Senhor dos Anéis', 'year': '2001'},
        {'title': 'Harry Potter', 'year': '2001'},
        {'title': 'Pan\'s Labyrinth', 'year': '2006'},
        {'title': 'A Forma da Água', 'year': '2017'},
        {'title': 'Edward Mãos de Tesoura', 'year': '1990'},
      ],
      'História': [
        {'title': 'Gladiador', 'year': '2000'},
        {'title': 'Coração Valente', 'year': '1995'},
        {'title': 'O Resgate do Soldado Ryan', 'year': '1998'},
        {'title': 'Gandhi', 'year': '1982'},
        {'title': 'Lawrence da Arábia', 'year': '1962'},
      ],
      'Romance': [
        {'title': 'Titanic', 'year': '1997'},
        {'title': 'Dirty Dancing', 'year': '1987'},
        {'title': 'O Diário de uma Paixão', 'year': '2004'},
        {'title': 'Casablanca', 'year': '1942'},
        {'title': 'Ghost', 'year': '1990'},
      ],
      'Ficção Científica': [
        {'title': 'Blade Runner 2049', 'year': '2017'},
        {'title': 'Interestelar', 'year': '2014'},
        {'title': 'Star Wars', 'year': '1977'},
        {'title': 'Star Trek', 'year': '2009'},
        {'title': 'Alien', 'year': '1979'},
      ],
      'Thriller': [
        {'title': 'Se7en', 'year': '1995'},
        {'title': 'O Silêncio dos Inocentes', 'year': '1991'},
        {'title': 'Zodíaco', 'year': '2007'},
        {'title': 'Perdida', 'year': '2014'},
        {'title': 'Shutter Island', 'year': '2010'},
      ],
      'Guerra': [
        {'title': 'O Resgate do Soldado Ryan', 'year': '1998'},
        {'title': 'Apocalypse Now', 'year': '1979'},
        {'title': 'Platoon', 'year': '1986'},
        {'title': 'Full Metal Jacket', 'year': '1987'},
        {'title': '1917', 'year': '2019'},
      ],
      'Faroeste': [
        {'title': 'Django Livre', 'year': '2012'},
        {'title': 'Três Homens em Conflito', 'year': '1966'},
        {'title': 'Tombstone', 'year': '1993'},
        {'title': 'Butch Cassidy', 'year': '1969'},
        {'title': 'Os Imperdoáveis', 'year': '1992'},
      ],
      'Drama': [
        {'title': 'Clube da Luta', 'year': '1999'},
        {'title': 'Forrest Gump', 'year': '1994'},
        {'title': 'Um Sonho de Liberdade', 'year': '1994'},
        {'title': 'O Poderoso Chefão', 'year': '1972'},
        {'title': 'Pulp Fiction', 'year': '1994'},
      ],
      'Música': [
        {'title': 'Bohemian Rhapsody', 'year': '2018'},
        {'title': 'A Star Is Born', 'year': '2018'},
        {'title': 'La La Land', 'year': '2016'},
        {'title': 'Mamma Mia!', 'year': '2008'},
        {'title': 'The Greatest Showman', 'year': '2017'},
      ],
      'Mistério': [
        {'title': 'Sherlock Holmes', 'year': '2009'},
        {'title': 'O Sexto Sentido', 'year': '1999'},
        {'title': 'Assassinato no Expresso do Oriente', 'year': '2017'},
        {'title': 'Knives Out', 'year': '2019'},
        {'title': 'The Prestige', 'year': '2006'},
      ],
    };

    final movieData = fallbackData[genre] ?? [];
    return movieData
        .map(
          (data) => Movie(
            id: 0,
            title: data['title']!,
            overview: 'Filme clássico do gênero $genre',
            posterPath: '',
            backdropPath: '',
            voteAverage: 8.0,
            voteCount: 1000,
            releaseDate: data['year']!,
            genreIds: [],
          ),
        )
        .toList();
  }

  // Método para obter informações da trilha sonora
  static SoundtrackInfo getSoundtrackInfo(Movie movie) {
    // Base de dados de trilhas sonoras conhecidas
    final Map<String, Map<String, String?>> knownSoundtracks = {
      'The Lion King': {
        'themeSongTitle': 'Can You Feel the Love Tonight',
        'themeSongArtist': 'Elton John',
        'spotifyPlaylistId': '37i9dQZF1DX8C9xQcOrE6T',
        'youtubePlaylistId': 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI',
      },
      'Frozen': {
        'themeSongTitle': 'Let It Go',
        'themeSongArtist': 'Idina Menzel',
        'spotifyPlaylistId': '1YcF3Sv0qKdNalcwVYkNyx',
        'youtubePlaylistId': 'PLjaCx3bwu6PVvvVdWlHDqbNGfnJ7h7aE1',
      },
      'A Star Is Born': {
        'themeSongTitle': 'Shallow',
        'themeSongArtist': 'Lady Gaga & Bradley Cooper',
        'spotifyPlaylistId': '37i9dQZF1DX7RnYsxJE1fK',
        'youtubePlaylistId': 'PLmEpPMVhGBwI7zojhNGG2i-y3bQJ9xFyb',
      },
      'La La Land': {
        'themeSongTitle': 'City of Stars',
        'themeSongArtist': 'Ryan Gosling & Emma Stone',
        'spotifyPlaylistId': '4LMZDj6mOg7PtjHQ5tMHe5',
        'youtubePlaylistId': 'PL03A8764DA7AC1E2E',
      },
      'The Greatest Showman': {
        'themeSongTitle': 'This Is Me',
        'themeSongArtist': 'Keala Settle',
        'spotifyPlaylistId': '37i9dQZF1DX5VFzFqQx0U6',
        'youtubePlaylistId': 'PLtevNBhR1jwMHjD8PpKTpnBzJd6awfF0v',
      },
      'Guardians of the Galaxy': {
        'themeSongTitle': 'Hooked on a Feeling',
        'themeSongArtist': 'Blue Swede',
        'spotifyPlaylistId': '3dTk3nRh12VZhQ8Ap4Z8Qh',
        'youtubePlaylistId': 'PLdVvKp4wQKDrJrN2kqJPzP_qP-BvX0Kbv',
      },
      'Black Panther': {
        'themeSongTitle': 'All the Stars',
        'themeSongArtist': 'Kendrick Lamar & SZA',
        'spotifyPlaylistId': '1YcF3Sv0qKdNalcwVYkNyx',
        'youtubePlaylistId': 'PLjaCx3bwu6PVvvVdWlHDqbNGfnJ7h7aE1',
      },
      'Bohemian Rhapsody': {
        'themeSongTitle': 'Bohemian Rhapsody',
        'themeSongArtist': 'Queen',
        'spotifyPlaylistId': '37i9dQZF1DX7RnYsxJE1fK',
        'youtubePlaylistId': 'PLohG1MxSSIb3GVKoNBqhF-Zzl7jRhZMjQ',
      },
      'Moana': {
        'themeSongTitle': 'How Far I\'ll Go',
        'themeSongArtist': 'Auli\'i Cravalho',
        'spotifyPlaylistId': '2nDYTwMb9M3ks5cDlKo6gZ',
        'youtubePlaylistId': 'PLH6DZmEFObNKQ74W4I_tAczv8nJ48xw7E',
      },
    };

    final soundtrackData = knownSoundtracks[movie.title];

    return SoundtrackInfo(
      movieTitle: movie.title,
      spotifyPlaylistId: soundtrackData?['spotifyPlaylistId'],
      youtubePlaylistId: soundtrackData?['youtubePlaylistId'],
      themeSongTitle: soundtrackData?['themeSongTitle'],
      themeSongArtist: soundtrackData?['themeSongArtist'],
      themeSongSpotifyId: soundtrackData?['themeSongSpotifyId'],
      themeSongYoutubeId: soundtrackData?['themeSongYoutubeId'],
    );
  }

  // Método para obter detalhes do ator
  static Future<ActorDetails> getActorDetails(int actorId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/person/$actorId?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final actorDetails = ActorDetails.fromJson(data);

        // Buscar filmes conhecidos do ator
        final knownForMovies = await getActorMovies(actorId);

        return ActorDetails(
          id: actorDetails.id,
          name: actorDetails.name,
          biography: actorDetails.biography,
          profilePath: actorDetails.profilePath,
          birthday: actorDetails.birthday,
          deathday: actorDetails.deathday,
          placeOfBirth: actorDetails.placeOfBirth,
          knownForDepartment: actorDetails.knownForDepartment,
          popularity: actorDetails.popularity,
          knownFor: knownForMovies,
        );
      } else {
        throw Exception('Falha ao carregar detalhes do ator');
      }
    } catch (e) {
      throw Exception('Erro ao buscar detalhes do ator: $e');
    }
  }

  // Método para obter filmes do ator
  static Future<List<ActorMovie>> getActorMovies(int actorId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/person/$actorId/movie_credits?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> castList = data['cast'] ?? [];

        // Ordenar por popularidade e data de lançamento
        final movies = castList
            .map((movieData) => ActorMovie.fromJson(movieData))
            .where(
              (movie) => movie.posterPath != null && movie.releaseDate != null,
            )
            .toList();

        movies.sort((a, b) {
          // Primeiro por data de lançamento (mais recente primeiro)
          final dateComparison = (b.releaseDate ?? '').compareTo(
            a.releaseDate ?? '',
          );
          if (dateComparison != 0) return dateComparison;
          // Depois por avaliação
          return b.voteAverage.compareTo(a.voteAverage);
        });

        // Retornar os 20 filmes mais relevantes
        return movies.take(20).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Método para obter filmes dirigidos por uma pessoa
  static Future<List<ActorMovie>> getDirectorMovies(int directorId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/person/$directorId/movie_credits?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> crewList = data['crew'] ?? [];

        // Filtrar apenas filmes onde a pessoa foi diretora
        final directorMovies = crewList
            .where((movieData) => movieData['job'] == 'Director')
            .map((movieData) => ActorMovie.fromJson(movieData))
            .where(
              (movie) => movie.posterPath != null && movie.releaseDate != null,
            )
            .toList();

        directorMovies.sort((a, b) {
          // Primeiro por data de lançamento (mais recente primeiro)
          final dateComparison = (b.releaseDate ?? '').compareTo(
            a.releaseDate ?? '',
          );
          if (dateComparison != 0) return dateComparison;
          // Depois por avaliação
          return b.voteAverage.compareTo(a.voteAverage);
        });

        // Retornar os 20 filmes mais relevantes
        return directorMovies.take(20).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Métodos para a tela de pesquisa
  static Future<List<Movie>?> getPopularMovies({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        return moviesResponse.results;
      } else {
        throw Exception(
          'Erro ao buscar filmes populares: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar filmes populares (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<Movie>?> getTopRatedMovies({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        return moviesResponse.results;
      } else {
        throw Exception(
          'Erro ao buscar filmes mais votados: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar filmes mais votados (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<Movie>?> getUpcomingMovies({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        return moviesResponse.results;
      } else {
        throw Exception('Erro ao buscar novidades: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar novidades de filmes (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<Movie>?> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=${genreIds.join(',')}&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        return moviesResponse.results;
      } else {
        throw Exception(
          'Erro ao buscar filmes por gêneros: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar filmes por gêneros $genreIds (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<Movie>?> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];

    try {
      final url = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=\$_getCurrentLanguageCode&query=${Uri.encodeComponent(query)}&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        return moviesResponse.results;
      } else {
        throw Exception('Erro na pesquisa: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro na pesquisa de filmes: $query (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // Métodos para Séries de TV

  static Future<List<TVShow>> getTVShowsByGenre(
    String genre, {
    int? minYear,
    int? maxYear,
    bool? allowAdult,
  }) async {
    try {
      // Caso especial para "Novidades" - busca séries no ar/recentes
      if (genre == 'Novidades') {
        return await _getOnTheAirTVShows(
          minYear: minYear,
          maxYear: maxYear,
          allowAdult: allowAdult,
        );
      }

      final genreIds = _tvGenreMap[genre];
      if (genreIds == null || genreIds.isEmpty) {
        throw Exception('Gênero não encontrado');
      }

      // Tenta até 3 páginas diferentes se não encontrar resultados
      List<TVShow> validTVShows = [];
      int attempts = 0;
      const maxAttempts = 3;

      while (validTVShows.isEmpty && attempts < maxAttempts) {
        attempts++;
        final randomPage = Random().nextInt(5) + attempts;

        // Constrói a URL base
        var urlString =
            '$_baseUrl/discover/tv?api_key=$_apiKey&with_genres=${genreIds.join(',')}&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&page=$randomPage';

        // Adiciona filtro de classificação indicativa
        if (allowAdult != null && !allowAdult) {
          urlString += '&include_adult=false';
          AppLogger.debug(
            '🔞 Filtro aplicado (TV): Apenas conteúdo não adulto (include_adult=false)',
          );
        }

        // Adiciona filtros de preferências
        if (minYear != null) {
          urlString += '&first_air_date.gte=$minYear-01-01';
        }

        if (maxYear != null) {
          urlString += '&first_air_date.lte=$maxYear-12-31';
        }

        final url = Uri.parse(urlString);
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final tvShowsResponse = TVShowsResponse.fromJson(jsonData);

          // Filtra séries que tenham título em português ou pelo menos um título válido
      validTVShows = tvShowsResponse.results
        .where(
        (tvshow) =>
          tvshow.name.trim().isNotEmpty &&
          !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
            .hasMatch(tvshow.name),
        )
        .toList();

          if (validTVShows.isEmpty && attempts < maxAttempts) {
            AppLogger.debug(
              'Tentativa $attempts: Nenhuma série encontrada, tentando outra página...',
            );
          }
        } else {
          throw Exception('Erro ao buscar séries: ${response.statusCode}');
        }
      }

      return validTVShows;
    } catch (e, stack) {
      AppLogger.error('Erro no TVService', error: e, stackTrace: stack);
      throw Exception('Falha ao buscar séries: $e');
    }
  }

  // Função auxiliar para buscar séries no ar/novidades
  static Future<List<TVShow>> _getOnTheAirTVShows({
    int? minYear,
    int? maxYear,
    bool? allowAdult,
  }) async {
    try {
      final currentYear = DateTime.now().year;
      final lastYear = currentYear - 1;

      // Tenta até 3 páginas diferentes se não encontrar resultados
      List<TVShow> validTVShows = [];
      int attempts = 0;
      const maxAttempts = 3;

      while (validTVShows.isEmpty && attempts < maxAttempts) {
        attempts++;
        final randomPage = attempts;

        // Constrói a URL base com discover (suporta filtros de nota)
        var urlString =
            '$_baseUrl/discover/tv?api_key=$_apiKey&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&first_air_date.gte=$lastYear-01-01&page=$randomPage';

        // Adiciona filtro de classificação indicativa
        if (allowAdult != null && !allowAdult) {
          urlString += '&include_adult=false';
          AppLogger.debug(
            '🔞 Filtro aplicado (TV Novidades): Apenas conteúdo não adulto (include_adult=false)',
          );
        }

        // Adiciona filtros de preferências
        if (minYear != null) {
          urlString += '&first_air_date.gte=$minYear-01-01';
        }

        if (maxYear != null) {
          urlString += '&first_air_date.lte=$maxYear-12-31';
        }

        final url = Uri.parse(urlString);
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final tvShowsResponse = TVShowsResponse.fromJson(jsonData);

          // Filtra séries que tenham título em português ou pelo menos um título válido
      validTVShows = tvShowsResponse.results
        .where(
        (tvshow) =>
          tvshow.name.trim().isNotEmpty &&
          !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
            .hasMatch(tvshow.name),
        )
        .toList();

          if (validTVShows.isEmpty && attempts < maxAttempts) {
            AppLogger.debug(
              'Tentativa $attempts (Novidades TV): Nenhuma série encontrada, tentando outra página...',
            );
          }
        } else {
          throw Exception(
            'Erro ao buscar séries no ar: ${response.statusCode}',
          );
        }
      }

      return validTVShows;
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar novidades de séries',
        error: e,
        stackTrace: stack,
      );
      return await _getRecentPopularTVShows();
    }
  }

  // Função auxiliar para buscar séries populares recentes
  static Future<List<TVShow>> _getRecentPopularTVShows() async {
    try {
      final currentYear = DateTime.now().year;
      final lastYear = currentYear - 1;
      final randomPage = Random().nextInt(2) + 1;

      // Busca séries que estrearam nos últimos 2 anos
      final url = Uri.parse(
        '$_baseUrl/discover/tv?api_key=$_apiKey&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&first_air_date.gte=$lastYear-01-01&vote_count.gte=10&page=$randomPage',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowsResponse = TVShowsResponse.fromJson(jsonData);

    final validTVShows = tvShowsResponse.results
      .where(
        (tvshow) =>
          tvshow.name.trim().isNotEmpty &&
          !RegExp(r'(not available|não disponível|title not available|título não disponível)', caseSensitive: false)
            .hasMatch(tvshow.name),
      )
      .toList();

        // Se não encontrou séries dos últimos 2 anos, tenta apenas o ano atual
        if (validTVShows.isEmpty) {
          final urlCurrentYear = Uri.parse(
            '$_baseUrl/discover/tv?api_key=$_apiKey&language=\$_getCurrentLanguageCode&sort_by=popularity.desc&first_air_date_year=$currentYear&page=1',
          );

          final responseCurrentYear = await http.get(urlCurrentYear);

          if (responseCurrentYear.statusCode == 200) {
            final jsonDataCurrentYear = json.decode(responseCurrentYear.body);
            final tvShowsResponseCurrentYear = TVShowsResponse.fromJson(
              jsonDataCurrentYear,
            );

            return tvShowsResponseCurrentYear.results
                .where(
                  (tvshow) =>
                      tvshow.name.isNotEmpty &&
                      tvshow.name != 'Título não disponível',
                )
                .toList();
          }
        }

        return validTVShows;
      } else {
        return [];
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar séries populares recentes',
        error: e,
        stackTrace: stack,
      );
      return [];
    }
  }

  static Future<TVShow?> getRandomTVShow() async {
    try {
      final genres = _tvGenreMap.keys.toList();
      final randomGenre = genres[Random().nextInt(genres.length)];

      final tvShows = await getTVShowsByGenre(randomGenre);

      if (tvShows.isNotEmpty) {
        final randomIndex = Random().nextInt(tvShows.length);
        return tvShows[randomIndex];
      }

      return null;
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar série aleatória',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static List<String> getTVGenres() {
    return [..._tvGenreMap.keys, 'Favoritos', 'Assistidos'];
  }

  static Future<List<TVShow>?> getPopularTVShows({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/popular?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowsResponse = TVShowsResponse.fromJson(jsonData);
        return tvShowsResponse.results;
      } else {
        throw Exception(
          'Erro ao buscar séries populares: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar séries populares (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<TVShow>?> getTopRatedTVShows({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/top_rated?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowsResponse = TVShowsResponse.fromJson(jsonData);
        return tvShowsResponse.results;
      } else {
        throw Exception(
          'Erro ao buscar séries mais bem avaliadas: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar séries mais bem avaliadas (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<TVShow>?> getOnTheAirTVShows({int page = 1}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/on_the_air?api_key=$_apiKey&language=\$_getCurrentLanguageCode&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowsResponse = TVShowsResponse.fromJson(jsonData);
        return tvShowsResponse.results;
      } else {
        throw Exception('Erro ao buscar séries no ar: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar séries no ar (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<List<TVShow>?> searchTVShows(
    String query, {
    int page = 1,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final url = Uri.parse(
        '$_baseUrl/search/tv?api_key=$_apiKey&language=\$_getCurrentLanguageCode&query=${Uri.encodeComponent(query)}&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowsResponse = TVShowsResponse.fromJson(jsonData);
        return tvShowsResponse.results;
      } else {
        throw Exception('Erro na pesquisa de séries: ${response.statusCode}');
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro na pesquisa de séries: $query (page: $page)',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // Métodos de detalhes para TV Shows
  static Future<TVShow> getTVShowDetails(int tvShowId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/$tvShowId?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TVShow.fromJson(jsonData);
      } else {
        throw Exception(
          'Erro ao buscar detalhes da série: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar detalhes da série $tvShowId',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  static Future<MovieCredits> getTVShowCredits(int tvShowId) async {
    try {
      final url = Uri.parse('$_baseUrl/tv/$tvShowId/credits?api_key=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MovieCredits.fromJson(jsonData);
      } else {
        throw Exception(
          'Erro ao buscar elenco da série: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar elenco da série $tvShowId',
        error: e,
        stackTrace: stack,
      );
      return MovieCredits(cast: [], crew: []);
    }
  }

  static Future<WatchProviders?> getTVShowWatchProviders(int tvShowId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/$tvShowId/watch/providers?api_key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final results = jsonData['results'] as Map<String, dynamic>?;

        // Verifica primeiro BR (Brasil), depois US (Estados Unidos)
        if (results?['BR'] != null) {
          return WatchProviders.fromJson(results!['BR']);
        } else if (results?['US'] != null) {
          return WatchProviders.fromJson(results!['US']);
        }
        return null;
      } else {
        return null;
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar provedores da série $tvShowId',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  static Future<MovieVideos?> getTVShowVideos(int tvShowId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tv/$tvShowId/videos?api_key=$_apiKey&language=\$_getCurrentLanguageCode',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tvShowVideos = MovieVideos.fromJson(jsonData);

        // Se não encontrar vídeos em português, tenta em inglês
        if (tvShowVideos.results.isEmpty) {
          final urlEn = Uri.parse(
            '$_baseUrl/tv/$tvShowId/videos?api_key=$_apiKey&language=en-US',
          );

          final responseEn = await http.get(urlEn);
          if (responseEn.statusCode == 200) {
            final jsonDataEn = json.decode(responseEn.body);
            return MovieVideos.fromJson(jsonDataEn);
          }
        }

        return tvShowVideos;
      } else {
        throw Exception(
          'Erro ao buscar vídeos da série: ${response.statusCode}',
        );
      }
    } catch (e, stack) {
      AppLogger.error(
        'Erro ao buscar vídeos da série $tvShowId',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // Método para obter informações da trilha sonora de séries
  static SoundtrackInfo getTVShowSoundtrackInfo(TVShow tvShow) {
    // Base de dados de trilhas sonoras conhecidas de séries
    final Map<String, Map<String, String?>> knownTVSoundtracks = {
      'Game of Thrones': {
        'themeSongTitle': 'Main Title',
        'themeSongArtist': 'Ramin Djawadi',
        'spotifyPlaylistId': '37i9dQZF1DX2VTRKgLfOjV',
        'youtubePlaylistId': 'PLjaCx3bwu6PVtvf8dGdAd5MIW5yP3Jhjf',
      },
      'Stranger Things': {
        'themeSongTitle': 'Stranger Things Main Theme',
        'themeSongArtist': 'Kyle Dixon & Michael Stein',
        'spotifyPlaylistId': '37i9dQZF1DWVbeRiWz5Gpe',
        'youtubePlaylistId': 'PLCWd1hNEJhLU2VwCXUjZ9O5P9Fj5LX5Hj',
      },
      'The Last of Us': {
        'themeSongTitle': 'The Last of Us Main Theme',
        'themeSongArtist': 'Gustavo Santaolalla',
        'spotifyPlaylistId': '1QsNABo6LppD7zPgKOT6sW',
        'youtubePlaylistId': 'PLCWd1hNEJhLWfPFGgB8cUjO1v4G5z3Fp8',
      },
      'Breaking Bad': {
        'themeSongTitle': 'Breaking Bad Main Theme',
        'themeSongArtist': 'Dave Porter',
        'spotifyPlaylistId': '37i9dQZF1DWVbeRiWz5Gpe',
        'youtubePlaylistId': 'PLCWd1hNEJhLWfPFGgB8cUjO1v4G5z3Fp8',
      },
      'The Mandalorian': {
        'themeSongTitle': 'The Mandalorian Theme',
        'themeSongArtist': 'Ludwig Göransson',
        'spotifyPlaylistId': '37i9dQZF1DX2BKDJjG8A3T',
        'youtubePlaylistId': 'PLCWd1hNEJhLU2VwCXUjZ9O5P9Fj5LX5Hj',
      },
      'House of the Dragon': {
        'themeSongTitle': 'House of the Dragon Main Title',
        'themeSongArtist': 'Ramin Djawadi',
        'spotifyPlaylistId': '37i9dQZF1DX2VTRKgLfOjV',
        'youtubePlaylistId': 'PLjaCx3bwu6PVtvf8dGdAd5MIW5yP3Jhjf',
      },
      'The Witcher': {
        'themeSongTitle': 'Toss a Coin to Your Witcher',
        'themeSongArtist': 'Joey Batey',
        'spotifyPlaylistId': '37i9dQZF1DWTuVMVpbnY7C',
        'youtubePlaylistId': 'PLCWd1hNEJhLWfPFGgB8cUjO1v4G5z3Fp8',
      },
      'Westworld': {
        'themeSongTitle': 'Westworld Main Theme',
        'themeSongArtist': 'Ramin Djawadi',
        'spotifyPlaylistId': '37i9dQZF1DX2VTRKgLfOjV',
        'youtubePlaylistId': 'PLjaCx3bwu6PVtvf8dGdAd5MIW5yP3Jhjf',
      },
    };

    final soundtrackData = knownTVSoundtracks[tvShow.name];

    return SoundtrackInfo(
      movieTitle: tvShow.name,
      spotifyPlaylistId: soundtrackData?['spotifyPlaylistId'],
      youtubePlaylistId: soundtrackData?['youtubePlaylistId'],
      themeSongTitle: soundtrackData?['themeSongTitle'],
      themeSongArtist: soundtrackData?['themeSongArtist'],
      themeSongSpotifyId: soundtrackData?['themeSongSpotifyId'],
      themeSongYoutubeId: soundtrackData?['themeSongYoutubeId'],
    );
  }
}

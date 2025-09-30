import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';

class MovieService {
  // API Key do TMDb (para uso em demonstração - em produção deve ser protegida)
  static const String _apiKey = '4e44d9029b1270a757cddc766a1bcb63';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Mapeamento de temas para IDs de gêneros do TMDb
  static const Map<String, List<int>> _genreMap = {
    'Ação': [28], // Action
    'Comédia': [35], // Comedy
    'Terror': [27], // Horror
    'Romance': [10749], // Romance
    'Ficção Científica': [878], // Science Fiction
    'Drama': [18], // Drama
  };

  static Future<List<Movie>> getMoviesByTheme(String theme) async {
    try {
      final genreIds = _genreMap[theme];
      if (genreIds == null || genreIds.isEmpty) {
        throw Exception('Tema não encontrado');
      }

      // Gera uma página aleatória entre 1 e 5 para mais variedade
      final randomPage = Random().nextInt(5) + 1;
      
      final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=${genreIds.join(',')}&language=pt-BR&sort_by=popularity.desc&page=$randomPage'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final moviesResponse = MoviesResponse.fromJson(jsonData);
        
        // Filtra filmes que tenham título em português ou pelo menos um título válido
        final validMovies = moviesResponse.results
            .where((movie) => movie.title.isNotEmpty && movie.title != 'Título não disponível')
            .toList();

        return validMovies;
      } else {
        throw Exception('Erro ao buscar filmes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no MovieService: $e');
      // Fallback para lista estática em caso de erro
      return _getFallbackMovies(theme);
    }
  }

  static Future<Movie> getRandomMovieByTheme(String theme) async {
    final movies = await getMoviesByTheme(theme);
    if (movies.isEmpty) {
      throw Exception('Nenhum filme encontrado para o tema $theme');
    }
    
    final randomIndex = Random().nextInt(movies.length);
    return movies[randomIndex];
  }

  static Future<Movie> getMovieDetails(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Erro ao buscar detalhes do filme: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar detalhes: $e');
      rethrow;
    }
  }

  static Future<MovieCredits> getMovieCredits(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MovieCredits.fromJson(jsonData);
      } else {
        throw Exception('Erro ao buscar elenco: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar elenco: $e');
      return MovieCredits(cast: [], crew: []);
    }
  }

  static Future<WatchProviders?> getWatchProviders(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/watch/providers?api_key=$_apiKey'
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
    } catch (e) {
      print('Erro ao buscar provedores: $e');
      return null;
    }
  }

  // Lista de fallback caso a API não funcione
  static List<Movie> _getFallbackMovies(String theme) {
    final fallbackData = {
      'Ação': [
        {'title': 'John Wick', 'year': '2014'},
        {'title': 'Mad Max: Fury Road', 'year': '2015'},
        {'title': 'Matrix', 'year': '1999'},
        {'title': 'Vingadores: Ultimato', 'year': '2019'},
        {'title': 'Die Hard', 'year': '1988'},
      ],
      'Comédia': [
        {'title': 'Se Beber, Não Case', 'year': '2009'},
        {'title': 'Superbad', 'year': '2007'},
        {'title': 'Debi & Lóide', 'year': '1994'},
        {'title': 'Borat', 'year': '2006'},
        {'title': 'Escola de Rock', 'year': '2003'},
      ],
      'Terror': [
        {'title': 'O Exorcista', 'year': '1973'},
        {'title': 'Psicose', 'year': '1960'},
        {'title': 'Halloween', 'year': '1978'},
        {'title': 'Sexta-feira 13', 'year': '1980'},
        {'title': 'A Hora do Pesadelo', 'year': '1984'},
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
      'Drama': [
        {'title': 'Clube da Luta', 'year': '1999'},
        {'title': 'Forrest Gump', 'year': '1994'},
        {'title': 'Um Sonho de Liberdade', 'year': '1994'},
        {'title': 'O Poderoso Chefão', 'year': '1972'},
        {'title': 'Pulp Fiction', 'year': '1994'},
      ],
    };

    final movieData = fallbackData[theme] ?? [];
    return movieData.map((data) => Movie(
      id: 0,
      title: data['title']!,
      overview: 'Filme clássico do gênero $theme',
      voteAverage: 8.0,
      releaseDate: data['year']!,
      genreIds: [],
    )).toList();
  }
}
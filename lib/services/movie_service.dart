import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/cast.dart';
import '../models/watch_providers.dart';
import '../models/movie_videos.dart';

class MovieService {
  // API Key do TMDb (para uso em demonstração - em produção deve ser protegida)
  static const String _apiKey = '4e44d9029b1270a757cddc766a1bcb63';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Mapeamento de gêneros para IDs de gêneros do TMDb
  static const Map<String, List<int>> _genreMap = {
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
    'Thriller': [53], // Thriller
    'Guerra': [10752], // War
    'Faroeste': [37], // Western
  };

  static Future<List<Movie>> getMoviesByGenre(String genre) async {
    try {
      final genreIds = _genreMap[genre];
      if (genreIds == null || genreIds.isEmpty) {
        throw Exception('Gênero não encontrado');
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
      return _getFallbackMovies(genre);
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

  static Future<MovieVideos?> getMovieVideos(int movieId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=pt-BR'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final movieVideos = MovieVideos.fromJson(jsonData);
        
        // Se não encontrar vídeos em português, tenta em inglês
        if (movieVideos.results.isEmpty) {
          final urlEn = Uri.parse(
            '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US'
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
    } catch (e) {
      print('Erro ao buscar vídeos: $e');
      return null;
    }
  }

  // Lista de fallback caso a API não funcione
  static List<Movie> _getFallbackMovies(String genre) {
    final fallbackData = {
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
    return movieData.map((data) => Movie(
      id: 0,
      title: data['title']!,
      overview: 'Filme clássico do gênero $genre',
      voteAverage: 8.0,
      releaseDate: data['year']!,
      genreIds: [],
    )).toList();
  }
}
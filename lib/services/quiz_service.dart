import 'dart:math';
import '../models/quiz_question.dart';
import '../models/movie.dart';
import 'movie_service.dart';

class QuizService {
  final Random _random = Random();

  // Gerar quiz baseado em filmes populares
  Future<List<QuizQuestion>> generateQuiz({
    int questionCount = 10,
    DifficultyLevel difficulty = DifficultyLevel.medium,
    String? genre,
  }) async {
    List<QuizQuestion> questions = [];
    
    try {
      // Buscar filmes para criar as perguntas
      final movies = await MovieService.getPopularMovies(page: 1);
      
      if (movies == null || movies.isEmpty) {
        return _getFallbackQuestions();
      }

      // Embaralhar filmes
      final shuffledMovies = List<Movie>.from(movies)..shuffle();
      
      // Distribuir tipos de perguntas
      final questionTypes = _getQuestionTypeDistribution(questionCount);
      
      for (int i = 0; i < questionCount && i < shuffledMovies.length; i++) {
        final movie = shuffledMovies[i];
        final type = questionTypes[i % questionTypes.length];
        
        QuizQuestion? question;
        
        switch (type) {
          case QuestionType.synopsis:
            question = await _createSynopsisQuestion(movie, movies, difficulty);
            break;
          case QuestionType.year:
            question = await _createYearQuestion(movie, movies, difficulty);
            break;
          case QuestionType.image:
            question = await _createImageQuestion(movie, movies, difficulty);
            break;
          case QuestionType.cast:
            question = await _createCastQuestion(movie, movies, difficulty);
            break;
          default:
            question = await _createSynopsisQuestion(movie, movies, difficulty);
        }
        
        if (question != null) {
          questions.add(question);
        }
      }
      
      // Embaralhar as perguntas
      questions.shuffle();
      
    } catch (e) {
      print('Erro ao gerar quiz: $e');
      return _getFallbackQuestions();
    }
    
    return questions.take(questionCount).toList();
  }

  List<QuestionType> _getQuestionTypeDistribution(int count) {
    return [
      QuestionType.synopsis,
      QuestionType.image,
      QuestionType.year,
      QuestionType.synopsis,
      QuestionType.cast,
      QuestionType.image,
      QuestionType.year,
      QuestionType.synopsis,
      QuestionType.image,
      QuestionType.cast,
    ];
  }

  Future<QuizQuestion?> _createSynopsisQuestion(
    Movie movie,
    List<Movie> allMovies,
    DifficultyLevel difficulty,
  ) async {
    if (movie.overview.isEmpty) return null;

    // Pegar parte da sinopse
    final synopsis = movie.overview.length > 150
        ? '${movie.overview.substring(0, 150)}...'
        : movie.overview;

    // Criar opções
    final options = _createMovieOptions(movie, allMovies, 4);
    
    return QuizQuestion(
      id: 'q_${movie.id}_synopsis',
      type: QuestionType.synopsis,
      question: 'Qual filme tem esta sinopse?\n\n"$synopsis"',
      options: options,
      correctAnswer: movie.title,
      explanation: 'O filme é "${movie.title}" (${movie.releaseDate.split('-').first})',
      imageUrl: movie.posterPath,
      movieId: movie.id.toString(),
      difficulty: difficulty,
      points: _getPointsForDifficulty(difficulty),
    );
  }

  Future<QuizQuestion?> _createYearQuestion(
    Movie movie,
    List<Movie> allMovies,
    DifficultyLevel difficulty,
  ) async {
    if (movie.releaseDate.isEmpty) return null;

    final year = movie.releaseDate.split('-').first;
    
    // Criar opções de anos próximos
    final options = <String>{year};
    final baseYear = int.parse(year);
    
    while (options.length < 4) {
      final offset = _random.nextInt(10) - 5; // -5 a +5 anos
      if (offset != 0) {
        options.add((baseYear + offset).toString());
      }
    }
    
    final shuffledOptions = options.toList()..shuffle();

    return QuizQuestion(
      id: 'q_${movie.id}_year',
      type: QuestionType.year,
      question: 'Em que ano foi lançado "${movie.title}"?',
      options: shuffledOptions,
      correctAnswer: year,
      explanation: '"${movie.title}" foi lançado em $year',
      imageUrl: movie.posterPath,
      movieId: movie.id.toString(),
      difficulty: difficulty,
      points: _getPointsForDifficulty(difficulty),
    );
  }

  Future<QuizQuestion?> _createImageQuestion(
    Movie movie,
    List<Movie> allMovies,
    DifficultyLevel difficulty,
  ) async {
    if (movie.posterPath.isEmpty) return null;

    final options = _createMovieOptions(movie, allMovies, 4);

    return QuizQuestion(
      id: 'q_${movie.id}_image',
      type: QuestionType.image,
      question: 'Qual é este filme?',
      options: options,
      correctAnswer: movie.title,
      explanation: 'Este é o pôster de "${movie.title}"',
      imageUrl: movie.posterPath,
      movieId: movie.id.toString(),
      difficulty: difficulty,
      points: _getPointsForDifficulty(difficulty),
    );
  }

  Future<QuizQuestion?> _createCastQuestion(
    Movie movie,
    List<Movie> allMovies,
    DifficultyLevel difficulty,
  ) async {
    // Simulação - na prática você buscaria o elenco real da API
    final options = _createMovieOptions(movie, allMovies, 4);

    return QuizQuestion(
      id: 'q_${movie.id}_cast',
      type: QuestionType.cast,
      question: 'Qual filme tem a maior avaliação entre estes?',
      options: options,
      correctAnswer: movie.title,
      explanation: '"${movie.title}" tem ${movie.voteAverage.toStringAsFixed(1)} de avaliação',
      imageUrl: movie.posterPath,
      movieId: movie.id.toString(),
      difficulty: difficulty,
      points: _getPointsForDifficulty(difficulty),
    );
  }

  List<String> _createMovieOptions(Movie correctMovie, List<Movie> allMovies, int count) {
    final options = <String>{correctMovie.title};
    
    // Pegar filmes aleatórios como opções incorretas
    final otherMovies = allMovies.where((m) => m.id != correctMovie.id).toList()
      ..shuffle();
    
    for (var movie in otherMovies) {
      if (options.length >= count) break;
      options.add(movie.title);
    }
    
    // Se não tiver filmes suficientes, adicionar opções genéricas
    final fallbackOptions = [
      'Inception',
      'The Matrix',
      'Interstellar',
      'The Godfather',
      'Pulp Fiction',
      'The Dark Knight',
      'Fight Club',
      'Forrest Gump',
    ];
    
    for (var option in fallbackOptions) {
      if (options.length >= count) break;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    
    return (options.toList()..shuffle()).take(count).toList();
  }

  int _getPointsForDifficulty(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 5;
      case DifficultyLevel.medium:
        return 10;
      case DifficultyLevel.hard:
        return 15;
    }
  }

  // Perguntas de fallback caso a API falhe
  List<QuizQuestion> _getFallbackQuestions() {
    return [
      QuizQuestion(
        id: 'fb_1',
        type: QuestionType.trivia,
        question: 'Qual é o filme com maior bilheteria de todos os tempos (sem ajuste de inflação)?',
        options: ['Avatar', 'Avengers: Endgame', 'Titanic', 'Star Wars'],
        correctAnswer: 'Avatar',
        difficulty: DifficultyLevel.medium,
        points: 10,
      ),
      QuizQuestion(
        id: 'fb_2',
        type: QuestionType.trivia,
        question: 'Quantos filmes de "Harry Potter" foram lançados?',
        options: ['7 filmes', '8 filmes', '9 filmes', '10 filmes'],
        correctAnswer: '8 filmes',
        difficulty: DifficultyLevel.easy,
        points: 5,
      ),
      QuizQuestion(
        id: 'fb_3',
        type: QuestionType.trivia,
        question: 'Qual filme ganhou o Oscar de Melhor Filme em 2020?',
        options: ['Parasita', '1917', 'Coringa', 'Era Uma Vez em... Hollywood'],
        correctAnswer: 'Parasita',
        difficulty: DifficultyLevel.medium,
        points: 10,
      ),
      QuizQuestion(
        id: 'fb_4',
        type: QuestionType.trivia,
        question: 'Quem dirigiu "Inception"?',
        options: ['Christopher Nolan', 'Steven Spielberg', 'Martin Scorsese', 'Quentin Tarantino'],
        correctAnswer: 'Christopher Nolan',
        difficulty: DifficultyLevel.easy,
        points: 5,
      ),
      QuizQuestion(
        id: 'fb_5',
        type: QuestionType.trivia,
        question: 'Em qual ano foi lançado o primeiro filme da franquia "Star Wars"?',
        options: ['1977', '1975', '1980', '1983'],
        correctAnswer: '1977',
        difficulty: DifficultyLevel.medium,
        points: 10,
      ),
    ];
  }
}

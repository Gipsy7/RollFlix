class QuizQuestion {
  final String id;
  final QuestionType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final String? imageUrl;
  final String? movieId;
  final DifficultyLevel difficulty;
  final int points;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.imageUrl,
    this.movieId,
    this.difficulty = DifficultyLevel.medium,
    this.points = 10,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.synopsis,
      ),
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'],
      imageUrl: json['imageUrl'],
      movieId: json['movieId']?.toString(),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString() == 'DifficultyLevel.${json['difficulty']}',
        orElse: () => DifficultyLevel.medium,
      ),
      points: json['points'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'movieId': movieId,
      'difficulty': difficulty.toString().split('.').last,
      'points': points,
    };
  }
}

enum QuestionType {
  synopsis,      // Adivinhar pelo resumo
  cast,          // Adivinhar pelo elenco
  image,         // Adivinhar pela imagem
  year,          // Adivinhar o ano
  director,      // Adivinhar o diretor
  quote,         // Adivinhar pela citação
  trivia,        // Curiosidades
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int totalPoints;
  final int timeSpent; // em segundos
  final DateTime completedAt;
  final List<QuestionResult> questionResults;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalPoints,
    required this.timeSpent,
    required this.completedAt,
    required this.questionResults,
  });

  double get accuracy => totalQuestions > 0 
      ? (correctAnswers / totalQuestions) * 100 
      : 0;

  String get grade {
    if (accuracy >= 90) return 'Excelente!';
    if (accuracy >= 75) return 'Muito Bom!';
    if (accuracy >= 60) return 'Bom';
    if (accuracy >= 40) return 'Regular';
    return 'Precisa Melhorar';
  }

  String get emoji {
    if (accuracy >= 90) return '🏆';
    if (accuracy >= 75) return '🎬';
    if (accuracy >= 60) return '🎭';
    if (accuracy >= 40) return '🎪';
    return '📽️';
  }
}

class QuestionResult {
  final QuizQuestion question;
  final String userAnswer;
  final bool isCorrect;
  final int pointsEarned;
  final int timeSpent; // em segundos

  const QuestionResult({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
    required this.pointsEarned,
    required this.timeSpent,
  });
}

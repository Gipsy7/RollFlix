import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';
import '../widgets/app_card.dart';
import 'quiz_result_screen.dart';

class MovieQuizScreen extends StatefulWidget {
  const MovieQuizScreen({super.key});

  @override
  State<MovieQuizScreen> createState() => _MovieQuizScreenState();
}

class _MovieQuizScreenState extends State<MovieQuizScreen> {
  final QuizService _quizService = QuizService();
  
  List<QuizQuestion> _questions = [];
  List<QuestionResult> _results = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isLoading = true;
  int _totalPoints = 0;
  
  Timer? _questionTimer;
  int _questionTimeSpent = 0;
  int _totalTimeSpent = 0;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    setState(() => _isLoading = true);
    
    try {
      final questions = await _quizService.generateQuiz(
        questionCount: 10,
        difficulty: DifficultyLevel.medium,
      );
      
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
      
      _startQuestionTimer();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar quiz: $e')),
        );
      }
    }
  }

  void _startQuestionTimer() {
    _questionTimeSpent = 0;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _questionTimeSpent++;
        _totalTimeSpent++;
      });
    });
  }

  void _selectAnswer(String answer) {
    if (_isAnswered) return;
    
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _confirmAnswer() {
    if (_selectedAnswer == null || _isAnswered) return;
    
    _questionTimer?.cancel();
    
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == currentQuestion.correctAnswer;
    final pointsEarned = isCorrect ? currentQuestion.points : 0;
    
    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _totalPoints += pointsEarned;
      }
      
      _results.add(QuestionResult(
        question: currentQuestion,
        userAnswer: _selectedAnswer!,
        isCorrect: isCorrect,
        pointsEarned: pointsEarned,
        timeSpent: _questionTimeSpent,
      ));
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
      _startQuestionTimer();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    _questionTimer?.cancel();
    
    final result = QuizResult(
      totalQuestions: _questions.length,
      correctAnswers: _results.where((r) => r.isCorrect).length,
      totalPoints: _totalPoints,
      timeSpent: _totalTimeSpent,
      completedAt: DateTime.now(),
      questionResults: _results,
    );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz de Filmes'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Preparando seu quiz...'),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz de Filmes'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Não foi possível carregar o quiz'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadQuiz,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Filmes'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pontuação e tempo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                '$_totalPoints pts',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                _formatTime(_questionTimeSpent),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Imagem (se disponível)
                  if (currentQuestion.type == QuestionType.image && 
                      currentQuestion.imageUrl != null)
                    AppCard(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          currentQuestion.imageUrl!,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: const Icon(Icons.movie, size: 64),
                            );
                          },
                        ),
                      ),
                    ),
                  
                  if (currentQuestion.type == QuestionType.image)
                    const SizedBox(height: 24),
                  
                  // Pergunta
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getQuestionTypeIcon(currentQuestion.type),
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getQuestionTypeLabel(currentQuestion.type),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(currentQuestion.difficulty)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${currentQuestion.points} pts',
                                  style: TextStyle(
                                    color: _getDifficultyColor(currentQuestion.difficulty),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentQuestion.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Opções
                  ...currentQuestion.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrect = option == currentQuestion.correctAnswer;
                    
                    Color? backgroundColor;
                    Color? borderColor;
                    
                    if (_isAnswered) {
                      if (isCorrect) {
                        backgroundColor = Colors.green.withOpacity(0.1);
                        borderColor = Colors.green;
                      } else if (isSelected) {
                        backgroundColor = Colors.red.withOpacity(0.1);
                        borderColor = Colors.red;
                      }
                    } else if (isSelected) {
                      backgroundColor = Colors.blue.withOpacity(0.1);
                      borderColor = Colors.blue;
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(option),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor ?? Colors.white,
                            border: Border.all(
                              color: borderColor ?? Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (_isAnswered && isCorrect)
                                const Icon(Icons.check_circle, color: Colors.green),
                              if (_isAnswered && isSelected && !isCorrect)
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                  // Explicação (após responder)
                  if (_isAnswered && currentQuestion.explanation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AppCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentQuestion.explanation!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Botões de ação
                  if (!_isAnswered)
                    ElevatedButton(
                      onPressed: _selectedAnswer != null ? _confirmAnswer : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirmar Resposta',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentQuestionIndex < _questions.length - 1
                            ? 'Próxima Pergunta'
                            : 'Ver Resultado',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  IconData _getQuestionTypeIcon(QuestionType type) {
    switch (type) {
      case QuestionType.synopsis:
        return Icons.description;
      case QuestionType.image:
        return Icons.image;
      case QuestionType.year:
        return Icons.calendar_today;
      case QuestionType.cast:
        return Icons.people;
      case QuestionType.director:
        return Icons.person;
      case QuestionType.quote:
        return Icons.format_quote;
      case QuestionType.trivia:
        return Icons.lightbulb;
    }
  }

  String _getQuestionTypeLabel(QuestionType type) {
    switch (type) {
      case QuestionType.synopsis:
        return 'SINOPSE';
      case QuestionType.image:
        return 'IMAGEM';
      case QuestionType.year:
        return 'ANO DE LANÇAMENTO';
      case QuestionType.cast:
        return 'ELENCO';
      case QuestionType.director:
        return 'DIRETOR';
      case QuestionType.quote:
        return 'CITAÇÃO';
      case QuestionType.trivia:
        return 'CURIOSIDADE';
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Colors.green;
      case DifficultyLevel.medium:
        return Colors.orange;
      case DifficultyLevel.hard:
        return Colors.red;
    }
  }
}

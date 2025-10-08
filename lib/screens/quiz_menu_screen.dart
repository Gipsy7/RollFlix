import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../utils/color_extensions.dart';
import 'movie_quiz_screen.dart';

class QuizMenuScreen extends StatefulWidget {
  const QuizMenuScreen({super.key});

  @override
  State<QuizMenuScreen> createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  DifficultyLevel _selectedDifficulty = DifficultyLevel.medium;
  int _questionCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Filmes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header com ilustração
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade700,
                    Colors.blue.shade700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Quiz de Filmes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Teste seus conhecimentos sobre cinema!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dificuldade
                  const Text(
                    'Dificuldade',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _DifficultyCard(
                    level: DifficultyLevel.easy,
                    title: 'Fácil',
                    description: 'Perguntas básicas sobre filmes populares',
                    icon: Icons.sentiment_satisfied,
                    color: Colors.green,
                    points: '5 pontos por questão',
                    isSelected: _selectedDifficulty == DifficultyLevel.easy,
                    onTap: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.easy;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _DifficultyCard(
                    level: DifficultyLevel.medium,
                    title: 'Médio',
                    description: 'Para cinéfilos com bom conhecimento',
                    icon: Icons.sentiment_neutral,
                    color: Colors.orange,
                    points: '10 pontos por questão',
                    isSelected: _selectedDifficulty == DifficultyLevel.medium,
                    onTap: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.medium;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _DifficultyCard(
                    level: DifficultyLevel.hard,
                    title: 'Difícil',
                    description: 'Desafio para verdadeiros especialistas',
                    icon: Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                    points: '15 pontos por questão',
                    isSelected: _selectedDifficulty == DifficultyLevel.hard,
                    onTap: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.hard;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Número de perguntas
                  const Text(
                    'Número de Perguntas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacitySafe(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Perguntas:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$_questionCount',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          value: _questionCount.toDouble(),
                          min: 5,
                          max: 20,
                          divisions: 15,
                          label: '$_questionCount perguntas',
                          onChanged: (value) {
                            setState(() {
                              _questionCount = value.toInt();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '20',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Resumo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Resumo do Quiz',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.question_answer,
                          label: 'Perguntas',
                          value: '$_questionCount',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.speed,
                          label: 'Dificuldade',
                          value: _getDifficultyName(_selectedDifficulty),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.stars,
                          label: 'Pontuação Máxima',
                          value: '${_questionCount * _getPointsForDifficulty(_selectedDifficulty)} pontos',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botão iniciar
                  ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Iniciar Quiz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Estatísticas/Dicas
                  _TipCard(
                    icon: Icons.emoji_events,
                    title: 'Dica',
                    description: 'Leia com atenção e não tenha pressa. Você pode ganhar pontos extras por respostas rápidas!',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MovieQuizScreen(),
      ),
    );
  }

  String _getDifficultyName(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return 'Fácil';
      case DifficultyLevel.medium:
        return 'Médio';
      case DifficultyLevel.hard:
        return 'Difícil';
    }
  }

  int _getPointsForDifficulty(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.easy:
        return 5;
      case DifficultyLevel.medium:
        return 10;
      case DifficultyLevel.hard:
        return 15;
    }
  }
}

class _DifficultyCard extends StatelessWidget {
  final DifficultyLevel level;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String points;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.level,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.points,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacitySafe(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacitySafe(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacitySafe(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    points,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.amber.shade700,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

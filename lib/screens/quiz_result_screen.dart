import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../utils/color_extensions.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado do Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de resultado principal
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getGradeColor().withOpacitySafe(0.8),
                    _getGradeColor(),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getGradeColor().withOpacitySafe(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    result.emoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.grade,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.accuracy.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${result.correctAnswers} de ${result.totalQuestions} corretas',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Estatísticas
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.stars,
                    label: 'Pontuação',
                    value: '${result.totalPoints}',
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer,
                    label: 'Tempo',
                    value: _formatTime(result.timeSpent),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle,
                    label: 'Acertos',
                    value: '${result.correctAnswers}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.cancel,
                    label: 'Erros',
                    value: '${result.totalQuestions - result.correctAnswers}',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Título das respostas
            const Text(
              'Suas Respostas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de respostas
            ...result.questionResults.asMap().entries.map((entry) {
              final index = entry.key;
              final questionResult = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _QuestionReviewCard(
                  questionNumber: index + 1,
                  result: questionResult,
                ),
              );
            }).toList(),
            
            const SizedBox(height: 24),
            
            // Botões de ação
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Fazer Outro Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('Voltar ao Início'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor() {
    if (result.accuracy >= 90) return Colors.purple;
    if (result.accuracy >= 75) return Colors.blue;
    if (result.accuracy >= 60) return Colors.green;
    if (result.accuracy >= 40) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  final int questionNumber;
  final QuestionResult result;

  const _QuestionReviewCard({
    required this.questionNumber,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: result.isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacitySafe(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: result.isCorrect 
                      ? Colors.green 
                      : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$questionNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  result.question.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                result.isCorrect ? Icons.check_circle : Icons.cancel,
                color: result.isCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          
          // Sua resposta
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sua resposta: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  result.userAnswer,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: result.isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          
          // Resposta correta (se errou)
          if (!result.isCorrect) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resposta correta: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    result.question.correctAnswer,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          // Explicação
          if (result.question.explanation != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacitySafe(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.question.explanation!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Pontuação e tempo
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.stars,
                size: 16,
                color: Colors.amber[700],
              ),
              const SizedBox(width: 4),
              Text(
                '${result.pointsEarned} pts',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.timer,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${result.timeSpent}s',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

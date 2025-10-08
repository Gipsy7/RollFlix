import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/date_night_preferences.dart';
import '../utils/color_extensions.dart';
import '../widgets/responsive_widgets.dart';

class DateNightGamesScreen extends StatelessWidget {
  const DateNightGamesScreen({super.key});

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  static final List<DateNightGame> _games = [
    const DateNightGame(
      name: '20 Perguntas Íntimas',
      description: 'Conheçam melhor um ao outro com perguntas profundas e divertidas',
      rules: [
        'Alternem entre fazer perguntas',
        'Sejam honestos e abertos',
        'Sem julgamentos',
        'Podem passar uma pergunta se quiserem',
      ],
      difficulty: 'Fácil',
      players: 2,
      durationMinutes: 30,
    ),
    const DateNightGame(
      name: 'Verdade ou Desafio Romântico',
      description: 'Versão romântica do clássico jogo',
      rules: [
        'Escolha verdade ou desafio',
        'Verdades devem ser sinceras',
        'Desafios devem ser cumpridos',
        'Mantenha o clima leve e divertido',
      ],
      difficulty: 'Médio',
      players: 2,
      durationMinutes: 45,
    ),
    const DateNightGame(
      name: 'Batalha Culinária',
      description: 'Competição amigável de preparar um prato',
      rules: [
        'Mesmo ingredientes, pratos diferentes',
        'Tempo limite: 30 minutos',
        'Avaliem juntos',
        'Quem perder faz a louça!',
      ],
      difficulty: 'Avançado',
      players: 2,
      durationMinutes: 60,
    ),
    const DateNightGame(
      name: 'Quiz do Casal',
      description: 'Testem o quanto se conhecem',
      rules: [
        'Escrevam respostas sobre o outro',
        'Comparem as respostas',
        'Ganhem pontos por acertos',
        'Descubram coisas novas!',
      ],
      difficulty: 'Fácil',
      players: 2,
      durationMinutes: 20,
    ),
    const DateNightGame(
      name: 'Adivinha o Filme',
      description: 'Mímica de cenas de filmes',
      rules: [
        'Um faz mímica, outro adivinha',
        'Sem palavras!',
        'Tempo limite: 1 minuto por filme',
        'Quem acertar mais ganha',
      ],
      difficulty: 'Médio',
      players: 2,
      durationMinutes: 30,
    ),
    const DateNightGame(
      name: 'Construam a História',
      description: 'Criem uma história juntos',
      rules: [
        'Um começa a história',
        'Outro continua',
        'Alternem a cada frase',
        'Quanto mais absurdo, melhor!',
      ],
      difficulty: 'Fácil',
      players: 2,
      durationMinutes: 25,
    ),
  ];

  static final List<ConversationStarter> _conversationStarters = [
    const ConversationStarter(
      category: 'Sonhos e Aspirações',
      icon: '✨',
      questions: [
        'Se você pudesse viver em qualquer lugar do mundo, onde seria?',
        'Qual é o seu maior sonho profissional?',
        'O que você gostaria de aprender nos próximos 5 anos?',
        'Se pudesse ter qualquer superpoder, qual seria?',
        'Qual seria sua vida ideal daqui a 10 anos?',
      ],
    ),
    const ConversationStarter(
      category: 'Memórias e Experiências',
      icon: '📸',
      questions: [
        'Qual é a sua melhor memória de infância?',
        'Qual foi a viagem mais marcante que você já fez?',
        'Qual foi o momento mais embaraçoso da sua vida?',
        'Qual foi o melhor presente que você já recebeu?',
        'Qual foi o dia mais feliz da sua vida até agora?',
      ],
    ),
    const ConversationStarter(
      category: 'Gostos e Preferências',
      icon: '❤️',
      questions: [
        'Qual é o seu filme favorito de todos os tempos?',
        'Se pudesse jantar com qualquer pessoa, viva ou morta, quem seria?',
        'Qual é a sua comida de conforto?',
        'Praia ou montanha? Por quê?',
        'Qual música te faz sentir mais vivo?',
      ],
    ),
    const ConversationStarter(
      category: 'Diversão e Imaginação',
      icon: '🎭',
      questions: [
        'Se sua vida fosse um filme, qual seria o gênero?',
        'Qual superpoder você NÃO gostaria de ter?',
        'Se pudesse ser invisível por um dia, o que faria?',
        'Qual seria seu nome de estrela de cinema?',
        'Se pudesse voltar para qualquer década, qual seria?',
      ],
    ),
    const ConversationStarter(
      category: 'Filosofia e Valores',
      icon: '💭',
      questions: [
        'O que você considera mais importante na vida?',
        'Qual conselho você daria para seu eu de 10 anos atrás?',
        'O que te faz sentir mais grato?',
        'Qual é o seu maior medo?',
        'O que significa sucesso para você?',
      ],
    ),
    const ConversationStarter(
      category: 'Relacionamento',
      icon: '💑',
      questions: [
        'O que você mais valoriza em um relacionamento?',
        'Qual foi nossa melhor memória juntos?',
        'O que você gostaria que fizéssemos mais frequentemente?',
        'Como você se sente mais amado(a)?',
        'Onde você nos vê daqui a 5 anos?',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: SafeText(
          'Jogos & Atividades',
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        ),
        backgroundColor: _darkRose,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: _darkRose,
              child: TabBar(
                indicatorColor: _secondaryGold,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.games),
                    text: 'Jogos',
                  ),
                  Tab(
                    icon: Icon(Icons.chat_bubble),
                    text: 'Conversas',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGamesTab(isMobile),
                  _buildConversationTab(isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesTab(bool isMobile) {
    return ListView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      children: [
        _buildSectionHeader(
          title: 'Jogos para o Encontro',
          subtitle: 'Deixe a noite mais divertida e memorável',
          icon: Icons.celebration,
        ),
        const SizedBox(height: 16),
        ..._games.map((game) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _GameCard(game: game),
        )),
      ],
    );
  }

  Widget _buildConversationTab(bool isMobile) {
    return ListView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      children: [
        _buildSectionHeader(
          title: 'Iniciadores de Conversa',
          subtitle: 'Perguntas interessantes para conhecerem melhor um ao outro',
          icon: Icons.forum,
        ),
        const SizedBox(height: 16),
        ..._conversationStarters.map((starter) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ConversationCard(starter: starter),
        )),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkRose, _primaryRose],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: _secondaryGold, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
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

class _GameCard extends StatelessWidget {
  final DateNightGame game;

  const _GameCard({required this.game});

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  Color get _difficultyColor {
    switch (game.difficulty.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'médio':
        return Colors.orange;
      case 'avançado':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _primaryRose.withOpacitySafe(0.3)),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryRose, _secondaryGold],
              ),
            ),
            child: const Icon(Icons.casino, color: Colors.white),
          ),
          title: Text(
            game.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _InfoChip(
                  icon: Icons.people,
                  label: '${game.players} jogadores',
                  color: _secondaryGold,
                ),
                _InfoChip(
                  icon: Icons.timer,
                  label: '${game.durationMinutes} min',
                  color: Colors.blue,
                ),
                _InfoChip(
                  icon: Icons.speed,
                  label: game.difficulty,
                  color: _difficultyColor,
                ),
              ],
            ),
          ),
          children: [
            const SizedBox(height: 12),
            Text(
              game.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryRose.withOpacitySafe(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.rule, color: _secondaryGold, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Regras',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...game.rules.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _secondaryGold.withOpacitySafe(0.3),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatefulWidget {
  final ConversationStarter starter;

  const _ConversationCard({required this.starter});

  @override
  State<_ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<_ConversationCard> {
  int _currentQuestionIndex = 0;

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _secondaryGold.withOpacitySafe(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.starter.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.starter.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _secondaryGold.withOpacitySafe(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.starter.questions.length} perguntas',
                  style: TextStyle(
                    color: _secondaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryRose.withOpacitySafe(0.2),
                  _secondaryGold.withOpacitySafe(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.question_answer,
                  color: _secondaryGold,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.starter.questions[_currentQuestionIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentQuestionIndex + 1}/${widget.starter.questions.length}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex = 
                        (_currentQuestionIndex + 1) % widget.starter.questions.length;
                  });
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Próxima'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryRose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
  color: color.withOpacitySafe(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

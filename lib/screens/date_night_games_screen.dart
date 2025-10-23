import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/date_night_preferences.dart';
import '../utils/color_extensions.dart';
import '../widgets/responsive_widgets.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class DateNightGamesScreen extends StatelessWidget {
  const DateNightGamesScreen({super.key});

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  static List<DateNightGame> _getDateNightGames(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      DateNightGame(
        name: localizations.intimateQuestionsGame,
        description: localizations.intimateQuestionsDesc,
        rules: [
          localizations.alternateQuestionsRule,
          localizations.beHonestOpenRule,
          localizations.noJudgmentsRule,
          localizations.canSkipQuestionRule,
        ],
        difficulty: localizations.easy,
        players: 2,
        durationMinutes: 30,
      ),
      DateNightGame(
        name: localizations.romanticTruthOrDare,
        description: localizations.romanticTruthOrDareDesc,
        rules: [
          localizations.chooseTruthOrDareRule,
          localizations.truthsMustBeSincereRule,
          localizations.daresMustBeCompletedRule,
          localizations.keepLightFunRule,
        ],
        difficulty: localizations.medium,
        players: 2,
        durationMinutes: 45,
      ),
      DateNightGame(
        name: localizations.cookingBattle,
        description: localizations.cookingBattleDesc,
        rules: [
          localizations.cookingBattleRule1,
          localizations.cookingBattleRule2,
          localizations.cookingBattleRule3,
          localizations.cookingBattleRule4,
        ],
        difficulty: localizations.advanced,
        players: 2,
        durationMinutes: 60,
      ),
      DateNightGame(
        name: 'Quiz do Casal',
        description: localizations.coupleQuizDesc,
        rules: [
          localizations.coupleQuizRule1,
          localizations.coupleQuizRule2,
          localizations.coupleQuizRule3,
          localizations.coupleQuizRule4,
        ],
        difficulty: localizations.easy,
        players: 2,
        durationMinutes: 20,
      ),
      DateNightGame(
        name: localizations.guessTheMovie,
        description: localizations.guessTheMovieDesc,
        rules: [
          localizations.movieMimicRule1,
          localizations.movieMimicRule2,
          localizations.movieMimicRule3,
          localizations.whoGetsMoreRightWinsRule,
        ],
        difficulty: localizations.medium,
        players: 2,
        durationMinutes: 30,
      ),
      DateNightGame(
        name: localizations.buildTheStory,
        description: localizations.buildTheStoryDesc,
        rules: [
          localizations.buildTheStoryRule1,
          localizations.buildTheStoryRule2,
          localizations.buildTheStoryRule3,
          localizations.buildTheStoryRule4,
        ],
        difficulty: localizations.easy,
        players: 2,
        durationMinutes: 25,
      ),
    ];
  }

  static List<ConversationStarter> _getConversationStarters(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      ConversationStarter(
        category: localizations.dreamsAndAspirations,
        icon: '✨',
        questions: [
          localizations.dreamLocationQuestion,
          localizations.professionalDreamQuestion,
          localizations.learnIn5YearsQuestion,
          localizations.superpowerQuestion,
          localizations.idealLifeQuestion,
        ],
      ),
      ConversationStarter(
        category: localizations.memoriesAndExperiences,
        icon: '📸',
        questions: [
          localizations.bestChildhoodMemoryQuestion,
          localizations.mostMemorableTripQuestion,
          localizations.mostEmbarrassingMomentQuestion,
          localizations.bestGiftReceivedQuestion,
          localizations.happiestDayQuestion,
        ],
      ),
      ConversationStarter(
        category: localizations.tastesAndPreferences,
        icon: '❤️',
        questions: [
          localizations.favoriteMovieQuestion,
          localizations.dinnerWithAnyoneQuestion,
          localizations.comfortFoodQuestion,
          localizations.beachOrMountainQuestion,
          localizations.musicThatMakesAliveQuestion,
        ],
      ),
      ConversationStarter(
        category: localizations.funAndImagination,
        icon: '🎭',
        questions: [
          localizations.movieGenreQuestion,
          localizations.superpowerNotWantedQuestion,
          localizations.invisibleDayQuestion,
          localizations.movieStarNameQuestion,
          localizations.decadeToReturnQuestion,
        ],
      ),
      ConversationStarter(
        category: localizations.philosophyAndValues,
        icon: '💭',
        questions: [
          localizations.mostImportantInLifeQuestion,
          localizations.adviceToYoungerSelfQuestion,
          localizations.whatMakesGratefulQuestion,
          localizations.biggestFearQuestion,
          localizations.successMeaningQuestion,
        ],
      ),
      ConversationStarter(
        category: localizations.relationship,
        icon: '💑',
        questions: [
          localizations.mostValuedInRelationshipQuestion,
          localizations.bestMemoryTogetherQuestion,
          localizations.doMoreFrequentlyQuestion,
          localizations.feelMostLovedQuestion,
          localizations.whereWeSeeIn5YearsQuestion,
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: SafeText(
          AppLocalizations.of(context)!.gamesAndActivities,
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
                  _buildGamesTab(context, isMobile),
                  _buildConversationTab(context, isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesTab(BuildContext context, bool isMobile) {
    return ListView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      children: [
        _buildSectionHeader(
          title: AppLocalizations.of(context)!.dateNightGames,
          subtitle: AppLocalizations.of(context)!.makeNightFun,
          icon: Icons.celebration,
        ),
        const SizedBox(height: 16),
        ..._getDateNightGames(context).map((game) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _GameCard(game: game),
        )),
      ],
    );
  }

  Widget _buildConversationTab(BuildContext context, bool isMobile) {
    return ListView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      children: [
        _buildSectionHeader(
          title: AppLocalizations.of(context)!.conversationStarters,
          subtitle: AppLocalizations.of(context)!.interestingQuestions,
          icon: Icons.forum,
        ),
        const SizedBox(height: 16),
        ..._getConversationStarters(context).map((starter) => Padding(
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

  String _getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (game.name) {
      case '20 Perguntas Íntimas':
        return l10n.intimateQuestionsGame;
      case 'Verdade ou Desafio Romântico':
        return l10n.romanticTruthOrDare;
      case 'Batalha Culinária':
        return l10n.cookingBattle;
      default:
        return game.name;
    }
  }

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  Color getDifficultyColor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final difficulty = game.difficulty.toLowerCase();
    if (difficulty == l10n.easy.toLowerCase()) {
      return Colors.green;
    } else if (difficulty == l10n.medium.toLowerCase()) {
      return Colors.orange;
    } else if (difficulty == l10n.advanced.toLowerCase()) {
      return Colors.red;
    } else {
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
            _getLocalizedName(context),
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
                  label: '${game.players} ${AppLocalizations.of(context)!.players}',
                  color: _secondaryGold,
                ),
                _InfoChip(
                  icon: Icons.timer,
                  label: '${game.durationMinutes} ${AppLocalizations.of(context)!.minutes}',
                  color: Colors.blue,
                ),
                _InfoChip(
                  icon: Icons.speed,
                  label: game.difficulty,
                  color: getDifficultyColor(context),
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
                  Row(
                    children: [
                      const Icon(Icons.rule, color: _secondaryGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.rules,
                        style: const TextStyle(
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
                  '${widget.starter.questions.length} ${AppLocalizations.of(context)!.questions}',
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
                label: Text(AppLocalizations.of(context)!.next),
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

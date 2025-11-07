import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../core/constants/constants.dart';
import '../widgets/responsive_widgets.dart';
import '../controllers/app_mode_controller.dart';
import '../controllers/locale_controller.dart';
import '../constants/app_constants.dart';

/// Tela "Sobre o App" com informações detalhadas do aplicativo
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final AppModeController _appModeController;

  @override
  void initState() {
    super.initState();
    _appModeController = AppModeController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.instance,
      builder: (context, locale, _) {
        return ListenableBuilder(
          listenable: _appModeController,
          builder: (context, _) {
        // Cores adaptativas baseadas no modo
        final primaryColor = _appModeController.isSeriesMode
            ? const Color(0xFFBB86FC) // Roxo para séries
            : AppColors.primary; // Dourado para filmes

        final gradientColors = _appModeController.isSeriesMode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 45, 3, 56),
                  Color.fromARGB(255, 255, 0, 128),
                ],
              )
            : AppColors.cinemaGradient;

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: AppBar(
            title: SafeText(
              AppLocalizations.of(context)!.aboutApp,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: gradientColors),
            ),
            iconTheme: IconThemeData(color: primaryColor),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: _appModeController.isSeriesMode
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFBB86FC),
                                    Color(0xFF9C27B0),
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFD700), // Rich Gold
                                    Color(0xFFFFC107), // Deep Gold
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _appModeController.isSeriesMode
                              ? Icons.tv
                              : Icons.movie_filter,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.appVersion,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Descrição
                _buildSectionTitle(AppLocalizations.of(context)!.whatIsRollflix, primaryColor),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.whatIsRollflixDescription,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Recursos Disponíveis
                _buildSectionTitle(AppLocalizations.of(context)!.availableFeatures, primaryColor),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.casino,
                  AppLocalizations.of(context)!.movieSeriesRoller,
                  AppLocalizations.of(context)!.movieSeriesRollerDescription,
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.category,
                  AppLocalizations.of(context)!.genresAvailable,
                  AppLocalizations.of(context)!.genresAvailableDescription,
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.notifications_active,
                  AppLocalizations.of(context)!.smartNotifications,
                  AppLocalizations.of(context)!.smartNotificationsDescription,
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.favorite,
                  AppLocalizations.of(context)!.favoritesSystem,
                  AppLocalizations.of(context)!.favoritesSystemDescription,
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.switch_left,
                  AppLocalizations.of(context)!.movieSeriesMode,
                  AppLocalizations.of(context)!.movieSeriesModeDescription,
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 32),

                // Lançamentos Futuros
                _buildSectionTitle(AppLocalizations.of(context)!.inDevelopment, primaryColor),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.newFeaturesComing,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.quiz,
                  AppLocalizations.of(context)!.movieQuiz,
                  AppLocalizations.of(context)!.movieQuizDescription,
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.nightlight,
                  AppLocalizations.of(context)!.dateNight,
                  AppLocalizations.of(context)!.dateNightDescription,
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.music_note,
                  AppLocalizations.of(context)!.soundtrackQuiz,
                  AppLocalizations.of(context)!.soundtrackQuizDescription,
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 32),

                // Informações Técnicas
                _buildSectionTitle(AppLocalizations.of(context)!.technologies, primaryColor),
                const SizedBox(height: 16),

                _buildInfoRow(Icons.code, AppLocalizations.of(context)!.developedWithFlutter),
                const SizedBox(height: 12),

                const SizedBox(height: 32),

                // Divider
                Divider(color: Colors.grey[800]),

                const SizedBox(height: 16),

                // Copyright
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.copyright,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.allRightsReserved,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
          },
        );
      }
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description, {
    required bool isAvailable,
    required Color primaryColor,
  }) {
    final featureColor = isAvailable ? primaryColor : Colors.orange;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppNumbers.buttonPaddingVertical),
          decoration: BoxDecoration(
            color: featureColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: featureColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 24,
            color: featureColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (!isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.comingSoon,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}


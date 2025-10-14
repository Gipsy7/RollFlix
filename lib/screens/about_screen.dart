import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_widgets.dart';
import '../controllers/app_mode_controller.dart';

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
            title: const SafeText(
              'Sobre o App',
              style: TextStyle(
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
            padding: const EdgeInsets.all(16),
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
                              color: primaryColor.withOpacity(0.3),
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
                      const Text(
                        'Rollflix',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Versão 4.0.0',
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
                _buildSectionTitle('O que é o Rollflix?', primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Aplicativo para descobrir filmes e séries aleatórios por gênero. '
                  'Escolha entre mais de 18 gêneros diferentes e encontre seu próximo entretenimento!',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Recursos Disponíveis
                _buildSectionTitle('Recursos Disponíveis', primaryColor),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.casino,
                  'Sorteador de Filmes e Séries',
                  'Descubra seu próximo entretenimento de forma aleatória',
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.category,
                  '18+ Gêneros Disponíveis',
                  'Ação, comédia, terror, romance, ficção científica e muito mais',
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.notifications_active,
                  'Notificações Inteligentes',
                  'Fique por dentro dos lançamentos dos seus favoritos',
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.favorite,
                  'Sistema de Favoritos',
                  'Salve e acompanhe seus filmes e séries preferidos',
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.switch_left,
                  'Modo Filmes e Séries',
                  'Alterne facilmente entre filmes e séries',
                  isAvailable: true,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 32),

                // Lançamentos Futuros
                _buildSectionTitle('🚀 Em Desenvolvimento', primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Novos recursos que estão sendo desenvolvidos e em breve estarão disponíveis:',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.quiz,
                  'Quiz de Filmes',
                  'Teste seus conhecimentos sobre cinema com perguntas desafiadoras',
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.nightlight,
                  'Date Night',
                  'Encontre o filme ou série perfeito para assistir a dois',
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 16),

                _buildFeatureItem(
                  Icons.music_note,
                  'Quiz de Trilha Sonora',
                  'Adivinhe o filme ou série pela música',
                  isAvailable: false,
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 32),

                // Informações Técnicas
                _buildSectionTitle('Tecnologias', primaryColor),
                const SizedBox(height: 16),

                _buildInfoRow(Icons.code, 'Desenvolvido com Flutter'),
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
                        '2025 Rollflix',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Todos os direitos reservados',
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: featureColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: featureColor.withOpacity(0.3),
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
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'EM BREVE',
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

import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import '../../../models/tv_show.dart';
import '../../../widgets/content_widgets.dart';

/// Seção que exibe o card do conteúdo sorteado (filme ou série)
/// 
/// Componente que mostra:
/// - Contador de filmes/séries sorteados
/// - Card animado com informações do conteúdo
class ContentCardSection extends StatelessWidget {
  final bool isMobile;
  final bool isSeriesMode;
  final Movie? selectedMovie;
  final TVShow? selectedTVShow;
  final Animation<double> movieCardAnimation;
  final LinearGradient currentGradient;
  final Color currentAccentColor;
  final Color primaryColor;
  final int movieCount;
  final int tvShowCount;

  const ContentCardSection({
    super.key,
    required this.isMobile,
    required this.isSeriesMode,
    this.selectedMovie,
    this.selectedTVShow,
    required this.movieCardAnimation,
    required this.currentGradient,
    required this.currentAccentColor,
    required this.primaryColor,
    required this.movieCount,
    required this.tvShowCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contador unificado
        ContentCounter(
          count: isSeriesMode ? tvShowCount : movieCount,
          isSeriesMode: isSeriesMode,
        ),
        const SizedBox(height: 12),
        // Card do filme ou série
        if (isSeriesMode && selectedTVShow != null)
          ContentCard(
            tvShow: selectedTVShow,
            animation: movieCardAnimation,
            currentGradient: currentGradient,
            accentColor: currentAccentColor,
            isMobile: isMobile,
          )
        else if (!isSeriesMode && selectedMovie != null)
          ContentCard(
            movie: selectedMovie,
            animation: movieCardAnimation,
            currentGradient: currentGradient,
            accentColor: primaryColor,
            isMobile: isMobile,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

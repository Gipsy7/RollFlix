import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/genre_wheel.dart';

/// Seção de seleção de gênero com wheel animado
/// 
/// Componente que exibe:
/// - Header com ícone e título
/// - GenreWheel para seleção de gênero
/// - Botão de "Roll" para sortear conteúdo
class GenreSection extends StatelessWidget {
  final bool isMobile;
  final List<String> localizedGenres;
  final String? selectedGenre;
  final Function(String) onGenreSelected;
  final VoidCallback onRollContent;
  final bool isLoadingContent;
  final Color currentAccentColor;
  final bool isSeriesMode;
  final String currentContentType;

  const GenreSection({
    super.key,
    required this.isMobile,
    required this.localizedGenres,
    required this.selectedGenre,
    required this.onGenreSelected,
    required this.onRollContent,
    required this.isLoadingContent,
    required this.currentAccentColor,
    required this.isSeriesMode,
    required this.currentContentType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Espaçamento superior reduzido
        SizedBox(height: isMobile ? AppNumbers.spacingMedium : AppNumbers.spacingLarge),
        
        // Header com padding apenas nas laterais
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppNumbers.spacingMedium : AppNumbers.spacingLarge + 4,
          ),
          child: _buildGenreHeader(context),
        ),
        
        SizedBox(height: AppNumbers.spacingLarge),
        
        // GenreWheel otimizado - altura reduzida
        SizedBox(
          height: isMobile ? 350 : 400,
          width: double.infinity,
          child: GenreWheel(
            genres: localizedGenres,
            selectedGenre: selectedGenre,
            onGenreSelected: onGenreSelected,
            onRandomSpin: () {},
            onRollContent: onRollContent,
            isLoadingContent: isLoadingContent,
            accentColor: isSeriesMode ? currentAccentColor : null,
            isSeriesMode: isSeriesMode,
          ),
        ),
        
        // Espaçamento inferior reduzido
        SizedBox(height: isMobile ? 16 : 20),
      ],
    );
  }

  /// Header com ícone de cassino e título
  Widget _buildGenreHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppNumbers.spacingSmall + 4),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppNumbers.borderRadiusMedium),
          ),
          child: Icon(
            Icons.casino,
            color: currentAccentColor,
            size: AppNumbers.iconSizeMediumDesktop,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            '${AppLocalizations.of(context)!.chooseGenreOf} $currentContentType',
            style: (isMobile 
                ? AppTextStyles.titleMedium 
                : AppTextStyles.titleLarge
            ).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

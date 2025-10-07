import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';

/// Widget do cabeçalho da seção de seleção de gênero
class GenreHeader extends StatelessWidget {
  final String contentType;
  final Color accentColor;
  final bool isMobile;

  const GenreHeader({
    super.key,
    required this.contentType,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.casino,
            color: accentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: SafeText(
            'Escolha um Gênero de $contentType',
            style: (isMobile 
              ? AppTextStyles.headlineSmall
              : AppTextStyles.headlineMedium).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
          ),
        ),
      ],
    );
  }
}

/// Widget do botão de ação para rolar filme/série
class RollActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool hasSelection;
  final bool isSeriesMode;
  final Color accentColor;

  const RollActionButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.hasSelection,
    required this.isSeriesMode,
    required this.accentColor,
  });

  String get _buttonText {
    if (isLoading) return 'Rolando...';
    
    if (hasSelection) {
      return isSeriesMode ? 'Rolar Nova Série' : 'Rolar Novo Filme';
    }
    
    return isSeriesMode ? 'Rolar Série' : 'Rolar Filme';
  }

  IconData? get _buttonIcon {
    if (isLoading) return null;
    return isSeriesMode ? Icons.tv : Icons.local_movies;
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: _buttonText,
      isLoading: isLoading,
      icon: _buttonIcon,
      backgroundColor: accentColor,
    );
  }
}

/// Widget de mensagem de erro
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SafeText(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

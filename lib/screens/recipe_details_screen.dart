import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/optimized_widgets.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  final String recipeType; // 'Prato Principal', 'Sobremesa', etc.

  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
    required this.recipeType,
  });

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  LinearGradient get _romanticGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_darkRose, _primaryRose, _secondaryGold],
      );

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildContent(isMobile),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: SafeText(
          recipe.title,
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            OptimizedNetworkImage(
              imageUrl: recipe.image,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge do tipo de receita
            _buildTypeBadge(),
            const SizedBox(height: 16),

            // Informações rápidas
            _buildQuickInfo(),
            const SizedBox(height: 24),

            // Tags dietéticas
            if (recipe.dietaryTags.isNotEmpty) ...[
              _buildDietaryTags(),
              const SizedBox(height: 24),
            ],

            // Resumo
            if (recipe.summary != null) ...[
              _buildSummary(),
              const SizedBox(height: 24),
            ],

            // Informações nutricionais
            if (recipe.nutrition != null) ...[
              _buildNutritionInfo(),
              const SizedBox(height: 24),
            ],

            // Ingredientes
            if (recipe.extendedIngredients != null &&
                recipe.extendedIngredients!.isNotEmpty) ...[
              _buildIngredients(),
              const SizedBox(height: 24),
            ],

            // Modo de preparo
            if (recipe.analyzedInstructions != null &&
                recipe.analyzedInstructions!.isNotEmpty) ...[
              _buildInstructions(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: _romanticGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeText(
        recipeType,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildQuickInfo() {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.access_time,
            recipe.formattedTime,
            'Tempo',
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          _buildInfoItem(
            Icons.people,
            '${recipe.servings} porções',
            'Serve',
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          _buildInfoItem(
            Icons.attach_money,
            recipe.formattedPrice,
            'Custo',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: _primaryRose, size: 24),
        const SizedBox(height: 8),
        SafeText(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SafeText(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDietaryTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: recipe.dietaryTags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _secondaryGold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _secondaryGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: _secondaryGold, size: 16),
              const SizedBox(width: 4),
              SafeText(
                tag,
                style: TextStyle(
                  color: _secondaryGold,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummary() {
    // Remove HTML tags
    final cleanSummary = recipe.summary!
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: _primaryRose, size: 24),
              const SizedBox(width: 12),
              SafeText(
                'Sobre o Prato',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SafeText(
            cleanSummary,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    final nutrition = recipe.nutrition!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department, color: _secondaryGold, size: 24),
              const SizedBox(width: 12),
              SafeText(
                'Informações Nutricionais',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (nutrition.calories != null)
                _buildNutrientCard(
                  'Calorias',
                  nutrition.calories!.toStringAsFixed(0),
                  'kcal',
                  Icons.local_fire_department,
                ),
              if (nutrition.protein != null)
                _buildNutrientCard(
                  'Proteína',
                  nutrition.protein!.toStringAsFixed(1),
                  'g',
                  Icons.fitness_center,
                ),
              if (nutrition.carbs != null)
                _buildNutrientCard(
                  'Carboidratos',
                  nutrition.carbs!.toStringAsFixed(1),
                  'g',
                  Icons.grain,
                ),
              if (nutrition.fat != null)
                _buildNutrientCard(
                  'Gordura',
                  nutrition.fat!.toStringAsFixed(1),
                  'g',
                  Icons.opacity,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
      String label, String value, String unit, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryRose.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _primaryRose, size: 24),
        ),
        const SizedBox(height: 8),
        SafeText(
          '$value$unit',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SafeText(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_basket, color: _primaryRose, size: 24),
              const SizedBox(width: 12),
              SafeText(
                'Ingredientes',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recipe.extendedIngredients!.map((ingredient) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (ingredient.imageUrl.isNotEmpty)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          ingredient.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.fastfood,
                                color: _primaryRose, size: 24);
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _primaryRose.withValues(alpha: 0.2),
                      ),
                      child: Icon(Icons.fastfood, color: _primaryRose, size: 24),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SafeText(
                      ingredient.original,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: _secondaryGold, size: 24),
              const SizedBox(width: 12),
              SafeText(
                'Modo de Preparo',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recipe.analyzedInstructions!.asMap().entries.map((entry) {
            final step = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: _romanticGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SafeText(
                        '${step.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SafeText(
                      step.step,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/date_night_combo.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../widgets/date_night_widgets.dart';
import 'date_night_games_screen.dart';

class DateNightDetailsScreen extends StatefulWidget {
  final DateNightCombo combo;

  const DateNightDetailsScreen({
    super.key,
    required this.combo,
  });

  @override
  State<DateNightDetailsScreen> createState() => _DateNightDetailsScreenState();
}

class _DateNightDetailsScreenState extends State<DateNightDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Cores do tema romântico
  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  LinearGradient get _romanticGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _darkRose,
      _primaryRose,
      _secondaryGold,
    ],
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isMobile),
          _buildContent(isMobile),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 200 : 250,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: SafeText(
          'Detalhes do Encontro',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: _romanticGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SafeText(
                    widget.combo.theme,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Tabs de navegação
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: _primaryRose,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: _primaryRose,
              isScrollable: isMobile,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Filme', icon: Icon(Icons.movie, size: 20)),
                Tab(text: 'Refeição', icon: Icon(Icons.restaurant, size: 20)),
                Tab(text: 'Ambiente', icon: Icon(Icons.lightbulb, size: 20)),
                Tab(text: 'Lista', icon: Icon(Icons.shopping_cart, size: 20)),
                Tab(text: 'Ferramentas', icon: Icon(Icons.build, size: 20)),
              ],
            ),
          ),
          
          // Conteúdo das tabs
          SizedBox(
            height: 600,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMovieTab(isMobile),
                _buildMealTab(isMobile),
                _buildAtmosphereTab(isMobile),
                _buildShoppingListTab(isMobile),
                _buildToolsTab(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                // Poster e informações básicas
                isMobile 
                  ? Column(
                      children: [
                        // Poster em mobile (layout vertical)
                        Center(
                          child: Container(
                            width: 150,
                            height: 225,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: _romanticGradient.scale(0.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: widget.combo.moviePosterPath.isNotEmpty
                                  ? OptimizedNetworkImage(
                                      imageUrl: 'https://image.tmdb.org/t/p/w500${widget.combo.moviePosterPath}',
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: AppColors.surfaceDark,
                                      child: Icon(
                                        Icons.movie,
                                        size: 48,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Informações do filme em mobile
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SafeText(
                              widget.combo.movieTitle,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            SafeText(
                              'Ano: ${widget.combo.movieYear}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: _secondaryGold,
                                ),
                                const SizedBox(width: 4),
                                SafeText(
                                  '${widget.combo.movieRating.toStringAsFixed(1)}/10',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _primaryRose.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: _primaryRose,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: SafeText(
                                      'Perfeito para encontros!',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: _primaryRose,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Gêneros em mobile
                            if (widget.combo.movieGenres.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: widget.combo.movieGenres.map((genre) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [_primaryRose, _secondaryGold],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SafeText(
                                      genre,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster para tablet/desktop
                        Container(
                          width: 150,
                          height: 225,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: _romanticGradient.scale(0.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: widget.combo.moviePosterPath.isNotEmpty
                                ? OptimizedNetworkImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w500${widget.combo.moviePosterPath}',
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: AppColors.surfaceDark,
                                    child: Icon(
                                      Icons.movie,
                                      size: 48,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Informações do filme para tablet/desktop
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SafeText(
                                widget.combo.movieTitle,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              SafeText(
                                'Ano: ${widget.combo.movieYear}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (widget.combo.movieReleaseDate.isNotEmpty && widget.combo.movieReleaseDate != 'Data não disponível')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SafeText(
                                    'Lançamento: ${widget.combo.movieReleaseDate}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              if (widget.combo.movieRuntime.isNotEmpty && widget.combo.movieRuntime != 'Duração não disponível')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SafeText(
                                    'Duração: ${widget.combo.movieRuntime}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: _secondaryGold,
                                  ),
                                  const SizedBox(width: 4),
                                  SafeText(
                                    '${widget.combo.movieRating.toStringAsFixed(1)}/10',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _primaryRose.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: _primaryRose,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SafeText(
                                        'Perfeito para encontros!',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: _primaryRose,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Gêneros em desktop
                              if (widget.combo.movieGenres.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: widget.combo.movieGenres.map((genre) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [_primaryRose, _secondaryGold],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SafeText(
                                        genre,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                
                const SizedBox(height: 20),
                
                // Sinopse
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      'Sinopse',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SafeText(
                      widget.combo.movieOverview.isNotEmpty 
                          ? widget.combo.movieOverview
                          : 'Uma história romântica emocionante que vai tornar sua noite ainda mais especial.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                
                // Informações Técnicas
                if (widget.combo.movieProductionCompanies.isNotEmpty || 
                    widget.combo.movieOriginalLanguage.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeText(
                        'Informações Técnicas',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (widget.combo.movieOriginalLanguage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language,
                                size: 18,
                                color: _primaryRose,
                              ),
                              const SizedBox(width: 8),
                              SafeText(
                                'Idioma Original: ',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: SafeText(
                                  widget.combo.movieOriginalLanguage.toUpperCase(),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      if (widget.combo.movieProductionCompanies.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.business,
                              size: 18,
                              color: _primaryRose,
                            ),
                            const SizedBox(width: 8),
                            SafeText(
                              'Produção: ',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: SafeText(
                                widget.combo.movieProductionCompanies.take(3).join(', '),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
                
                // Onde Assistir
                if (widget.combo.movieWatchProviders.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryRose, _secondaryGold],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryRose.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SafeText(
                            'Onde Assistir',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      _buildWatchProvidersSection(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Prato Principal
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: _primaryRose, size: 24),
                    const SizedBox(width: 12),
                    SafeText(
                      'Prato Principal',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SafeText(
                  widget.combo.mainDish,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, 'Tempo', widget.combo.preparationTime),
                _buildInfoRow(Icons.star, 'Dificuldade', widget.combo.difficulty),
                _buildInfoRow(Icons.attach_money, 'Custo', widget.combo.estimatedCost),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bebida e Sobremesa
          isMobile 
            ? Column(
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_bar, color: _primaryRose, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SafeText(
                                'Bebida',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SafeText(
                          widget.combo.drink,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cake, color: _primaryRose, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SafeText(
                                'Sobremesa',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SafeText(
                          widget.combo.dessert,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_bar, color: _primaryRose, size: 20),
                          const SizedBox(width: 8),
                          SafeText(
                            'Bebida',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SafeText(
                        widget.combo.drink,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cake, color: _primaryRose, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SafeText(
                              'Sobremesa',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SafeText(
                        widget.combo.dessert,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Petiscos
          if (widget.combo.snacks.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_food_beverage, color: _primaryRose, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SafeText(
                          'Petiscos e Acompanhamentos',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.combo.snacks.map((snack) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryRose.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _primaryRose.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: SafeText(
                          snack,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _primaryRose,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Dicas de preparo
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: _secondaryGold, size: 20),
                    const SizedBox(width: 8),
                    SafeText(
                      'Dica do Chef',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SafeText(
                  widget.combo.cookingTips,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtmosphereTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Ambiente geral
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.mood, color: _primaryRose, size: 24),
                    const SizedBox(width: 12),
                    SafeText(
                      'Atmosfera do Encontro',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SafeText(
                  widget.combo.atmosphere,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Iluminação
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: _secondaryGold, size: 20),
                    const SizedBox(width: 8),
                    SafeText(
                      'Iluminação',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SafeText(
                  widget.combo.ambientLighting,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Playlist musical
          if (widget.combo.playlistSuggestions.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.music_note, color: _primaryRose, size: 20),
                      const SizedBox(width: 8),
                      SafeText(
                        'Trilha Sonora',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: widget.combo.playlistSuggestions.map((playlist) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _primaryRose.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: _primaryRose,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SafeText(
                                playlist,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Botão para Jogos e Atividades
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryRose.withOpacity(0.2), _secondaryGold.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _primaryRose.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.casino, color: _secondaryGold, size: 48),
                const SizedBox(height: 12),
                SafeText(
                  'Jogos & Atividades',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SafeText(
                  'Torne o encontro ainda mais divertido com jogos e perguntas especiais para casais',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DateNightGamesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Ver Jogos e Atividades'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryRose,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingListTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_cart, color: _primaryRose, size: 24),
                    const SizedBox(width: 12),
                    SafeText(
                      'Lista de Compras',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SafeText(
                  'Ingredientes necessários:',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: widget.combo.ingredients.map((ingredient) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _primaryRose,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SafeText(
                              ingredient,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Custo estimado
          AppCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _secondaryGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.attach_money,
                    color: _secondaryGold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      'Custo Estimado Total',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SafeText(
                      widget.combo.estimatedCost,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: _secondaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _primaryRose),
          const SizedBox(width: 8),
          SafeText(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SafeText(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchProvidersSection() {
    final streamingProviders = widget.combo.movieWatchProviders
        .where((p) => p['type'] == 'streaming')
        .toList();
    final rentProviders = widget.combo.movieWatchProviders
        .where((p) => p['type'] == 'rent')
        .toList();
    final buyProviders = widget.combo.movieWatchProviders
        .where((p) => p['type'] == 'buy')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (streamingProviders.isNotEmpty) ...[
          SafeText(
            'Streaming (Incluído na assinatura):',
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: streamingProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        
        if (rentProviders.isNotEmpty) ...[
          SafeText(
            'Aluguel:',
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: rentProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        
        if (buyProviders.isNotEmpty) ...[
          SafeText(
            'Compra:',
            style: AppTextStyles.bodyLarge.copyWith(
              color: _primaryRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: buyProviders.map((provider) {
              return _buildProviderCard(provider);
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return GestureDetector(
      onTap: () => _openProvider(provider),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _primaryRose.withValues(alpha: 0.1),
              _secondaryGold.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _primaryRose.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: provider['logoPath'] != null && provider['logoPath'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: OptimizedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w92${provider['logoPath']}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.play_circle_fill,
                      color: _primaryRose,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: SafeText(
                provider['name'] ?? 'Provedor',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProvider(Map<String, dynamic> provider) {
    // Implementar abertura do provedor
    // Por enquanto, vamos mostrar um snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SafeText(
          'Abrindo ${provider['name']} para assistir ${widget.combo.movieTitle}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryRose,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildToolsTab(bool isMobile) {
    // Extrair tempo de preparo em minutos
    int preparationMinutes = 45; // padrão
    try {
      final timeMatch = RegExp(r'(\d+)').firstMatch(widget.combo.preparationTime);
      if (timeMatch != null) {
        preparationMinutes = int.parse(timeMatch.group(1)!);
      }
    } catch (e) {
      // Usar padrão
    }

    // Criar cronograma do encontro
    final schedule = _createDateNightSchedule(preparationMinutes);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryRose, _secondaryGold],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.construction, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeText(
                        'Ferramentas do Date Night',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SafeText(
                        'Organize e prepare tudo para o encontro perfeito',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Timer de Cozinha
          SafeText(
            '⏱️ Timer de Cozinha',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SafeText(
            'Acompanhe o tempo de preparo da refeição',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          CookingTimerWidget(
            totalMinutes: preparationMinutes,
            onComplete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('⏰ Tempo de preparo concluído!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Checklist de Ingredientes
          SafeText(
            '✅ Checklist de Compras',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SafeText(
            'Marque os ingredientes conforme for comprando',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          IngredientsChecklistWidget(
            ingredients: widget.combo.ingredients,
          ),

          const SizedBox(height: 32),

          // Cronograma do Encontro
          SafeText(
            '📅 Cronograma do Encontro',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SafeText(
            'Sugestão de timeline para o date night perfeito',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          DateNightScheduleWidget(schedule: schedule),

          const SizedBox(height: 32),

          // Dicas Extras
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _secondaryGold.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.tips_and_updates, color: _secondaryGold),
                    const SizedBox(width: 12),
                    SafeText(
                      'Dicas Importantes',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTipItem('📱 Silencie os celulares para aproveitar o momento'),
                _buildTipItem('🎵 Prepare a playlist com antecedência'),
                _buildTipItem('🕯️ Teste velas e iluminação antes'),
                _buildTipItem('🍷 Deixe bebidas resfriando com 2h de antecedência'),
                _buildTipItem('🧹 Organize o ambiente com calma'),
                _buildTipItem('😊 O mais importante: relaxe e aproveite!'),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _secondaryGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SafeText(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _createDateNightSchedule(int cookingMinutes) {
    return [
      {
        'time': '2h antes',
        'icon': '🛒',
        'activity': 'Fazer compras',
        'tips': 'Verifique a lista de ingredientes e vá ao mercado',
      },
      {
        'time': '1h30 antes',
        'icon': '🧹',
        'activity': 'Preparar o ambiente',
        'tips': 'Arrume a mesa, organize a iluminação e prepare a decoração',
      },
      {
        'time': '1h antes',
        'icon': '👨‍🍳',
        'activity': 'Iniciar preparo da refeição',
        'tips': 'Comece pelos pratos que levam mais tempo',
      },
      {
        'time': '30min antes',
        'icon': '🎵',
        'activity': 'Música e últimos ajustes',
        'tips': 'Coloque a playlist e faça os toques finais',
      },
      {
        'time': 'Hora H',
        'icon': '💑',
        'activity': 'Receber seu par',
        'tips': 'Relaxe, sorria e aproveite!',
      },
      {
        'time': 'Início',
        'icon': '🍽️',
        'activity': 'Servir a refeição',
        'tips': 'Apresente os pratos com carinho',
      },
      {
        'time': 'Após jantar',
        'icon': '🎬',
        'activity': 'Assistir o filme',
        'tips': 'Aconcheguem-se e aproveitem o momento',
      },
      {
        'time': 'Final',
        'icon': '✨',
        'activity': 'Momento especial',
        'tips': 'Conversem sobre o que gostaram e criem memórias',
      },
    ];
  }
}

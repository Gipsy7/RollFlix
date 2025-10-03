import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/movie.dart';
import '../models/date_night_combo.dart';
import '../services/movie_service.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/optimized_widgets.dart';
import 'date_night_details_screen.dart';

class DateNightScreen extends StatefulWidget {
  const DateNightScreen({super.key});

  @override
  State<DateNightScreen> createState() => _DateNightScreenState();
}

class _DateNightScreenState extends State<DateNightScreen> with TickerProviderStateMixin {
  String? _selectedDateType;
  DateNightCombo? _currentCombo;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _heartController;
  late AnimationController _fadeController;
  late Animation<double> _heartAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animações
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Seleciona automaticamente o primeiro tipo
    final dateTypes = DateNightService.getAvailableDateTypes();
    if (dateTypes.isNotEmpty) {
      _selectedDateType = dateTypes.first;
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

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

  Future<void> _generateDateNight() async {
    if (_selectedDateType == null) {
      _showError('Selecione um tipo de encontro primeiro');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Buscar filmes românticos baseado no tipo selecionado
      List<Movie> movies = [];
      
      switch (_selectedDateType) {
        case 'Romance Clássico':
          movies = await MovieService.getMoviesByGenre('Romance');
          break;
        case 'Comédia Romântica':
          final comedyRomanceMovies = await MovieService.getMoviesByGenres([35, 10749]); // Comedy + Romance
          movies = comedyRomanceMovies ?? [];
          break;
        case 'Drama Romântico':
          final dramaRomanceMovies = await MovieService.getMoviesByGenres([18, 10749]); // Drama + Romance
          movies = dramaRomanceMovies ?? [];
          break;
        case 'Musical Romântico':
          final musicalRomanceMovies = await MovieService.getMoviesByGenres([10402, 10749]); // Music + Romance
          movies = musicalRomanceMovies ?? [];
          break;
        case 'Romance Aventureiro':
          final adventureRomanceMovies = await MovieService.getMoviesByGenres([12, 10749]); // Adventure + Romance
          movies = adventureRomanceMovies ?? [];
          break;
        default:
          movies = await MovieService.getMoviesByGenre('Romance');
      }

      if (movies.isNotEmpty) {
        // Filtrar filmes com boa avaliação para encontros românticos
        final goodMovies = movies.where((movie) => movie.voteAverage >= 6.0).toList();
        final selectedMovies = goodMovies.isNotEmpty ? goodMovies : movies;
        
        // Sortear um filme
        final randomMovie = selectedMovies[DateTime.now().millisecondsSinceEpoch % selectedMovies.length];
        
        // Criar combo de encontro
        final combo = DateNightCombo.fromMovie(
          movieId: randomMovie.id,
          title: randomMovie.title,
          year: randomMovie.releaseDate.isNotEmpty 
              ? randomMovie.releaseDate.split('-')[0] 
              : 'N/A',
          posterPath: randomMovie.posterPath,
          rating: randomMovie.voteAverage,
          overview: randomMovie.overview,
          mealType: DateNightService.getMovieTypeKey(_selectedDateType!),
        );

        setState(() {
          _currentCombo = combo;
        });

        // Animar aparição do resultado
        _fadeController.reset();
        await _fadeController.forward();
        _heartController.repeat(reverse: true);

        // Parar animação do coração após 3 segundos
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _heartController.stop();
        });

      } else {
        _showError('Nenhum filme encontrado para este tipo de encontro');
      }
    } catch (e) {
      _showError('Erro ao gerar encontro: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewComboDetails() {
    if (_currentCombo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DateNightDetailsScreen(combo: _currentCombo!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: _romanticGradient.scale(0.1),
        ),
        child: CustomScrollView(
          slivers: [
            _buildHeader(isMobile),
            _buildContent(isMobile),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: SafeText(
        'Date Night',
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: _romanticGradient,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: BoxDecoration(
          gradient: _romanticGradient.scale(0.3),
        ),
        child: Column(
          children: [
            // Ícone principal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _romanticGradient.scale(0.8),
                boxShadow: [
                  BoxShadow(
                    color: _primaryRose.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Título e descrição
            SafeText(
              'Encontro Perfeito',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 28 : 36,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
              child: SafeText(
                'Filme romântico + refeição especial = noite inesquecível 💕',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  fontSize: isMobile ? 14 : 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateTypeSelection(isMobile),
            const SizedBox(height: 32),
            _buildGenerateButton(isMobile),
            const SizedBox(height: 32),
            if (_currentCombo != null) _buildComboResult(isMobile),
            if (_errorMessage != null) _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTypeSelection(bool isMobile) {
    final dateTypes = DateNightService.getAvailableDateTypes();
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: _primaryRose,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              SafeText(
                'Escolha o Estilo do Encontro',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Grid de tipos de encontro
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              double childAspectRatio;
              
              if (constraints.maxWidth < 600) {
                // Mobile: 1 coluna
                crossAxisCount = 1;
                childAspectRatio = 3.2; // Mais altura para mobile
              } else if (constraints.maxWidth < 900) {
                // Tablet: 2 colunas
                crossAxisCount = 2;
                childAspectRatio = 2.2; // Mais altura para tablet
              } else {
                // Desktop: 3 colunas
                crossAxisCount = 3;
                childAspectRatio = 1.8; // Mais altura para desktop
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: dateTypes.length,
                itemBuilder: (context, index) {
                  final dateType = dateTypes[index];
                  final isSelected = _selectedDateType == dateType;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateType = dateType;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? _romanticGradient.scale(0.8)
                            : LinearGradient(
                                colors: [
                                  AppColors.surfaceDark.withValues(alpha: 0.95),
                                  AppColors.backgroundDark.withValues(alpha: 0.9),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? _primaryRose
                              : AppColors.textSecondary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: _primaryRose.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Icon(
                              _getIconForDateType(dateType),
                              color: isSelected 
                                ? Colors.white 
                                : Colors.white.withValues(alpha: 0.9),
                              size: isMobile ? 24 : 28,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: SafeText(
                                dateType,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected 
                                      ? Colors.white 
                                      : Colors.white.withValues(alpha: 0.95),
                                  fontWeight: FontWeight.w600,
                                  fontSize: isMobile ? 12 : 14,
                                  shadows: isSelected 
                                    ? [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.7),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForDateType(String dateType) {
    switch (dateType) {
      case 'Romance Clássico':
        return Icons.local_florist;
      case 'Comédia Romântica':
        return Icons.emoji_emotions;
      case 'Drama Romântico':
        return Icons.theater_comedy;
      case 'Musical Romântico':
        return Icons.music_note;
      case 'Romance Aventureiro':
        return Icons.explore;
      default:
        return Icons.favorite;
    }
  }

  Widget _buildGenerateButton(bool isMobile) {
    return AppButton(
      onPressed: _selectedDateType != null && !_isLoading ? _generateDateNight : null,
      text: _isLoading ? 'Preparando...' : '💕 Criar Encontro Perfeito',
      isLoading: _isLoading,
      icon: _isLoading ? null : Icons.auto_awesome,
      backgroundColor: _primaryRose,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 16 : 20,
        horizontal: 24,
      ),
    );
  }

  Widget _buildComboResult(bool isMobile) {
    final combo = _currentCombo!;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AppCard(
        child: Column(
          children: [
            // Header do resultado
            Row(
              children: [
                AnimatedBuilder(
                  animation: _heartAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _primaryRose.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: _primaryRose,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SafeText(
                    'Seu Encontro Perfeito',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Filme + Refeição
            isMobile 
              ? Column(
                  children: [
                    // Poster do filme em mobile
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: _romanticGradient.scale(0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: combo.moviePosterPath.isNotEmpty
                            ? OptimizedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w500${combo.moviePosterPath}',
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
                    const SizedBox(height: 16),
                    
                    // Título do filme
                    SafeText(
                      combo.movieTitle,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: _secondaryGold,
                        ),
                        const SizedBox(width: 4),
                        SafeText(
                          '${combo.movieRating.toStringAsFixed(1)}/10',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Informações da refeição em mobile
                    Column(
                      children: [
                        _buildMealInfoItem(
                          Icons.restaurant_menu,
                          'Prato Principal',
                          combo.mainDish,
                        ),
                        const SizedBox(height: 12),
                        _buildMealInfoItem(
                          Icons.local_bar,
                          'Bebida',
                          combo.drink,
                        ),
                        const SizedBox(height: 12),
                        _buildMealInfoItem(
                          Icons.cake,
                          'Sobremesa',
                          combo.dessert,
                        ),
                        const SizedBox(height: 12),
                        _buildMealInfoItem(
                          Icons.access_time,
                          'Tempo de Preparo',
                          combo.preparationTime,
                        ),
                        const SizedBox(height: 12),
                        _buildMealInfoItem(
                          Icons.attach_money,
                          'Custo Estimado',
                          combo.estimatedCost,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster do filme
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        height: isMobile ? 180 : 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: _romanticGradient.scale(0.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: combo.moviePosterPath.isNotEmpty
                              ? OptimizedNetworkImage(
                                  imageUrl: 'https://image.tmdb.org/t/p/w500${combo.moviePosterPath}',
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
                      const SizedBox(height: 12),
                      SafeText(
                        combo.movieTitle,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: _secondaryGold,
                          ),
                          const SizedBox(width: 4),
                          SafeText(
                            '${combo.movieRating.toStringAsFixed(1)}/10',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Informações da refeição
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMealInfoItem(
                        Icons.restaurant_menu,
                        'Prato Principal',
                        combo.mainDish,
                      ),
                      const SizedBox(height: 12),
                      _buildMealInfoItem(
                        Icons.local_bar,
                        'Bebida',
                        combo.drink,
                      ),
                      const SizedBox(height: 12),
                      _buildMealInfoItem(
                        Icons.cake,
                        'Sobremesa',
                        combo.dessert,
                      ),
                      const SizedBox(height: 12),
                      _buildMealInfoItem(
                        Icons.access_time,
                        'Tempo de Preparo',
                        combo.preparationTime,
                      ),
                      const SizedBox(height: 12),
                      _buildMealInfoItem(
                        Icons.attach_money,
                        'Custo Estimado',
                        combo.estimatedCost,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Botão para ver detalhes
            AppButton(
              onPressed: _viewComboDetails,
              text: 'Ver Todos os Detalhes',
              icon: Icons.restaurant,
              backgroundColor: _secondaryGold,
              textColor: AppColors.backgroundDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealInfoItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _primaryRose.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: _primaryRose,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeText(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                SafeText(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
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
              _errorMessage!,
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
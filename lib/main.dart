import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart' as AppUtils;
import 'models/movie.dart';
import 'models/tv_show.dart';
import 'services/movie_service.dart';
import 'screens/movie_details_screen.dart';
import 'screens/tv_show_details_screen.dart';
import 'screens/search_screen.dart';
import 'screens/tv_series_search_screen.dart';
import 'screens/date_night_screen.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/common_widgets.dart';
import 'widgets/error_widgets.dart';
import 'widgets/optimized_widgets.dart';
import 'widgets/responsive_widgets.dart';
import 'controllers/movie_controller.dart';
import 'repositories/tv_show_repository.dart';
import 'mixins/animation_mixin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkCinemaTheme,
      home: const MovieSorterApp(),
    );
  }
}

class MovieSorterApp extends StatefulWidget {
  const MovieSorterApp({super.key});

  @override
  State<MovieSorterApp> createState() => _MovieSorterAppState();
}

class _MovieSorterAppState extends State<MovieSorterApp> with TickerProviderStateMixin, AnimationMixin {
  late final MovieController _movieController;
  late final TVShowRepository _tvShowRepository;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Variáveis para controle do toggle filme/série
  bool _isSeriesMode = false;
  
  // Filme ou série selecionada
  Movie? _selectedMovie;
  TVShow? _selectedTVShow;
  
  // Status de carregamento
  bool _isLoading = false;
  String? _errorMessage;

  // Gêneros dinâmicos baseados no modo
  List<String> get currentGenres => _isSeriesMode 
      ? MovieService.getTVGenres() 
      : AppConstants.movieGenres;
  
  String? _selectedGenre;

  final List<String> genres = AppConstants.movieGenres;

  @override
  void initState() {
    super.initState();
    _movieController = MovieController();
    _tvShowRepository = TVShowRepository();
    _movieController.addListener(_onMovieStateChanged);
    
    // Pré-carrega dados populares para melhor performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Limpa o cache para garantir busca de múltiplos filmes
      _movieController.clearCache();
      _tvShowRepository.clearCache();
      
      _movieController.preloadData();
      _tvShowRepository.preloadPopularGenres();
      
      // Seleciona automaticamente o primeiro gênero do modo atual
      if (currentGenres.isNotEmpty) {
        _selectedGenre = currentGenres.first;
        if (!_isSeriesMode) {
          _movieController.selectGenre(currentGenres.first);
        }
        debugPrint('Gênero inicial selecionado automaticamente: ${currentGenres.first}');
      }
    });
  }

  @override
  void dispose() {
    _movieController.removeListener(_onMovieStateChanged);
    _movieController.dispose();
    _tvShowRepository.cleanExpiredCache();
    super.dispose();
  }

  /// Listener otimizado para mudanças de estado
  void _onMovieStateChanged() {
    if (_movieController.hasMovie) {
      animateMovieCard();
    }
    
    if (_movieController.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showError(context, _movieController.errorMessage!);
        _movieController.clearError();
      });
    }
  }

  /// Método para alternar entre filmes e séries
  void _toggleContentMode() {
    setState(() {
      _isSeriesMode = !_isSeriesMode;
      _selectedMovie = null;
      _selectedTVShow = null;
      _selectedGenre = null;
      _errorMessage = null;
    });
    
    // Auto-seleciona o primeiro gênero do novo modo
    if (currentGenres.isNotEmpty) {
      _selectedGenre = currentGenres.first;
    }
  }

  /// Método unificado para sortear filmes ou séries
  Future<void> _handleRollContent() async {
    if (_selectedGenre == null) {
      AppSnackBar.showInfo(context, 'Selecione um gênero primeiro');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isSeriesMode) {
        // Usa o repository para séries com histórico anti-repetição
        final currentShowId = _selectedTVShow?.id;
        final newShow = await _tvShowRepository.getRandomTVShowByGenre(
          _selectedGenre!,
          excludeShowId: currentShowId,
        );
        
        setState(() {
          _selectedTVShow = newShow;
          _selectedMovie = null;
        });
        animateMovieCard();
      } else {
        // Usa o método existente do controller para filmes
        if (_movieController.canRollMovie || _selectedGenre != _movieController.selectedGenre) {
          _movieController.selectGenre(_selectedGenre!);
          await _movieController.rollMovie();
          setState(() {
            _selectedMovie = _movieController.selectedMovie;
            _selectedTVShow = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar ${_isSeriesMode ? 'série' : 'filme'}: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Obtém as cores baseadas no modo atual
  LinearGradient get currentGradient => _isSeriesMode 
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0), // Roxo médio
            Color.fromARGB(255, 45, 3, 56), // Roxo vibrante
            Color.fromARGB(255, 255, 0, 128), // Roxo claro
          ],
        )
      : AppColors.cinemaGradient; // Amarelo/dourado padrão

  Color get currentAccentColor => _isSeriesMode 
      ? const Color.fromARGB(255, 240, 43, 109) // Roxo vibrante
      : AppColors.primary; // Dourado original

  String get currentContentType => _isSeriesMode ? 'Série' : 'Filme';
  String get currentModeLabel => _isSeriesMode ? 'Séries' : 'Filmes';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, isMobile),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 32, 31, 31).withValues(alpha: 0.95),
              const Color.fromARGB(255, 29, 26, 26).withValues(alpha: 0.98),
              const Color.fromARGB(211, 30, 31, 29),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: ListenableBuilder(
          listenable: _movieController,
          builder: (context, _) => CustomScrollView(
            slivers: [
              _buildAppBar(isMobile),
              _buildContent(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 200 : 250,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: AppColors.textPrimary,
            size: 28,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: currentGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: _buildHeader(isMobile),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isMobile) {
    return Drawer(
      backgroundColor: AppColors.backgroundDark,
      child: Column(
        children: [
          // Header do Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: currentGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_movies,
                      color: AppColors.textPrimary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    SafeText(
                      'RollFlix',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SafeText(
                  'Roll and chill',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Início',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.search,
                  title: 'Pesquisar Filmes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.tv,
                  title: 'Pesquisar Séries',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TVSeriesSearchScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  title: 'Date Night',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DateNightScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.refresh,
                  title: 'Limpar Cache',
                  onTap: () {
                    _movieController.clearCache();
                    Navigator.pop(context);
                    AppSnackBar.showSuccess(context, 'Cache limpo com sucesso!');
                  },
                ),
                const Divider(color: AppColors.textSecondary),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: 'Sobre o App',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Configurações',
                  onTap: () {
                    Navigator.pop(context);
                    AppSnackBar.showInfo(context, 'Em breve: Configurações');
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeText(
              'Versão ${AppConstants.appVersion}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24,
      ),
      title: SafeText(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      splashColor: AppColors.primary.withAlpha(1),
      hoverColor: AppColors.primary.withAlpha(05),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        title: SafeText(
          'Sobre o RollFlix',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeText(
              'Aplicativo para descobrir filmes aleatórios por gênero.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SafeText(
              'Desenvolvido com Flutter',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              'Dados fornecidos por The Movie Database (TMDb)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: SafeText(
              'Fechar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildLogo(isMobile),
            const SizedBox(width: 20),
            Expanded(child: _buildTitleSection(isMobile)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo(bool isMobile) {
    return Container(
      width: isMobile ? 60 : 70,
      height: isMobile ? 60 : 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.local_movies,
        color: AppColors.textPrimary,
        size: isMobile ? 40 : 48,
      ),
    );
  }

  Widget _buildTitleSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeText(
          AppConstants.appName,
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: isMobile ? 28 : 36,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              
            ],
          ),
        ),
        const SizedBox(height: 8),
        SafeText(
          'Roll and Chill • $currentModeLabel',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            fontSize: isMobile ? 14 : 16,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGenreSelection(isMobile),
            const SizedBox(height: 24),
            _buildActionButtons(isMobile),
            const SizedBox(height: 24),
            if (_selectedMovie != null || _selectedTVShow != null) 
              _buildContentCard(context, isMobile),
            if (_errorMessage != null) _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreSelection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGenreHeader(isMobile),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              height: isMobile ? 400 : 450,
              child: GenreWheel(
                genres: currentGenres,
                selectedGenre: _selectedGenre,
                onGenreSelected: (genre) {
                  setState(() {
                    _selectedGenre = genre;
                  });
                },
                onRandomSpin: () {},
                accentColor: _isSeriesMode ? currentAccentColor : null,
                onToggleMode: _toggleContentMode,
                isSeriesMode: _isSeriesMode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreHeader(bool isMobile) {
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
            color: currentAccentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: SafeText(
            'Escolha um Gênero de $currentContentType',
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

  Widget _buildActionButtons(bool isMobile) {
    return AppButton(
      onPressed: _selectedGenre != null && !_isLoading ? _handleRollContent : null,
      text: _isLoading 
          ? 'Rolando...' 
          : (_selectedMovie != null || _selectedTVShow != null 
              ? 'Rolar Nov${_isSeriesMode ? 'a Série' : 'o Filme'}' 
              : 'Rolar ${_isSeriesMode ? 'Série' : 'Filme'}'),
      isLoading: _isLoading,
      icon: _isLoading ? null : (_isSeriesMode ? Icons.tv : Icons.local_movies),
      backgroundColor: currentAccentColor,
    );
  }

  Widget _buildErrorMessage() {
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

  Widget _buildContentCard(BuildContext context, bool isMobile) {
    if (_isSeriesMode && _selectedTVShow != null) {
      return _buildTVShowCard(context, isMobile);
    } else if (!_isSeriesMode && _selectedMovie != null) {
      return _buildMovieCard(context, isMobile);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTVShowCard(BuildContext context, bool isMobile) {
    final tvShow = _selectedTVShow!;
    
    return OptimizedAnimatedBuilder(
      animation: movieCardAnimation,
      builder: (context, animationValue) {
        return Transform.scale(
          scale: animationValue,
          child: AppCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TVShowDetailsScreen(tvShow: tvShow),
                ),
              );
            },
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTVShowPoster(tvShow, isMobile),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTVShowDetails(tvShow, isMobile),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieCard(BuildContext context, bool isMobile) {
    final movie = _selectedMovie!;
    
    return OptimizedAnimatedBuilder(
      animation: movieCardAnimation,
      builder: (context, animationValue) {
        return Transform.scale(
          scale: animationValue,
          child: AppCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMoviePoster(movie, isMobile),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildMovieDetails(movie, isMobile),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoviePoster(Movie movie, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.glassGradient,
        border: Border.all(
          color: AppColors.interactive.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: OptimizedNetworkImage(
        imageUrl: movie.posterPath.isNotEmpty 
            ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
            : '',
        width: isMobile ? 100 : 120,
        height: isMobile ? 150 : 180,
        borderRadius: BorderRadius.circular(14),
        errorWidget: _buildPosterFallback(),
        placeholder: Container(
          width: isMobile ? 100 : 120,
          height: isMobile ? 150 : 180,
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const OptimizedLoadingIndicator(size: 24),
        ),
      ),
    );
  }

  Widget _buildPosterFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Icon(
        Icons.movie,
        color: AppColors.backgroundDark,
        size: 48,
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMovieTitle(movie, isMobile),
        const SizedBox(height: 12),
        if (movie.releaseDate.isNotEmpty) ...[
          _buildMovieDate(movie),
          const SizedBox(height: 12),
        ],
        _buildMovieRating(movie),
        const SizedBox(height: 16),
        if (movie.overview.isNotEmpty) ...[
          _buildMovieOverview(movie, isMobile),
          const SizedBox(height: 16),
        ],
        _buildMovieCounter(),
        const SizedBox(height: 8),
        _buildDetailsHint(),
      ],
    );
  }

  Widget _buildMovieTitle(Movie movie, bool isMobile) {
    return SafeText(
      movie.title,
      style: (isMobile 
          ? AppTextStyles.headlineSmall
          : AppTextStyles.headlineMedium).copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMovieDate(Movie movie) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.calendar_today,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SafeText(
            AppUtils.DateUtils.formatReleaseDate(movie.releaseDate),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieRating(Movie movie) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.star,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SafeText(
            '${movie.voteAverage.toStringAsFixed(1)}/10',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieOverview(Movie movie, bool isMobile) {
    return SafeText(
      movie.overview,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      maxLines: isMobile ? 3 : 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMovieCounter() {
    if (_movieController.movieCount <= 1) return const SizedBox.shrink();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.movie_filter,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        SafeText(
          'Filme ${_movieController.movieCount} sorteado',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            size: 16,
            color: AppColors.backgroundDark,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Se há pouco espaço (menos de 120px) ou é mobile, usar texto curto
                final isMobile = ResponsiveUtils.isMobile(context);
                final useShortText = constraints.maxWidth < 120 || isMobile;
                return SafeText(
                  useShortText ? 'Toque para detalhes' : 'Toque para mais detalhes',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Métodos para TVShow (seguindo o mesmo padrão dos métodos de Movie)

  Widget _buildTVShowPoster(TVShow tvShow, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.glassGradient,
        border: Border.all(
          color: currentAccentColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: OptimizedNetworkImage(
        imageUrl: tvShow.posterPath.isNotEmpty 
            ? 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}'
            : '',
        width: isMobile ? 100 : 120,
        height: isMobile ? 150 : 180,
        borderRadius: BorderRadius.circular(14),
        errorWidget: _buildTVShowPosterFallback(),
        placeholder: Container(
          width: isMobile ? 100 : 120,
          height: isMobile ? 150 : 180,
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const OptimizedLoadingIndicator(size: 24),
        ),
      ),
    );
  }

  Widget _buildTVShowPosterFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: currentGradient,
      ),
      child: Icon(
        Icons.tv,
        color: AppColors.backgroundDark,
        size: 48,
      ),
    );
  }

  Widget _buildTVShowDetails(TVShow tvShow, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTVShowTitle(tvShow, isMobile),
        const SizedBox(height: 12),
        if (tvShow.firstAirDate.isNotEmpty) ...[
          _buildTVShowDate(tvShow),
          const SizedBox(height: 12),
        ],
        _buildTVShowRating(tvShow),
        const SizedBox(height: 16),
        if (tvShow.overview.isNotEmpty) ...[
          _buildTVShowOverview(tvShow, isMobile),
          const SizedBox(height: 16),
        ],
        _buildTVShowCounter(),
        const SizedBox(height: 8),
        _buildTVShowDetailsHint(),
      ],
    );
  }

  Widget _buildTVShowTitle(TVShow tvShow, bool isMobile) {
    return SafeText(
      tvShow.name,
      style: (isMobile 
          ? AppTextStyles.headlineSmall
          : AppTextStyles.headlineMedium).copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTVShowDate(TVShow tvShow) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.calendar_today,
            size: 16,
            color: currentAccentColor,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SafeText(
            tvShow.year.isNotEmpty ? tvShow.year : 'Data não disponível',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTVShowRating(TVShow tvShow) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Icon(
            Icons.star,
            size: 16,
            color: currentAccentColor,
          ),
        ),
        const SizedBox(width: 8),
        SafeText(
          '${tvShow.voteAverage.toStringAsFixed(1)}/10',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTVShowOverview(TVShow tvShow, bool isMobile) {
    return SafeText(
      tvShow.overview,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      maxLines: isMobile ? 4 : 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTVShowCounter() {
    // Contador dinâmico baseado no número de séries sorteadas
    // Por enquanto, vamos usar um contador simples
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.tv,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        SafeText(
          'Série sorteada',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTVShowDetailsHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: currentAccentColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            size: 16,
            color: AppColors.backgroundDark,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Se há pouco espaço (menos de 120px) ou é mobile, usar texto curto
                final isMobile = ResponsiveUtils.isMobile(context);
                final useShortText = constraints.maxWidth < 120 || isMobile;
                return SafeText(
                  useShortText ? 'Toque para detalhes' : 'Toque para mais detalhes',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

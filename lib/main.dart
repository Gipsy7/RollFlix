import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart' as AppUtils;
import 'models/movie.dart';
import 'screens/movie_details_screen.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/common_widgets.dart';
import 'widgets/error_widgets.dart';
import 'widgets/optimized_widgets.dart';
import 'widgets/responsive_widgets.dart';
import 'controllers/movie_controller.dart';
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

  final List<String> genres = AppConstants.movieGenres;

  @override
  void initState() {
    super.initState();
    _movieController = MovieController();
    _movieController.addListener(_onMovieStateChanged);
    
    // Pré-carrega dados populares para melhor performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Limpa o cache para garantir busca de múltiplos filmes
      _movieController.clearCache();
      
      _movieController.preloadData();
      
      // Seleciona automaticamente o primeiro gênero ("Ação") para permitir rolar filme imediatamente
      if (genres.isNotEmpty) {
        _movieController.selectGenre(genres.first);
        debugPrint('Gênero inicial selecionado automaticamente: ${genres.first}');
      }
    });
  }

  @override
  void dispose() {
    _movieController.removeListener(_onMovieStateChanged);
    _movieController.dispose();
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

  /// Método simplificado para sortear filme
  Future<void> _handleRollMovie() async {
    if (!_movieController.canRollMovie) {
      // Como o gênero já é selecionado automaticamente, este caso não deveria ocorrer
      AppSnackBar.showInfo(context, 'Aguarde, carregando gêneros...');
      return;
    }

    debugPrint('=== INICIANDO SORTEIO ===');
    debugPrint('Gênero atual: ${_movieController.selectedGenre}');
    debugPrint('Filme atual: ${_movieController.selectedMovie?.title ?? "nenhum"}');
    debugPrint('Contador atual: ${_movieController.movieCount}');
    
    await _movieController.rollMovie();
    
    // Feedback de sucesso
    if (_movieController.selectedMovie != null) {
      debugPrint('=== SORTEIO CONCLUÍDO ===');
      debugPrint('Novo filme: ${_movieController.selectedMovie!.title}');
      debugPrint('Novo contador: ${_movieController.movieCount}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundDark.withOpacity(0.95),
              AppColors.backgroundDark.withOpacity(0.98),
              AppColors.backgroundDark,
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
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.cinemaGradient,
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
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          'assets/images/rollflix_logo.svg',
          fit: BoxFit.contain,
          placeholderBuilder: (context) {
            return Icon(
              Icons.movie_filter,
              color: AppColors.backgroundDark,
              size: 32,
            );
          },
        ),
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
                color: AppColors.backgroundDark.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SafeText(
          'Roll and Chill',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: AppColors.backgroundDark.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
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
            _buildActionButton(),
            const SizedBox(height: 24),
            if (_movieController.hasMovie) _buildMovieCard(context, isMobile),
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
                genres: genres,
                selectedGenre: _movieController.selectedGenre,
                onGenreSelected: _movieController.selectGenre,
                onRandomSpin: () {},
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
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: SafeText(
            'Escolha um Gênero',
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

  Widget _buildActionButton() {
    return AppButton(
      onPressed: _movieController.canRollMovie ? _handleRollMovie : null,
      text: _movieController.isLoading 
          ? 'Rolando...' 
          : (_movieController.hasMovie ? 'Rolar Novo Filme' : 'Rolar Filme'),
      isLoading: _movieController.isLoading,
      icon: _movieController.isLoading ? null : Icons.local_movies,
    );
  }  Widget _buildMovieCard(BuildContext context, bool isMobile) {
    final movie = _movieController.selectedMovie!;
    
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
          color: AppColors.interactive.withOpacity(0.3),
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
}

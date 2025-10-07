import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'models/movie.dart';
import 'models/tv_show.dart';
import 'services/movie_service.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/common_widgets.dart';
import 'widgets/error_widgets.dart';
import 'widgets/responsive_widgets.dart';
import 'widgets/app_drawer.dart';
import 'widgets/content_widgets.dart';
import 'controllers/movie_controller.dart';
import 'controllers/tv_show_controller.dart';
import 'controllers/app_mode_controller.dart';
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
  late final TVShowController _tvShowController;
  late final TVShowRepository _tvShowRepository;
  late final AppModeController _appModeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Flag para controlar quando a animação deve disparar
  bool _shouldAnimateCard = false;

  // Getters para acessar estado dos controllers
  Movie? get _selectedMovie => _movieController.selectedMovie;
  TVShow? get _selectedTVShow => _tvShowController.selectedShow;
  bool get _isLoading => _appModeController.isSeriesMode 
      ? _tvShowController.isLoading 
      : _movieController.isLoading;
  String? get _errorMessage => _appModeController.isSeriesMode
      ? _tvShowController.errorMessage
      : _movieController.errorMessage;

  // Gêneros dinâmicos baseados no modo
  List<String> get currentGenres => _appModeController.isSeriesMode 
      ? MovieService.getTVGenres() 
      : AppConstants.movieGenres;

  @override
  void initState() {
    super.initState();
    _movieController = MovieController.instance;
    _tvShowController = TVShowController.instance;
    _tvShowRepository = TVShowRepository();
    _appModeController = AppModeController.instance;
    
    _setupListeners();
    _initializeApp();
  }
  
  /// Configura listeners de forma segura
  void _setupListeners() {
    // Listeners removidos - usando ListenableBuilder no build()
    // que escuta _movieController, _tvShowController e _appModeController
  }
  
  /// Inicialização assíncrona da aplicação
  void _initializeApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      
      try {
        // Pré-carrega dados populares para melhor performance
        await Future.wait([
          _movieController.preloadData(),
          _tvShowController.preloadData(),
        ]);
        
        // Seleciona automaticamente o primeiro gênero do modo atual
        if (mounted && currentGenres.isNotEmpty) {
          _appModeController.selectGenre(currentGenres.first);
          if (!_appModeController.isSeriesMode) {
            _movieController.selectGenre(currentGenres.first);
          } else {
            _tvShowController.selectGenre(currentGenres.first);
          }
          debugPrint('Gênero inicial selecionado: ${currentGenres.first}');
        }
      } catch (e) {
        debugPrint('Erro ao inicializar app: $e');
        if (mounted) {
          AppSnackBar.showError(context, 'Erro ao carregar dados iniciais');
        }
      }
    });
  }

  @override
  void dispose() {
    // Não precisamos remover listeners pois usamos ListenableBuilder
    _movieController.dispose();
    _tvShowController.dispose();
    _tvShowRepository.cleanExpiredCache();
    super.dispose();
  }

  /// Método para alternar entre filmes e séries
  void _toggleContentMode() {
    _appModeController.toggleMode();
    
    // Reseta a flag ao trocar de modo para evitar animação automática
    setState(() {
      _shouldAnimateCard = false;
    });
    
    // Auto-seleciona o primeiro gênero do novo modo
    if (currentGenres.isNotEmpty) {
      _appModeController.selectGenre(currentGenres.first);
    }
  }

  /// Método unificado para sortear filmes ou séries
  Future<void> _handleRollContent() async {
    debugPrint('=== HANDLE ROLL CONTENT ===');
    final selectedGenre = _appModeController.selectedGenre;
    debugPrint('selectedGenre: $selectedGenre');
    debugPrint('isSeriesMode: ${_appModeController.isSeriesMode}');
    
    if (selectedGenre == null) {
      AppSnackBar.showInfo(context, 'Selecione um gênero primeiro');
      return;
    }

    // Ativa a flag para permitir animação após o sorteio
    setState(() {
      _shouldAnimateCard = true;
    });

    try {
      if (_appModeController.isSeriesMode) {
        debugPrint('Chamando rollShow para série...');
        // Usa o controller para séries
        if (_tvShowController.canRollShow || selectedGenre != _tvShowController.selectedGenre) {
          _tvShowController.selectGenre(selectedGenre);
          await _tvShowController.rollShow();
          debugPrint('rollShow concluído. selectedShow: ${_tvShowController.selectedShow?.name}');
        }
      } else {
        debugPrint('Chamando rollMovie para filme...');
        // Usa o controller para filmes
        if (_movieController.canRollMovie || selectedGenre != _movieController.selectedGenre) {
          _movieController.selectGenre(selectedGenre);
          await _movieController.rollMovie();
          debugPrint('rollMovie concluído. selectedMovie: ${_movieController.selectedMovie?.title}');
        }
      }
    } catch (e) {
      debugPrint('Erro em _handleRollContent: $e');
    }
  }

  /// Obtém as cores baseadas no modo atual
  LinearGradient get currentGradient => _appModeController.isSeriesMode 
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

  Color get currentAccentColor => _appModeController.isSeriesMode 
      ? const Color.fromARGB(255, 240, 43, 109) // Roxo vibrante
      : AppColors.primary; // Dourado original

  String get currentContentType => _appModeController.isSeriesMode ? 'Série' : 'Filme';
  String get currentModeLabel => _appModeController.isSeriesMode ? 'Séries' : 'Filmes';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return ListenableBuilder(
      listenable: Listenable.merge([
        _movieController,
        _tvShowController,
        _appModeController,
      ]),
      builder: (context, _) {
        // Verifica se precisa selecionar um gênero quando não há nenhum selecionado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          
          // Se não há gênero selecionado mas há gêneros disponíveis, seleciona o primeiro
          if (_appModeController.selectedGenre == null && currentGenres.isNotEmpty) {
            _appModeController.selectGenre(currentGenres.first);
            if (_appModeController.isSeriesMode) {
              _tvShowController.selectGenre(currentGenres.first);
            } else {
              _movieController.selectGenre(currentGenres.first);
            }
          }
          
          // Anima o card quando há um novo filme/série E a flag está ativa
          if (_appModeController.isSeriesMode) {
            if (_tvShowController.hasShow && _shouldAnimateCard) {
              animateMovieCard();
              // Reseta a flag após animar
              setState(() {
                _shouldAnimateCard = false;
              });
            }
            if (_tvShowController.errorMessage != null) {
              AppSnackBar.showError(context, _tvShowController.errorMessage!);
              _tvShowController.clearError();
            }
          } else {
            if (_movieController.hasMovie && _shouldAnimateCard) {
              animateMovieCard();
              // Reseta a flag após animar
              setState(() {
                _shouldAnimateCard = false;
              });
            }
            if (_movieController.errorMessage != null) {
              AppSnackBar.showError(context, _movieController.errorMessage!);
              _movieController.clearError();
            }
          }
        });
        
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
            child: CustomScrollView(
              slivers: [
                _buildAppBar(isMobile),
                _buildContent(isMobile),
              ],
            ),
          ),
        );
      },
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
      actions: [
        _buildSwapButton(isMobile),
        SizedBox(width: isMobile ? 8 : 16),
      ],
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

  Widget _buildSwapButton(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: _appModeController.isSeriesMode 
            ? LinearGradient(
                colors: [
                  const Color.fromARGB(255, 147, 51, 234).withValues(alpha: 0.8),
                  const Color.fromARGB(255, 219, 39, 119).withValues(alpha: 0.8),
                ],
              )
            : LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.8),
                  const Color(0xFFD4AF37).withValues(alpha: 0.8),
                ],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: currentAccentColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleContentMode,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _appModeController.isSeriesMode ? Icons.tv : Icons.movie_filter,
                  color: AppColors.textPrimary,
                  size: isMobile ? 20 : 24,
                ),
                SizedBox(width: isMobile ? 6 : 8),
                if (!isMobile) ...[
                  Text(
                    _appModeController.isSeriesMode ? 'Séries' : 'Filmes',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isMobile) {
    return AppDrawer(
      appModeController: _appModeController,
      movieController: _movieController,
      currentGradient: currentGradient,
      isMobile: isMobile,
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
    final horizontalPadding = isMobile ? 20.0 : 32.0;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // GenreSelection SEM padding para ocupar 100% da largura
          _buildGenreSelection(isMobile),
          
          // Outros elementos COM padding
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                _buildActionButtons(isMobile),
                const SizedBox(height: 24),
                if (_selectedMovie != null || _selectedTVShow != null) 
                  _buildContentCard(context, isMobile),
                if (_errorMessage != null) _buildErrorMessage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSelection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Espaçamento superior
        SizedBox(height: isMobile ? 24 : 32),
        
        // Header com padding apenas nas laterais
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32),
          child: _buildGenreHeader(isMobile),
        ),
        
        const SizedBox(height: 32),
        
        // GenreWheel SEM qualquer padding - ocupa 100% da largura
        SizedBox(
          height: isMobile ? 400 : 450,
          width: double.infinity,
          child: GenreWheel(
            genres: currentGenres,
            selectedGenre: _appModeController.selectedGenre,
            onGenreSelected: (genre) {
              _appModeController.selectGenre(genre);
            },
            onRandomSpin: () {},
            accentColor: _appModeController.isSeriesMode ? currentAccentColor : null,
            isSeriesMode: _appModeController.isSeriesMode,
          ),
        ),
        
        // Espaçamento inferior
        SizedBox(height: isMobile ? 24 : 32),
      ],
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
      onPressed: _appModeController.selectedGenre != null && !_isLoading ? _handleRollContent : null,
      text: _isLoading 
          ? 'Rolando...' 
          : (_selectedMovie != null || _selectedTVShow != null 
              ? 'Rolar Nov${_appModeController.isSeriesMode ? 'a Série' : 'o Filme'}' 
              : 'Rolar ${_appModeController.isSeriesMode ? 'Série' : 'Filme'}'),
      isLoading: _isLoading,
      icon: _isLoading ? null : (_appModeController.isSeriesMode ? Icons.tv : Icons.local_movies),
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
    debugPrint('=== BUILD CONTENT CARD ===');
    debugPrint('isSeriesMode: ${_appModeController.isSeriesMode}');
    debugPrint('_selectedMovie: $_selectedMovie');
    debugPrint('_selectedTVShow: $_selectedTVShow');
    debugPrint('movieController.selectedMovie: ${_movieController.selectedMovie?.title}');
    debugPrint('tvShowController.selectedShow: ${_tvShowController.selectedShow?.name}');
    
    return Column(
      children: [
        // Contador unificado
        ContentCounter(
          count: _appModeController.isSeriesMode 
              ? _tvShowController.showCount 
              : _movieController.movieCount,
          isSeriesMode: _appModeController.isSeriesMode,
        ),
        const SizedBox(height: 12),
        // Card do filme ou série
        if (_appModeController.isSeriesMode && _selectedTVShow != null)
          ContentCard(
            tvShow: _selectedTVShow,
            animation: movieCardAnimation,
            currentGradient: currentGradient,
            accentColor: currentAccentColor,
            isMobile: isMobile,
          )
        else if (!_appModeController.isSeriesMode && _selectedMovie != null)
          ContentCard(
            movie: _selectedMovie,
            animation: movieCardAnimation,
            currentGradient: currentGradient,
            accentColor: AppColors.primary,
            isMobile: isMobile,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

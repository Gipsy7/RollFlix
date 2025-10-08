import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'models/movie.dart';
import 'models/tv_show.dart';
import 'models/roll_preferences.dart';
import 'services/movie_service.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/error_widgets.dart';
import 'widgets/responsive_widgets.dart';
import 'widgets/app_drawer.dart';
import 'widgets/content_widgets.dart';
import 'widgets/roll_preferences_dialog.dart';
import 'controllers/movie_controller.dart';
import 'controllers/tv_show_controller.dart';
import 'controllers/app_mode_controller.dart';
import 'repositories/tv_show_repository.dart';
import 'mixins/animation_mixin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  
  // Preferências de rolagem
  RollPreferences _rollPreferences = const RollPreferences();
  
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

  /// Abre o diálogo de preferências de rolagem
  Future<void> _openRollPreferences() async {
    final result = await showDialog<RollPreferences>(
      context: context,
      builder: (context) => RollPreferencesDialog(
        initialPreferences: _rollPreferences,
        isSeriesMode: _appModeController.isSeriesMode,
      ),
    );

    if (result != null) {
      setState(() {
        _rollPreferences = result;
      });
      
      // Limpa o cache para forçar nova busca com os filtros aplicados
      if (result.hasFilters) {
        debugPrint('🔄 Preferências com filtros aplicadas - limpando cache');
        _movieController.repository.clearCache();
        _tvShowController.repository.clearCache();
      }
      
      // Mostra feedback ao usuário
      if (result.hasFilters) {
        final filterParts = <String>[];
        if (result.ageRating != null) {
          final ageLabels = {
            'G': 'Livre',
            'PG': '10+',
            'PG-13': '13+',
            'R': '16+',
            'NC-17': '18+',
          };
          filterParts.add('🔞 ${ageLabels[result.ageRating] ?? result.ageRating}');
        }
        if (result.minYear != null || result.maxYear != null) {
          filterParts.add('📅 ${result.minYear ?? "..."}-${result.maxYear ?? "..."}');
        }
        
        AppSnackBar.showSuccess(
          context, 
          'Preferências aplicadas! ${filterParts.isNotEmpty ? filterParts.join(" • ") : ""}',
        );
      } else {
        AppSnackBar.showInfo(context, 'Preferências limpas');
      }
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
          await _tvShowController.rollShow(preferences: _rollPreferences);
          debugPrint('rollShow concluído. selectedShow: ${_tvShowController.selectedShow?.name}');
        }
      } else {
        debugPrint('Chamando rollMovie para filme...');
        // Usa o controller para filmes
        if (_movieController.canRollMovie || selectedGenre != _movieController.selectedGenre) {
          debugPrint('Preferências ANTES de chamar rollMovie: ${_rollPreferences.toJson()}');
          _movieController.selectGenre(selectedGenre);
          await _movieController.rollMovie(preferences: _rollPreferences);
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
              physics: const AlwaysScrollableScrollPhysics(), // Sempre permite scroll
              slivers: [
                _buildAppBar(isMobile),
                _buildContent(isMobile),
                // Adiciona um padding final como sliver para garantir espaço extra
                SliverPadding(
                  padding: EdgeInsets.only(bottom: isMobile ? 20 : 40),
                ),
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
        _buildPreferencesButton(isMobile),
        SizedBox(width: isMobile ? 8 : 12),
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

  Widget _buildPreferencesButton(bool isMobile) {
    final hasFilters = _rollPreferences.hasFilters;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: hasFilters 
            ? currentAccentColor.withValues(alpha: 0.9)
            : AppColors.surfaceDark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: hasFilters 
            ? Border.all(color: currentAccentColor, width: 2)
            : null,
        boxShadow: hasFilters 
            ? [
                BoxShadow(
                  color: currentAccentColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openRollPreferences,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Stack(
              children: [
                Icon(
                  Icons.tune,
                  color: hasFilters 
                      ? AppColors.backgroundDark
                      : AppColors.textPrimary,
                  size: isMobile ? 20 : 22,
                ),
                if (hasFilters)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.backgroundDark,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
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
                  AppColors.primaryLight.withValues(alpha: 0.8),
                ],
              ),
        borderRadius: BorderRadius.circular(30),
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
          borderRadius: BorderRadius.circular(30),
          onTap: _toggleContentMode,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _appModeController.isSeriesMode ? Icons.tv : Icons.movie,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                SafeText(
                  _appModeController.isSeriesMode ? 'SÉRIES' : 'FILMES',
                  style: (isMobile 
                      ? AppTextStyles.labelMedium
                      : AppTextStyles.labelLarge).copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.swap_horiz,
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
    final horizontalPadding = isMobile ? 16.0 : 24.0;
    
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
                // Removido o botão _buildActionButtons - agora está no GenreWheel
                const SizedBox(height: 16),
                if (_selectedMovie != null || _selectedTVShow != null) 
                  Builder(
                    builder: (context) => _buildContentCard(context, isMobile),
                  ),
                if (_errorMessage != null) _buildErrorMessage(),
                // Espaçamento final para garantir scroll completo
                SizedBox(height: isMobile ? 40 : 60),
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
        // Espaçamento superior reduzido
        SizedBox(height: isMobile ? 16 : 20),
        
        // Header com padding apenas nas laterais
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
          child: _buildGenreHeader(isMobile),
        ),
        
        const SizedBox(height: 20),
        
        // GenreWheel otimizado - altura reduzida
        SizedBox(
          height: isMobile ? 350 : 400,
          width: double.infinity,
          child: GenreWheel(
            genres: currentGenres,
            selectedGenre: _appModeController.selectedGenre,
            onGenreSelected: (genre) {
              _appModeController.selectGenre(genre);
            },
            onRandomSpin: () {},
            onRollContent: _handleRollContent,
            isLoadingContent: _isLoading,
            accentColor: _appModeController.isSeriesMode ? currentAccentColor : null,
            isSeriesMode: _appModeController.isSeriesMode,
          ),
        ),
        
        // Espaçamento inferior reduzido
        SizedBox(height: isMobile ? 16 : 20),
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

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';
import 'models/movie.dart';
import 'models/tv_show.dart';
import 'models/roll_preferences.dart';
import 'services/movie_service.dart';
import 'services/ad_service.dart';
import 'services/auth_service.dart';
import 'services/background_service.dart';
import 'utils/page_transitions.dart';
import 'widgets/genre_wheel.dart';
import 'widgets/error_widgets.dart';
import 'widgets/responsive_widgets.dart';
import 'widgets/app_drawer.dart';
import 'widgets/content_widgets.dart';
import 'widgets/roll_preferences_dialog.dart';
import 'controllers/movie_controller.dart';
import 'controllers/tv_show_controller.dart';
import 'controllers/app_mode_controller.dart';
import 'controllers/user_preferences_controller.dart';
import 'controllers/notification_controller.dart';
import 'repositories/tv_show_repository.dart';
import 'mixins/animation_mixin.dart';
import 'screens/movie_details_screen.dart';
import 'screens/tv_show_details_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar AdMob
  await AdService.initialize();
  
  // Pré-carregar anúncios para melhor experiência do usuário
  // Isso garante que os anúncios estejam prontos quando o usuário precisar
  await AdService.preloadAds();

  // Inicializar sistema de notificações
  NotificationController.instance;
  
  // Inicializar serviço de background
  await BackgroundService.initialize();
  await BackgroundService.registerPeriodicTask();

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
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper que verifica autenticação e direciona para tela apropriada
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Contador incremental para garantir key única a cada nova sessão
  int _sessionCounter = 0;
  String? _lastUserId;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        // Enquanto carrega, mostra splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }
        
        // Se está autenticado, vai para o app
        if (snapshot.hasData && snapshot.data != null) {
          final currentUserId = snapshot.data!.uid;
          
          // Se o usuário mudou ou é um novo login, incrementa o contador
          if (_lastUserId != currentUserId) {
            _sessionCounter++;
            _lastUserId = currentUserId;
          }
          
          // Usa ValueKey com contador para garantir reconstrução completa
          // a cada nova sessão, mesmo que seja o mesmo usuário
          return MovieSorterApp(key: ValueKey('session_$_sessionCounter'));
        }
        
        // Se não está autenticado, limpa o último usuário
        _lastUserId = null;
        
        // Se não está autenticado, vai para login
        return const LoginScreen();
      },
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
  late final UserPreferencesController _userPreferencesController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Flag para controlar quando a animação deve disparar
  bool _shouldAnimateCard = false;
  bool _showResultCard = false;

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
    _userPreferencesController = UserPreferencesController.instance;
    
    _setupListeners();
    _reloadPreferencesFromCloud(); // ← Recarrega preferências do Firebase
    _initializeApp();
    // _tryReloadResources(); ← REMOVIDO! Causava reset indevido ao voltar para a tela
  }
  
  /// Recarrega preferências do Firebase (para evitar usar dados antigos do singleton)
  void _reloadPreferencesFromCloud() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await _userPreferencesController.syncAfterLogin();
        debugPrint('✅ Preferências recarregadas do Firebase no initState');
      } catch (e) {
        debugPrint('❌ Erro ao recarregar preferências: $e');
      }
    });
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
    // Não dispose singletons - apenas reseta para estado inicial
    _movieController.reset();
    _tvShowController.reset();
    _userPreferencesController.reset();
    _tvShowRepository.cleanExpiredCache();
    super.dispose();
  }

  /// Método para alternar entre filmes e séries
  void _toggleContentMode() {
    _appModeController.toggleMode();
    
    // Reseta a flag ao trocar de modo para evitar animação automática
    setState(() {
      _shouldAnimateCard = false;
      _showResultCard = false;
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
        initialPreferences: _userPreferencesController.rollPreferences,
        isSeriesMode: _appModeController.isSeriesMode,
      ),
    );

    if (!mounted) return;

    if (result != null) {
      // As preferências já foram salvas pelo dialog, apenas notificamos a mudança
      setState(() {});
      
      // Limpa o cache para forçar nova busca com os filtros aplicados
      if (result.hasFilters) {
        debugPrint('🔄 Preferências com filtros aplicadas - limpando cache');
        _movieController.repository.clearCache();
        _tvShowController.repository.clearCache();
      }
      
      // Mostra feedback ao usuário
      if (result.hasFilters) {
        final filterParts = <String>[];
        if (!result.allowAdult) {
          filterParts.add('🔞 Apenas não adulto');
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

    // Tenta usar recurso de rolagem (com opção de assistir anúncio se necessário)
    final consumed = await _userPreferencesController.tryUseResourceWithAd(
      ResourceType.roll,
      context,
    );
    
    if (!consumed) {
      // Usuário cancelou ou anúncio não disponível
      return;
    }

    // Ativa a flag para permitir animação após o sorteio
    setState(() {
      _shouldAnimateCard = false;
      _showResultCard = false;
    });

    try {
      var rollExecuted = false;
      if (_appModeController.isSeriesMode) {
        debugPrint('Chamando rollShow para série...');
        // Usa o controller para séries
        if (_tvShowController.canRollShow || selectedGenre != _tvShowController.selectedGenre) {
          _tvShowController.selectGenre(selectedGenre);
          await _tvShowController.rollShow(preferences: _userPreferencesController.rollPreferences);
          if (!mounted) return;
          debugPrint('rollShow concluído. selectedShow: ${_tvShowController.selectedShow?.name}');
          rollExecuted = true;
        }
      } else {
        debugPrint('Chamando rollMovie para filme...');
        // Usa o controller para filmes
        if (_movieController.canRollMovie || selectedGenre != _movieController.selectedGenre) {
          debugPrint('Preferências ANTES de chamar rollMovie: ${_userPreferencesController.rollPreferences.toJson()}');
          _movieController.selectGenre(selectedGenre);
          await _movieController.rollMovie(preferences: _userPreferencesController.rollPreferences);
          if (!mounted) return;
          debugPrint('rollMovie concluído. selectedMovie: ${_movieController.selectedMovie?.title}');
          rollExecuted = true;
        }
      }

      if (rollExecuted) {
        // Incrementa estatísticas de sorteio
        await _userPreferencesController.incrementRollCount(_appModeController.isSeriesMode);
        await _openRolledContentDetails();
      }
    } catch (e) {
      debugPrint('Erro em _handleRollContent: $e');
      if (!mounted) return;
      AppSnackBar.showError(context, 'Não foi possível realizar o sorteio. Tente novamente.');
    }
  }

  Future<void> _openRolledContentDetails() async {
    if (!mounted) return;

    if (_appModeController.isSeriesMode) {
      final tvShow = _tvShowController.selectedShow;
      if (tvShow == null) {
        AppSnackBar.showInfo(context, 'Nenhuma série encontrada para esse filtro. Tente novamente.');
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TVShowDetailsScreen(tvShow: tvShow),
        ),
      );
      return;
    }

    final movie = _movieController.selectedMovie;
    if (movie == null) {
      AppSnackBar.showInfo(context, 'Nenhum filme encontrado para esse filtro. Tente novamente.');
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
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
          // Só faz isso na inicialização (quando não há erro e não há filme/série selecionado)
          if (_appModeController.selectedGenre == null && currentGenres.isNotEmpty) {
            final hasError = _appModeController.isSeriesMode 
                ? _tvShowController.errorMessage != null 
                : _movieController.errorMessage != null;
            final hasContent = _appModeController.isSeriesMode 
                ? _tvShowController.hasShow 
                : _movieController.hasMovie;
            
            // Só auto-seleciona se não houver erro e não houver conteúdo
            if (!hasError && !hasContent) {
              _appModeController.selectGenre(currentGenres.first);
              if (_appModeController.isSeriesMode) {
                _tvShowController.selectGenre(currentGenres.first);
              } else {
                _movieController.selectGenre(currentGenres.first);
              }
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
                  // Transição suave do gradiente da AppBar para o fundo escuro
                  currentGradient.colors.first.withValues(alpha: 0.3),
                  currentGradient.colors.last.withValues(alpha: 0.2),
                  const Color.fromARGB(255, 32, 31, 31).withValues(alpha: 0.95),
                  const Color.fromARGB(255, 29, 26, 26).withValues(alpha: 0.98),
                  const Color.fromARGB(211, 30, 31, 29),
                ],
                stops: const [0.0, 0.1, 0.3, 0.7, 1.0],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ), // Scroll mais suave com efeito bounce
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
    final hasFilters = _userPreferencesController.rollPreferences.hasFilters;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: _appModeController.isSeriesMode
            ? AppColors.secondaryGradient
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _appModeController.isSeriesMode
              ? AppColors.secondary.withOpacity(0.4)
              : AppColors.primary.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _openRollPreferences,
          splashColor: currentAccentColor.withOpacity(0.2),
          highlightColor: currentAccentColor.withOpacity(0.1),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(isMobile ? 12 : 14),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                    child: Icon(
                      Icons.tune,
                      key: ValueKey(hasFilters),
                      color: !_appModeController.isSeriesMode
                          ? Colors.black
                          : AppColors.textPrimary,
                      size: isMobile ? 22 : 24,
                    ),
                  ),
                  if (hasFilters)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: !_appModeController.isSeriesMode
                              ? Colors.black
                              : AppColors.textPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _appModeController.isSeriesMode
                                ? AppColors.secondary
                                : AppColors.primary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (!_appModeController.isSeriesMode
                                      ? Colors.black
                                      : AppColors.textPrimary)
                                  .withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: !_appModeController.isSeriesMode
                              ? AppColors.primary
                              : AppColors.secondary,
                          size: 6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwapButton(bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: _appModeController.isSeriesMode
            ? AppColors.secondaryGradient
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _appModeController.isSeriesMode
              ? AppColors.secondary.withOpacity(0.4)
              : AppColors.primary.withOpacity(0.4),
          width: 1.5,
        ),
        // Removido boxShadow para eliminar a borda iluminada retangular
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _toggleContentMode,
          splashColor: currentAccentColor.withOpacity(0.2),
          highlightColor: currentAccentColor.withOpacity(0.1),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 18,
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ),
                  child: Icon(
                    _appModeController.isSeriesMode ? Icons.tv : Icons.movie,
                    key: ValueKey(_appModeController.isSeriesMode),
                    color: !_appModeController.isSeriesMode 
                        ? Colors.black 
                        : AppColors.textPrimary,
                    size: isMobile ? 20 : 22,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  child: SafeText(
                    _appModeController.isSeriesMode ? 'SÉRIES' : 'FILMES',
                    key: ValueKey(_appModeController.isSeriesMode),
                    style: (isMobile
                        ? AppTextStyles.labelMedium
                        : AppTextStyles.labelLarge).copyWith(
                      color: !_appModeController.isSeriesMode 
                          ? Colors.black 
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: AppColors.backgroundDark.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween<double>(
                      begin: 0.25,
                      end: 0,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    )),
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    key: ValueKey('swap_${_appModeController.isSeriesMode}'),
                    color: !_appModeController.isSeriesMode 
                          ? Colors.black 
                          : AppColors.textPrimary,
                    size: isMobile ? 20 : 22,
                  ),
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
          // Seção de estatísticas rápidas
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
            child: _buildQuickStats(isMobile),
          ),

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
                if (_showResultCard && (_selectedMovie != null || _selectedTVShow != null))
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

  Widget _buildQuickStats(bool isMobile) {
    return ListenableBuilder(
      listenable: _userPreferencesController,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildResourceItem(
                icon: Icons.play_circle_filled,
                label: 'Rolagens',
                resourceType: ResourceType.roll,
                color: Colors.blue,
                isMobile: isMobile,
              ),
              _buildResourceItem(
                icon: Icons.favorite,
                label: 'Favoritos',
                resourceType: ResourceType.favorite,
                color: Colors.red,
                isMobile: isMobile,
              ),
              _buildResourceItem(
                icon: Icons.check_circle,
                label: 'Assistidos',
                resourceType: ResourceType.watched,
                color: Colors.green,
                isMobile: isMobile,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResourceItem({
    required IconData icon,
    required String label,
    required ResourceType resourceType,
    required Color color,
    required bool isMobile,
  }) {
    final uses = _userPreferencesController.userResources.getUses(resourceType);
    final canUse = _userPreferencesController.canUseResource(resourceType);
    final cooldown = _userPreferencesController.getResourceCooldown(resourceType);
    final maxUses = UserResources.maxUses;

    String displayValue;
    Color displayColor = color;
    String? subtitle;
    bool canWatchAd = uses < maxUses; // Pode assistir anúncio se tiver menos de 5

    if (canUse) {
      displayValue = uses.toString();
      subtitle = 'Disponível';
    } else if (cooldown != null) {
      // Formatar tempo restante
      final hours = cooldown.inHours;
      final minutes = cooldown.inMinutes.remainder(60);
      displayValue = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      displayColor = Colors.grey;
      subtitle = 'Recarregando';
    } else {
      displayValue = '0';
      displayColor = Colors.grey;
      subtitle = 'Indisponível';
    }

    // Widget base
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: displayColor, size: isMobile ? 20 : 24),
        const SizedBox(height: 4),
        Text(
          displayValue,
          style: (isMobile ? AppTextStyles.labelLarge : AppTextStyles.headlineSmall).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: canUse ? Colors.white.withOpacity(0.7) : Colors.red.withOpacity(0.7),
            fontSize: isMobile ? 10 : 12,
          ),
        ),
        // Indicador visual de que pode assistir anúncio
        if (canWatchAd)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam,
                  size: isMobile ? 10 : 12,
                  color: AppColors.primary.withOpacity(0.8),
                ),
                const SizedBox(width: 2),
                Text(
                  'Toque +1',
                  style: TextStyle(
                    fontSize: isMobile ? 8 : 10,
                    color: AppColors.primary.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    // Se pode assistir anúncio, torna clicável
    if (canWatchAd) {
      return InkWell(
        onTap: () => _showAdToRechargeResource(resourceType, label),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: content,
        ),
      );
    }

    // Se não pode assistir anúncio (já tem 5), apenas exibe
    return Padding(
      padding: const EdgeInsets.all(8),
      child: content,
    );
  }

  /// Mostra anúncio para recarregar recurso
  Future<void> _showAdToRechargeResource(ResourceType resourceType, String resourceName) async {
    final uses = _userPreferencesController.userResources.getUses(resourceType);
    final maxUses = UserResources.maxUses;

    // Define cores baseadas no modo
    final accentColor = _appModeController.isSeriesMode 
        ? const Color.fromARGB(255, 240, 43, 109) // Roxo/Rosa vibrante para séries
        : AppColors.primary; // Dourado para filmes

    // Confirmação amigável
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.videocam, color: accentColor, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Ganhar Recurso Extra',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você tem $uses/$maxUses $resourceName disponíveis.',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard, color: accentColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Assista a um anúncio curto e ganhe +1 recurso extra!',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.play_circle_filled),
            label: const Text('Assistir Anúncio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: _appModeController.isSeriesMode ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Mostra anúncio e concede recompensa
    final success = await _userPreferencesController.watchAdForResource(
      resourceType,
      context,
    );

    if (success && mounted) {
      setState(() {}); // Atualiza o contador visual
    }
  }
}

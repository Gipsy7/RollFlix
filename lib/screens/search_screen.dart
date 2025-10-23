import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/movie_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../widgets/ux_components.dart';
import '../controllers/app_mode_controller.dart';
import 'movie_details_screen.dart';
import 'tv_series_search_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final AppModeController _appModeController = AppModeController();
  
  List<Movie> _searchResults = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  
  bool _isSearching = false;
  bool _isLoadingPopular = false;
  bool _isLoadingTopRated = false;
  
  // Variáveis de paginação
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentSearchPage = 1;
  int _currentPopularPage = 1;
  int _currentTopRatedPage = 1;
  String _currentSearchQuery = '';
  
  String? _selectedGenre;
  String _currentFilter = 'popular'; // popular, toprated, search
  
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // "Em Alta" e "Mais Votados"
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Listener para mudanças de tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _resetPagination();
        if (_tabController.index == 0) {
          _currentFilter = 'popular';
        } else {
          _currentFilter = 'toprated';
        }
      }
    });
    
    _loadInitialData();
  }

  // Reset da paginação
  void _resetPagination() {
    setState(() {
      _currentSearchPage = 1;
      _currentPopularPage = 1;
      _currentTopRatedPage = 1;
      _hasMoreData = true;
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Listener para detectar quando o usuário chega ao final da lista
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  // Carrega mais dados baseado no filtro atual
  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    try {
      List<Movie> newMovies = [];
      
      switch (_currentFilter) {
        case 'popular':
          _currentPopularPage++;
          final movies = await MovieService.getPopularMovies(page: _currentPopularPage);
          if (movies != null && movies.isNotEmpty) {
            newMovies = movies;
            _popularMovies.addAll(newMovies);
          } else {
            _hasMoreData = false;
          }
          break;
          
        case 'toprated':
          _currentTopRatedPage++;
          final movies = await MovieService.getTopRatedMovies(page: _currentTopRatedPage);
          if (movies != null && movies.isNotEmpty) {
            newMovies = movies;
            _topRatedMovies.addAll(newMovies);
          } else {
            _hasMoreData = false;
          }
          break;
          
        case 'search':
          if (_currentSearchQuery.isNotEmpty) {
            _currentSearchPage++;
            final movies = await MovieService.searchMovies(_currentSearchQuery, page: _currentSearchPage);
            if (movies != null && movies.isNotEmpty) {
              newMovies = movies;
              _searchResults.addAll(newMovies);
            } else {
              _hasMoreData = false;
            }
          }
          break;
      }
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Erro ao carregar mais dados: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadPopularMovies(),
      _loadTopRatedMovies(),
    ]);
  }

  Future<void> _loadPopularMovies() async {
    if (_isLoadingPopular) return;
    
    setState(() => _isLoadingPopular = true);
    
    try {
      final movies = await MovieService.getPopularMovies();
      if (movies != null && mounted) {
        setState(() => _popularMovies = movies);
      }
    } catch (e) {
      debugPrint('Erro ao carregar filmes populares: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPopular = false);
    }
  }

  Future<void> _loadTopRatedMovies() async {
    if (_isLoadingTopRated) return;
    
    setState(() => _isLoadingTopRated = true);
    
    try {
      final movies = await MovieService.getTopRatedMovies();
      if (movies != null && mounted) {
        setState(() => _topRatedMovies = movies);
      }
    } catch (e) {
      debugPrint('Erro ao carregar filmes mais votados: $e');
    } finally {
      if (mounted) setState(() => _isLoadingTopRated = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _currentFilter = 'popular';
        _currentSearchQuery = '';
        _currentSearchPage = 1;
        _hasMoreData = true;
      });
      return;
    }

    // Reset paginação para nova pesquisa
    if (query != _currentSearchQuery) {
      _currentSearchPage = 1;
      _currentSearchQuery = query;
      _searchResults.clear();
      _hasMoreData = true;
    }

    setState(() {
      _isSearching = true;
      _currentFilter = 'search';
    });

    try {
      final results = await MovieService.searchMovies(query, page: _currentSearchPage);
      if (results != null && mounted) {
        setState(() {
          if (_currentSearchPage == 1) {
            _searchResults = results;
          } else {
            _searchResults.addAll(results);
          }
          _hasMoreData = results.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Erro na pesquisa: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.searchMoviesError),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _filterByGenre(String? genre) async {
    setState(() => _selectedGenre = genre);
    
    // Se genre for null (opção "Todos"), volta para as tabs
    if (genre == null) {
      setState(() {
        _currentFilter = 'popular';
        _searchResults = [];
        _currentSearchQuery = '';
        _currentSearchPage = 1;
        _hasMoreData = true;
      });
      return;
    }
    
    // Reset paginação para novo filtro
    _currentSearchPage = 1;
    _currentSearchQuery = genre;
    _hasMoreData = true;
    
    setState(() => _isSearching = true);
    
    try {
      List<Movie> movies;
      
      // Tratamento especial para "Heróis"
      if (genre == AppLocalizations.of(context)!.heroes) {
        movies = await _getHeroMovies();
      } else {
        movies = await MovieService.getMoviesByGenre(genre);
      }
      
      if (mounted) {
        setState(() {
          _searchResults = movies;
          _currentFilter = 'search';
        });
      }
    } catch (e) {
      debugPrint('Erro ao filtrar por gênero: $e');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // Método para buscar filmes de heróis (movido da lógica anterior)
  Future<List<Movie>> _getHeroMovies() async {
    try {
      // Busca por filmes de super-heróis (gêneros: Ação + Fantasia + Ficção Científica)
      final movies = await MovieService.getMoviesByGenres([28, 14, 878]); // Action, Fantasy, Sci-Fi
      if (movies != null) {
        // Filtra por palavras-chave relacionadas a heróis
        final heroKeywords = ['hero', 'super', 'man', 'woman', 'captain', 'spider', 'iron', 'batman', 'superman', 'wonder'];
        final heroMovies = movies.where((movie) {
          final title = movie.title.toLowerCase();
          final overview = movie.overview.toLowerCase();
          return heroKeywords.any((keyword) => 
            title.contains(keyword) || overview.contains(keyword)
          );
        }).toList();
        
        return heroMovies;
      }
      return [];
    } catch (e) {
      debugPrint('Erro ao carregar filmes de heróis: $e');
      return [];
    }
  }

  void _onMovieTap(Movie movie) {
    Navigator.of(context).pushDetails(
      MovieDetailsScreen(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(isMobile),
      body: Column(
        children: [
          _buildSearchSection(isMobile),
          _buildGenreFilter(isMobile),
          Expanded(child: _buildContent(isMobile)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: SafeText(
        AppLocalizations.of(context)!.searchMovies,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        _buildSwapButton(isMobile),
        SizedBox(width: isMobile ? 8 : 16),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cinemaGradient,
        ),
      ),
    );
  }

  Widget _buildSwapButton(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primaryLight.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            _appModeController.setToSeriesMode();
            Navigator.of(context).pushReplacementSmooth(
              const TVSeriesSearchScreen(),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.movie,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                SafeText(
                  AppLocalizations.of(context)!.movies,
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

  Widget _buildSearchSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: AppColors.cinemaGradient.scale(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withValues(alpha:0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeText(
            AppLocalizations.of(context)!.findYourNextFavoriteMovie,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(isMobile),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchHint,
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary.withValues(alpha:0.7),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary,
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.length >= 3) {
            _performSearch(value);
          } else if (value.isEmpty) {
            _performSearch('');
          }
        },
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildGenreFilter(bool isMobile) {
    // Lista de gêneros incluindo "Heróis"
    final allGenres = [...AppConstants.movieGenres, AppLocalizations.of(context)!.heroes];
    
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        children: [
          _buildGenreChip(AppLocalizations.of(context)!.all, null, isMobile),
          const SizedBox(width: 8),
          ...allGenres.map((genre) => 
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildGenreChip(genre, genre, isMobile),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String label, String? genre, bool isMobile) {
    final isSelected = _selectedGenre == genre;
    
    return GestureDetector(
      onTap: () => _filterByGenre(genre),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? AppColors.primaryGradient
              : LinearGradient(
                  colors: [
                    AppColors.backgroundDark.withValues(alpha:0.8),
                    AppColors.backgroundDark.withValues(alpha:0.6),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha:0.3),
            width: 1,
          ),
        ),
        child: SafeText(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected 
                ? AppColors.backgroundDark
                : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    if (_currentFilter == 'search') {
      return _buildSearchResults(isMobile);
    }
    
    return Column(
      children: [
        _buildTabBar(),
        Expanded(child: _buildTabBarView(isMobile)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.backgroundDark,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.trending),
          Tab(text: AppLocalizations.of(context)!.topRated),
        ],
      ),
    );
  }

  Widget _buildTabBarView(bool isMobile) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMovieGrid(_popularMovies, _isLoadingPopular, isMobile),
        _buildMovieGrid(_topRatedMovies, _isLoadingTopRated, isMobile),
      ],
    );
  }

  Widget _buildSearchResults(bool isMobile) {
    if (_isSearching) {
      return Center(
        child: OptimizedLoadingIndicator(
          message: AppLocalizations.of(context)!.searchingMovies,
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha:0.5),
            ),
            const SizedBox(height: 16),
            SafeText(
              AppLocalizations.of(context)!.noResultsFound,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              AppLocalizations.of(context)!.tryDifferentKeywords,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha:0.7),
              ),
            ),
          ],
        ),
      );
    }

    return _buildMovieGrid(_searchResults, false, isMobile);
  }

  Widget _buildMovieGrid(List<Movie> movies, bool isLoading, bool isMobile) {
    if (isLoading) {
      return Center(
        child: OptimizedLoadingIndicator(
          message: AppLocalizations.of(context)!.loadingMovies,
        ),
      );
    }

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha:0.5),
            ),
            const SizedBox(height: 16),
            SafeText(
              AppLocalizations.of(context)!.noMoviesFound,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = ResponsiveUtils.getResponsiveGridColumns(context);
              final spacing = ResponsiveUtils.isMobile(context) 
                ? AppConstants.spacingM 
                : AppConstants.spacingL;
              
              // Aspect ratio responsivo para evitar overflow
              double aspectRatio;
              if (ResponsiveUtils.isMobile(context)) {
                aspectRatio = 0.75; // Mobile: mais quadrado
              } else if (ResponsiveUtils.isTablet(context)) {
                aspectRatio = 0.70; // Tablet: intermediário
              } else {
                aspectRatio = 0.67; // Desktop: mais retangular
              }

              return GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(spacing),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: movies.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= movies.length) {
                    // Item de loading no final da lista
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: OptimizedLoadingIndicator(size: 24),
                      ),
                    );
                  }
                  
                  return MovieCard(
                    movie: movies[index],
                    onTap: () => _onMovieTap(movies[index]),
                  );
                },
              );
            },
          ),
        ),
        
        // Indicador de carregamento fixo na parte inferior
        if (_isLoadingMore && movies.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: UXComponents.loadingWithText(
              text: AppLocalizations.of(context)!.loadingMoreResults,
              spinnerSize: 20,
            ),
          ),
      ],
    );
  }
}
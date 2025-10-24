import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/tv_show.dart';
import '../services/movie_service.dart';
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../widgets/common_widgets.dart';
import '../controllers/app_mode_controller.dart';
import 'tv_show_details_screen.dart';
import 'search_screen.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../utils/localized_genres.dart';

class TVSeriesSearchScreen extends StatefulWidget {
  const TVSeriesSearchScreen({super.key});

  @override
  State<TVSeriesSearchScreen> createState() => _TVSeriesSearchScreenState();
}

class _TVSeriesSearchScreenState extends State<TVSeriesSearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final AppModeController _appModeController = AppModeController();
  
  List<TVShow> _searchResults = [];
  List<TVShow> _popularTVShows = [];
  List<TVShow> _topRatedTVShows = [];
  
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
    _tabController = TabController(length: 2, vsync: this); // "Em Alta" e "Mais Votadas"
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
      List<TVShow> newTVShows = [];
      
      switch (_currentFilter) {
        case 'popular':
          _currentPopularPage++;
          final tvShows = await MovieService.getPopularTVShows(page: _currentPopularPage);
          if (tvShows != null && tvShows.isNotEmpty) {
            newTVShows = tvShows;
            _popularTVShows.addAll(newTVShows);
          } else {
            _hasMoreData = false;
          }
          break;
          
        case 'toprated':
          _currentTopRatedPage++;
          final tvShows = await MovieService.getTopRatedTVShows(page: _currentTopRatedPage);
          if (tvShows != null && tvShows.isNotEmpty) {
            newTVShows = tvShows;
            _topRatedTVShows.addAll(newTVShows);
          } else {
            _hasMoreData = false;
          }
          break;
          
        case 'search':
          if (_currentSearchQuery.isNotEmpty) {
            _currentSearchPage++;
            final tvShows = await MovieService.searchTVShows(_currentSearchQuery, page: _currentSearchPage);
            if (tvShows != null && tvShows.isNotEmpty) {
              newTVShows = tvShows;
              _searchResults.addAll(newTVShows);
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
      _loadPopularTVShows(),
      _loadTopRatedTVShows(),
    ]);
  }

  Future<void> _loadPopularTVShows() async {
    if (_isLoadingPopular) return;
    
    setState(() => _isLoadingPopular = true);
    
    try {
      final tvShows = await MovieService.getPopularTVShows();
      if (tvShows != null && mounted) {
        setState(() => _popularTVShows = tvShows);
      }
    } catch (e) {
      debugPrint('Erro ao carregar séries populares: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPopular = false);
    }
  }

  Future<void> _loadTopRatedTVShows() async {
    if (_isLoadingTopRated) return;
    
    setState(() => _isLoadingTopRated = true);
    
    try {
      final tvShows = await MovieService.getTopRatedTVShows();
      if (tvShows != null && mounted) {
        setState(() => _topRatedTVShows = tvShows);
      }
    } catch (e) {
      debugPrint('Erro ao carregar séries mais votadas: $e');
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
      final results = await MovieService.searchTVShows(query, page: _currentSearchPage);
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
            content: Text(AppLocalizations.of(context)!.searchError),
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
      final tvShows = await MovieService.getTVShowsByGenre(genre);
      
      if (mounted) {
        setState(() {
          _searchResults = tvShows;
          _currentFilter = 'search';
        });
      }
    } catch (e) {
      debugPrint('Erro ao filtrar por gênero: $e');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onTVShowTap(TVShow tvShow) {
    Navigator.of(context).pushDetails(
      TVShowDetailsScreen(tvShow: tvShow),
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
        AppLocalizations.of(context)!.searchSeries,
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 45, 3, 56), // Roxo escuro
              Color.fromARGB(255, 240, 43, 109), // Roxo vibrante
            ],
          ),
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
            const Color.fromARGB(255, 147, 51, 234).withValues(alpha: 0.8),
            const Color.fromARGB(255, 219, 39, 119).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBB86FC).withValues(alpha: 0.3),
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
            _appModeController.setToMovieMode();
            Navigator.of(context).pushReplacementSmooth(
              const SearchScreen(),
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
                  Icons.tv,
                  color: AppColors.textPrimary,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                SafeText(
                  AppLocalizations.of(context)!.series,
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(60, 45, 3, 56), // Roxo escuro com transparência
            Color.fromARGB(40, 240, 43, 109), // Roxo vibrante com transparência
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(51, 240, 43, 109),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeText(
            'Encontre sua próxima série favorita',
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
        color: AppColors.backgroundDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(76, 240, 43, 109),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchSeriesHint,
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 240, 43, 109),
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
    // Lista de gêneros de TV localizados
    final tvGenres = MovieService.getTVGenres();
    final localizedTVGenres = tvGenres.map((genre) =>
        LocalizedGenres.getTVGenreName(context, genre)).toList();
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        children: [
          _buildGenreChip(AppLocalizations.of(context)!.all, null, isMobile),
          const SizedBox(width: 8),
          ...localizedTVGenres.map((localizedGenre) => 
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildGenreChip(localizedGenre, tvGenres[localizedTVGenres.indexOf(localizedGenre)], isMobile),
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
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 45, 3, 56),
                    Color.fromARGB(255, 240, 43, 109),
                  ],
                )
              : LinearGradient(
                  colors: [
                    AppColors.backgroundDark.withValues(alpha: 0.8),
                    AppColors.backgroundDark.withValues(alpha: 0.6),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color.fromARGB(255, 240, 43, 109)
                : AppColors.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: SafeText(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected 
                ? AppColors.textPrimary
                : AppColors.textSecondary.withValues(alpha: 0.5),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    // Se está pesquisando ou filtrando por gênero, mostra resultados da pesquisa
    if (_currentFilter == 'search') {
      return _buildSearchResults(isMobile);
    }
    
    // Caso contrário, mostra as tabs
    return Column(
      children: [
        _buildTabBar(),
        Expanded(child: _buildTabContent(isMobile)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
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
        labelColor: const Color.fromARGB(255, 240, 43, 109),
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: const Color.fromARGB(255, 240, 43, 109),
        labelStyle: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.bodyLarge,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.trendingTab),
          Tab(text: AppLocalizations.of(context)!.topRatedTab),
        ],
      ),
    );
  }

  Widget _buildTabContent(bool isMobile) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPopularTab(isMobile),
        _buildTopRatedTab(isMobile),
      ],
    );
  }

  Widget _buildPopularTab(bool isMobile) {
    if (_isLoadingPopular && _popularTVShows.isEmpty) {
      return const Center(child: OptimizedLoadingIndicator());
    }

    if (_popularTVShows.isEmpty) {
      return _buildEmptyState('Nenhuma série popular encontrada');
    }

    return _buildTVShowGrid(_popularTVShows, isMobile);
  }

  Widget _buildTopRatedTab(bool isMobile) {
    if (_isLoadingTopRated && _topRatedTVShows.isEmpty) {
      return const Center(child: OptimizedLoadingIndicator());
    }

    if (_topRatedTVShows.isEmpty) {
      return _buildEmptyState('Nenhuma série encontrada');
    }

    return _buildTVShowGrid(_topRatedTVShows, isMobile);
  }

  Widget _buildSearchResults(bool isMobile) {
    if (_isSearching && _searchResults.isEmpty) {
      return const Center(child: OptimizedLoadingIndicator());
    }

    if (_searchResults.isEmpty && _currentSearchQuery.isNotEmpty) {
      return _buildEmptyState(AppLocalizations.of(context)!.noSeriesFound);
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(AppLocalizations.of(context)!.searchSeriesPrompt);
    }

    return _buildTVShowGrid(_searchResults, isMobile);
  }

  Widget _buildTVShowGrid(List<TVShow> tvShows, bool isMobile) {
    return RefreshIndicator(
      color: const Color.fromARGB(255, 240, 43, 109),
      onRefresh: _loadInitialData,
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          childAspectRatio: 0.7,
          crossAxisSpacing: isMobile ? 12 : 16,
          mainAxisSpacing: isMobile ? 16 : 20,
        ),
        itemCount: tvShows.length + (_isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= tvShows.length) {
            return const Center(child: OptimizedLoadingIndicator(size: 20));
          }

          final tvShow = tvShows[index];
          return _buildTVShowCard(tvShow, isMobile);
        },
      ),
    );
  }

  Widget _buildTVShowCard(TVShow tvShow, bool isMobile) {
    return GestureDetector(
      onTap: () => _onTVShowTap(tvShow),
      child: AppCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 45, 3, 56),
                      Color.fromARGB(255, 240, 43, 109),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: tvShow.posterPath.isNotEmpty
                      ? OptimizedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.surfaceDark,
                          child: Icon(
                            Icons.tv,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              tvShow.name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: const Color.fromARGB(255, 240, 43, 109),
                ),
                const SizedBox(width: 4),
                SafeText(
                  tvShow.voteAverage.toStringAsFixed(1),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tv_off,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          SafeText(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
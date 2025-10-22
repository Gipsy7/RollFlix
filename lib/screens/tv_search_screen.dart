import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/tv_show.dart';
import '../services/movie_service.dart';
import '../utils/page_transitions.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/optimized_widgets.dart';
import '../widgets/common_widgets.dart';
import 'tv_show_details_screen.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class TVSearchScreen extends StatefulWidget {
  const TVSearchScreen({super.key});

  @override
  State<TVSearchScreen> createState() => _TVSearchScreenState();
}

class _TVSearchScreenState extends State<TVSearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
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
  
  String _currentFilter = 'popular'; // popular, top_rated, search
  
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // "Em Alta" e "Mais Avaliadas"
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
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

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    await _loadPopularTVShows();
  }

  Future<void> _loadPopularTVShows() async {
    if (_isLoadingPopular) return;
    
    setState(() {
      _isLoadingPopular = true;
      _currentFilter = 'popular';
      _hasMoreData = true;
      _currentPopularPage = 1;
    });

    try {
      final tvShows = await MovieService.getPopularTVShows(page: 1);
      if (mounted && tvShows != null) {
        setState(() {
          _popularTVShows = tvShows;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar séries populares: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPopular = false);
      }
    }
  }

  Future<void> _loadTopRatedTVShows() async {
    if (_isLoadingTopRated) return;
    
    setState(() {
      _isLoadingTopRated = true;
      _currentFilter = 'top_rated';
      _hasMoreData = true;
      _currentTopRatedPage = 1;
    });

    try {
      final tvShows = await MovieService.getTopRatedTVShows(page: 1);
      if (mounted && tvShows != null) {
        setState(() {
          _topRatedTVShows = tvShows;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar séries mais avaliadas: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingTopRated = false);
      }
    }
  }

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
          
        case 'top_rated':
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

  Future<void> _searchTVShows(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
        _currentFilter = 'popular';
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _currentFilter = 'search';
      _currentSearchQuery = query.trim();
      _currentSearchPage = 1;
      _hasMoreData = true;
    });

    try {
      final tvShows = await MovieService.searchTVShows(query.trim());
      if (mounted) {
        setState(() {
          _searchResults = tvShows ?? [];
          _isSearching = false;
        });
      }
    } catch (e) {
      debugPrint('Erro na pesquisa: $e');
      if (mounted) {
        setState(() {
          _searchResults.clear();
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _searchResults.clear();
      _currentFilter = 'popular';
      _isSearching = false;
      _currentSearchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isMobile),
            _buildSearchBar(isMobile),
            if (_currentFilter != 'search') _buildTabBar(),
            Expanded(
              child: _buildContent(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 45, 3, 56),
            Color.fromARGB(255, 75, 0, 130),
            Color.fromARGB(255, 128, 0, 128),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.tv,
            color: AppColors.textPrimary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SafeText(
              AppLocalizations.of(context)!.searchSeries,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.purple.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchTVHint,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.purple,
                    size: 20,
                  ),
                  suffixIcon: _currentSearchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _searchTVShows,
                onChanged: (value) {
                  if (value.trim().isEmpty && _currentSearchQuery.isNotEmpty) {
                    _clearSearch();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 128, 0, 128),
                  Color.fromARGB(255, 75, 0, 130),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _searchTVShows(_searchController.text),
              icon: Icon(
                Icons.search,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 128, 0, 128),
              Color.fromARGB(255, 75, 0, 130),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelLarge,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        onTap: (index) {
          switch (index) {
            case 0:
              _loadPopularTVShows();
              break;
            case 1:
              _loadTopRatedTVShows();
              break;
          }
        },
        tabs: [
          Tab(
            icon: Icon(Icons.trending_up, size: 20),
            text: AppLocalizations.of(context)!.trending,
          ),
          Tab(
            icon: Icon(Icons.star, size: 20),
            text: AppLocalizations.of(context)!.topRated,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    if (_currentFilter == 'search') {
      return _buildSearchResults(isMobile);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildPopularTVShows(isMobile),
        _buildTopRatedTVShows(isMobile),
      ],
    );
  }

  Widget _buildSearchResults(bool isMobile) {
    if (_isSearching) {
      return const Center(
        child: OptimizedLoadingIndicator(),
      );
    }

    if (_searchResults.isEmpty && _currentSearchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            SafeText(
              AppLocalizations.of(context)!.noSeriesFound,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              'Tente usar outros termos de busca',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return _buildTVShowGrid(_searchResults, isMobile);
  }

  Widget _buildPopularTVShows(bool isMobile) {
    if (_isLoadingPopular && _popularTVShows.isEmpty) {
      return const Center(
        child: OptimizedLoadingIndicator(),
      );
    }

    return _buildTVShowGrid(_popularTVShows, isMobile);
  }

  Widget _buildTopRatedTVShows(bool isMobile) {
    if (_isLoadingTopRated && _topRatedTVShows.isEmpty) {
      return const Center(
        child: OptimizedLoadingIndicator(),
      );
    }

    return _buildTVShowGrid(_topRatedTVShows, isMobile);
  }

  Widget _buildTVShowGrid(List<TVShow> tvShows, bool isMobile) {
    if (tvShows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            SafeText(
              AppLocalizations.of(context)!.noSeriesAvailable,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: isMobile ? 12 : 16,
              mainAxisSpacing: isMobile ? 16 : 20,
              childAspectRatio: isMobile ? 0.65 : 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildTVShowCard(tvShows[index], isMobile);
              },
              childCount: tvShows.length,
            ),
          ),
        ),
        if (_isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: OptimizedLoadingIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTVShowCard(TVShow tvShow, bool isMobile) {
    return AppCard(
      onTap: () {
        Navigator.of(context).pushDetails(
          TVShowDetailsScreen(tvShow: tvShow),
        );
      },
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 75, 0, 130),
                    Color.fromARGB(255, 128, 0, 128),
                  ],
                ),
              ),
              child: OptimizedNetworkImage(
                imageUrl: tvShow.posterPath.isNotEmpty 
                    ? 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}'
                    : '',
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(8),
                errorWidget: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 75, 0, 130),
                        Color.fromARGB(255, 128, 0, 128),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tv,
                    color: AppColors.textPrimary,
                    size: 48,
                  ),
                ),
                placeholder: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: OptimizedLoadingIndicator(size: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeText(
                  tvShow.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 4),
                    SafeText(
                      tvShow.voteAverage.toStringAsFixed(1),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (tvShow.year.isNotEmpty)
                      SafeText(
                        tvShow.year,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
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
}
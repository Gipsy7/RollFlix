import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/movie_widgets.dart';
import '../widgets/optimized_widgets.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<Movie> _searchResults = [];
  List<Movie> _popularMovies = [];
  List<Movie> _upcomingMovies = [];
  
  bool _isSearching = false;
  bool _isLoadingPopular = false;
  bool _isLoadingUpcoming = false;
  
  String? _selectedGenre;
  String _currentFilter = 'popular'; // popular, upcoming, heroes, search
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Apenas "Em Alta" e "Novidades"
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadPopularMovies(),
      _loadUpcomingMovies(),
      // Removido _loadHeroMovies() pois será tratado como gênero
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

  Future<void> _loadUpcomingMovies() async {
    if (_isLoadingUpcoming) return;
    
    setState(() => _isLoadingUpcoming = true);
    
    try {
      final movies = await MovieService.getUpcomingMovies();
      if (movies != null && mounted) {
        setState(() => _upcomingMovies = movies);
      }
    } catch (e) {
      debugPrint('Erro ao carregar novidades: $e');
    } finally {
      if (mounted) setState(() => _isLoadingUpcoming = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _currentFilter = 'popular';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _currentFilter = 'search';
    });

    try {
      final results = await MovieService.searchMovies(query);
      if (results != null && mounted) {
        setState(() => _searchResults = results);
      }
    } catch (e) {
      debugPrint('Erro na pesquisa: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao pesquisar filmes'),
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
      });
      return;
    }
    
    setState(() => _isSearching = true);
    
    try {
      List<Movie> movies;
      
      // Tratamento especial para "Heróis"
      if (genre == 'Heróis') {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
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
        'Pesquisar Filmes',
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cinemaGradient,
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
            color: AppColors.textSecondary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeText(
            'Encontre seu próximo filme favorito',
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
        color: AppColors.backgroundDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Digite o nome do filme ou série...',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary.withOpacity(0.7),
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
    final allGenres = [...AppConstants.movieGenres, 'Heróis'];
    
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        children: [
          _buildGenreChip('Todos', null, isMobile),
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
                    AppColors.backgroundDark.withOpacity(0.8),
                    AppColors.backgroundDark.withOpacity(0.6),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.3),
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
        tabs: const [
          Tab(text: 'Em Alta'),
          Tab(text: 'Novidades'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(bool isMobile) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMovieGrid(_popularMovies, _isLoadingPopular, isMobile),
        _buildMovieGrid(_upcomingMovies, _isLoadingUpcoming, isMobile),
      ],
    );
  }

  Widget _buildSearchResults(bool isMobile) {
    if (_isSearching) {
      return const Center(
        child: OptimizedLoadingIndicator(
          message: 'Pesquisando filmes...',
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
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            SafeText(
              'Nenhum resultado encontrado',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SafeText(
              'Tente pesquisar com outras palavras-chave',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
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
      return const Center(
        child: OptimizedLoadingIndicator(
          message: 'Carregando filmes...',
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
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            SafeText(
              'Nenhum filme encontrado',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return MovieGridView(
      movies: movies,
      onMovieTap: _onMovieTap,
      isLoading: false,
    );
  }
}
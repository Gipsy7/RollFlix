import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../models/actor_details.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_theme.dart';
import '../core/constants/constants.dart';
import '../utils/page_transitions.dart';
import 'movie_details_screen.dart';

class ActorDetailsScreen extends StatefulWidget {
  final int actorId;
  final String actorName;
  final bool isDirector;

  const ActorDetailsScreen({
    super.key,
    required this.actorId,
    required this.actorName,
    this.isDirector = false,
  });

  @override
  State<ActorDetailsScreen> createState() => _ActorDetailsScreenState();
}

class _ActorDetailsScreenState extends State<ActorDetailsScreen> {
  ActorDetails? actorDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActorDetails();
  }

  Future<void> _loadActorDetails() async {
    try {
      // Carregar detalhes básicos da pessoa
      final basicDetails = await MovieService.getActorDetails(widget.actorId);
      
      // Carregar filmografia baseada no tipo (ator ou diretor)
      final filmography = widget.isDirector 
        ? await MovieService.getDirectorMovies(widget.actorId)
        : await MovieService.getActorMovies(widget.actorId);
      
      final details = ActorDetails(
        id: basicDetails.id,
        name: basicDetails.name,
        biography: basicDetails.biography,
        profilePath: basicDetails.profilePath,
        birthday: basicDetails.birthday,
        deathday: basicDetails.deathday,
        placeOfBirth: basicDetails.placeOfBirth,
        knownForDepartment: basicDetails.knownForDepartment,
        popularity: basicDetails.popularity,
        knownFor: filmography,
      );
      
      setState(() {
        actorDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToMovieDetails(ActorMovie actorMovie) {
    // Convert ActorMovie to Movie
    final movie = Movie(
      id: actorMovie.id,
      title: actorMovie.title,
      overview: '', // Will be loaded in details
      posterPath: actorMovie.posterPath ?? '',
      backdropPath: '',
      releaseDate: actorMovie.releaseDate ?? '',
      voteAverage: actorMovie.voteAverage,
      voteCount: 0,
      genreIds: [], // Empty for now, will be loaded in details
    );
    
    Navigator.of(context).pushDetails(
      MovieDetailsScreen(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.slow,
      color: AppColors.backgroundDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              foregroundColor: AppColors.textPrimary,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedDefaultTextStyle(
                  duration: AppDurations.slow,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  child: Text(widget.actorName),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (actorDetails?.fullProfileUrl.isNotEmpty == true)
                      Image.network(
                        actorDetails!.fullProfileUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceDark,
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: AppColors.textMuted,
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        color: AppColors.surfaceDark,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: AppColors.textMuted,
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppNumbers.paddingDesktop),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informações Básicas
                      Card(
                        elevation: 2,
                        color: AppColors.surfaceDark,
                        child: Padding(
                          padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  AnimatedDefaultTextStyle(
                                    duration: AppDurations.slow,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                    child: Text(AppLocalizations.of(context)!.basicInfo),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (actorDetails!.knownForDepartment != null) ...[
                                Text(
                                  '${widget.isDirector ? AppLocalizations.of(context)!.director : AppLocalizations.of(context)!.actor}: ${actorDetails!.knownForDepartment}',
                                  style: TextStyle(
                                    fontSize: 16, 
                                    color: AppColors.textPrimary
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (actorDetails!.birthday != null) ...[
                                Text(
                                  'Nascimento: ${actorDetails!.birthday}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (actorDetails!.deathday != null) ...[
                                Text(
                                  'Falecimento: ${actorDetails!.deathday}',
                                  style: const TextStyle(fontSize: 16, color: Colors.red),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (actorDetails!.placeOfBirth != null) ...[
                                Text(
                                  'Local de Nascimento: ${actorDetails!.placeOfBirth}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Biografia
                      if (actorDetails!.biography != null && actorDetails!.biography!.isNotEmpty) ...[
                        Card(
                          elevation: 2,
                          color: AppColors.surfaceDark,
                          child: Padding(
                            padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.description, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    AnimatedDefaultTextStyle(
                                      duration: AppDurations.slow,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      child: Text(AppLocalizations.of(context)!.biography),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  actorDetails!.biography!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Filmografia
                      if (actorDetails!.knownFor.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          color: AppColors.surfaceDark,
                          child: Padding(
                            padding: EdgeInsets.all(AppNumbers.spacingMedium + 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.movie, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    AnimatedDefaultTextStyle(
                                      duration: AppDurations.slow,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      child: Text(widget.isDirector ? AppLocalizations.of(context)!.filmographyAsDirector : AppLocalizations.of(context)!.filmography),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: actorDetails!.knownFor.length,
                                    itemBuilder: (context, index) {
                                      final movie = actorDetails!.knownFor[index];
                                      return GestureDetector(
                                        onTap: () => _navigateToMovieDetails(movie),
                                        child: Container(
                                          width: 120,
                                          margin: EdgeInsets.only(right: AppNumbers.spacingSmall + 4),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: movie.fullPosterUrl.isNotEmpty
                                                      ? Image.network(
                                                          movie.fullPosterUrl,
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              color: AppColors.surfaceDark,
                                                              child: Icon(
                                                                Icons.movie,
                                                                size: 50,
                                                                color: AppColors.textMuted,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Container(
                                                          color: AppColors.surfaceDark,
                                                          child: Icon(
                                                            Icons.movie,
                                                            size: 50,
                                                            color: AppColors.textMuted,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                movie.title,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textPrimary,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



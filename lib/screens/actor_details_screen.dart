import 'package:flutter/material.dart';
import '../models/actor_details.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
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

  void _navigateToMovie(ActorMovie movie) {
    final movieObj = Movie(
      id: movie.id,
      title: movie.title,
      overview: '',
      voteAverage: movie.voteAverage,
      releaseDate: movie.year,
      posterPath: movie.posterPath,
      genreIds: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movieObj),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.actorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
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
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (actorDetails == null)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Erro ao carregar informações do ator',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações Básicas
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue.shade600),
                                const SizedBox(width: 8),
                                const Text(
                                  'Informações Básicas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (actorDetails!.knownForDepartment != null) ...[
                              _buildInfoRow('Conhecido por', actorDetails!.knownForDepartment!),
                              const SizedBox(height: 8),
                            ],
                            if (actorDetails!.birthday != null) ...[
                              _buildInfoRow('Nascimento', '${actorDetails!.formattedBirthday} ${actorDetails!.ageString}'),
                              const SizedBox(height: 8),
                            ],
                            if (actorDetails!.placeOfBirth != null) ...[
                              _buildInfoRow('Local de Nascimento', actorDetails!.placeOfBirth!),
                              const SizedBox(height: 8),
                            ],
                            if (actorDetails!.deathday != null) ...[
                              _buildInfoRow('Falecimento', actorDetails!.deathday!),
                              const SizedBox(height: 8),
                            ],
                            _buildInfoRow('Popularidade', '${actorDetails!.popularity.toStringAsFixed(1)}/10'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Biografia
                    if (actorDetails!.biography != null && actorDetails!.biography!.isNotEmpty) ...[
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description, color: Colors.green.shade600),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Biografia',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                actorDetails!.biography!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Filmografia
                    if (actorDetails!.knownFor.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            widget.isDirector ? Icons.movie_filter : Icons.movie, 
                            color: Colors.purple.shade600
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isDirector ? 'Filmografia como Diretor' : 'Filmografia como Ator',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: actorDetails!.knownFor.length,
                        itemBuilder: (context, index) {
                          final movie = actorDetails!.knownFor[index];
                          return GestureDetector(
                            onTap: () => _navigateToMovie(movie),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                      child: movie.fullPosterUrl.isNotEmpty
                                          ? Image.network(
                                              movie.fullPosterUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey.shade300,
                                                  child: const Icon(
                                                    Icons.movie,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.movie,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              movie.title,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            movie.year,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          if (movie.character != null && movie.character!.isNotEmpty)
                                            Text(
                                              movie.character!,
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.blue.shade600,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
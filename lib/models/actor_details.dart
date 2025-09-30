class ActorDetails {
  final int id;
  final String name;
  final String? biography;
  final String? profilePath;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? knownForDepartment;
  final double popularity;
  final List<ActorMovie> knownFor;

  ActorDetails({
    required this.id,
    required this.name,
    this.biography,
    this.profilePath,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.knownForDepartment,
    required this.popularity,
    required this.knownFor,
  });

  factory ActorDetails.fromJson(Map<String, dynamic> json) {
    return ActorDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      biography: json['biography']?.isNotEmpty == true ? json['biography'] : null,
      profilePath: json['profile_path'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      placeOfBirth: json['place_of_birth'],
      knownForDepartment: json['known_for_department'],
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      knownFor: [],
    );
  }

  String get fullProfileUrl => profilePath != null 
    ? 'https://image.tmdb.org/t/p/w500$profilePath' 
    : '';

  String get formattedBirthday {
    if (birthday == null) return 'Data de nascimento não disponível';
    try {
      final date = DateTime.parse(birthday!);
      final months = [
        'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
        'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
      ];
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    } catch (e) {
      return birthday!;
    }
  }

  int get age {
    if (birthday == null) return 0;
    try {
      final birthDate = DateTime.parse(birthday!);
      final now = deathday != null ? DateTime.parse(deathday!) : DateTime.now();
      return now.year - birthDate.year - 
        (now.month < birthDate.month || 
         (now.month == birthDate.month && now.day < birthDate.day) ? 1 : 0);
    } catch (e) {
      return 0;
    }
  }

  String get ageString {
    if (age == 0) return '';
    if (deathday != null) {
      return '($age anos na época da morte)';
    }
    return '($age anos)';
  }
}

class ActorMovie {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;
  final String? character;

  ActorMovie({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    required this.voteAverage,
    this.character,
  });

  factory ActorMovie.fromJson(Map<String, dynamic> json) {
    return ActorMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? json['first_air_date'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      character: json['character'],
    );
  }

  String get fullPosterUrl => posterPath != null 
    ? 'https://image.tmdb.org/t/p/w300$posterPath' 
    : '';

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return 'TBA';
    try {
      return DateTime.parse(releaseDate!).year.toString();
    } catch (e) {
      return 'TBA';
    }
  }
}
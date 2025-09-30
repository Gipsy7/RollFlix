class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nome não disponível',
      character: json['character'] ?? 'Personagem não disponível',
      profilePath: json['profile_path'],
      order: json['order'] ?? 999,
    );
  }

  String get fullProfileUrl {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w185$profilePath';
    }
    return '';
  }
}

class CrewMember {
  final int id;
  final String name;
  final String job;
  final String department;
  final String? profilePath;

  CrewMember({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    this.profilePath,
  });

  factory CrewMember.fromJson(Map<String, dynamic> json) {
    return CrewMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nome não disponível',
      job: json['job'] ?? 'Função não disponível',
      department: json['department'] ?? 'Departamento não disponível',
      profilePath: json['profile_path'],
    );
  }

  String get fullProfileUrl {
    if (profilePath != null) {
      return 'https://image.tmdb.org/t/p/w185$profilePath';
    }
    return '';
  }
}

class MovieCredits {
  final List<CastMember> cast;
  final List<CrewMember> crew;

  MovieCredits({
    required this.cast,
    required this.crew,
  });

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast: (json['cast'] as List? ?? [])
          .map((castJson) => CastMember.fromJson(castJson))
          .toList(),
      crew: (json['crew'] as List? ?? [])
          .map((crewJson) => CrewMember.fromJson(crewJson))
          .toList(),
    );
  }

  List<CrewMember> get directors {
    return crew.where((member) => member.job == 'Director').toList();
  }

  List<CrewMember> get producers {
    return crew.where((member) => member.job == 'Producer').toList();
  }

  List<CrewMember> get writers {
    return crew.where((member) => 
        member.job.contains('Writer') || 
        member.job.contains('Screenplay') ||
        member.job.contains('Story')).toList();
  }
}
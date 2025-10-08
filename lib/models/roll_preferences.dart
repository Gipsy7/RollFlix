class RollPreferences {
  final int? minYear;
  final int? maxYear;
  final bool excludeWatched;
  final List<String> excludedGenres;
  final String sortBy; // 'rating', 'popularity', 'random'
  final String? ageRating; // 'G', 'PG', 'PG-13', 'R', 'NC-17', null (qualquer)

  const RollPreferences({
    this.minYear,
    this.maxYear,
    this.excludeWatched = false,
    this.excludedGenres = const [],
    this.sortBy = 'random',
    this.ageRating,
  });

  RollPreferences copyWith({
    int? minYear,
    int? maxYear,
    bool? excludeWatched,
    List<String>? excludedGenres,
    String? sortBy,
    String? ageRating,
  }) {
    return RollPreferences(
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      excludeWatched: excludeWatched ?? this.excludeWatched,
      excludedGenres: excludedGenres ?? this.excludedGenres,
      sortBy: sortBy ?? this.sortBy,
      ageRating: ageRating ?? this.ageRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minYear': minYear,
      'maxYear': maxYear,
      'excludeWatched': excludeWatched,
      'excludedGenres': excludedGenres,
      'sortBy': sortBy,
      'ageRating': ageRating,
    };
  }

  factory RollPreferences.fromJson(Map<String, dynamic> json) {
    return RollPreferences(
      minYear: json['minYear'],
      maxYear: json['maxYear'],
      excludeWatched: json['excludeWatched'] ?? false,
      excludedGenres: List<String>.from(json['excludedGenres'] ?? []),
      sortBy: json['sortBy'] ?? 'random',
      ageRating: json['ageRating'],
    );
  }

  bool get hasFilters {
    return minYear != null ||
        maxYear != null ||
        excludeWatched ||
        excludedGenres.isNotEmpty ||
        ageRating != null;
  }
}

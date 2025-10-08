class RollPreferences {
  final int? minYear;
  final int? maxYear;
  final bool excludeWatched;
  final List<String> excludedGenres;
  final String sortBy; // 'rating', 'popularity', 'random'
  final bool allowAdult; // true = permite +18, false = apenas conteúdo não-adulto

  const RollPreferences({
    this.minYear,
    this.maxYear,
    this.excludeWatched = false,
    this.excludedGenres = const [],
    this.sortBy = 'random',
    this.allowAdult = true, // Por padrão permite tudo
  });

  RollPreferences copyWith({
    int? minYear,
    int? maxYear,
    bool? excludeWatched,
    List<String>? excludedGenres,
    String? sortBy,
    bool? allowAdult,
  }) {
    return RollPreferences(
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      excludeWatched: excludeWatched ?? this.excludeWatched,
      excludedGenres: excludedGenres ?? this.excludedGenres,
      sortBy: sortBy ?? this.sortBy,
      allowAdult: allowAdult ?? this.allowAdult,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minYear': minYear,
      'maxYear': maxYear,
      'excludeWatched': excludeWatched,
      'excludedGenres': excludedGenres,
      'sortBy': sortBy,
      'allowAdult': allowAdult,
    };
  }

  factory RollPreferences.fromJson(Map<String, dynamic> json) {
    return RollPreferences(
      minYear: json['minYear'],
      maxYear: json['maxYear'],
      excludeWatched: json['excludeWatched'] ?? false,
      excludedGenres: List<String>.from(json['excludedGenres'] ?? []),
      sortBy: json['sortBy'] ?? 'random',
      allowAdult: json['allowAdult'] ?? true,
    );
  }

  bool get hasFilters {
    return minYear != null ||
        maxYear != null ||
        excludeWatched ||
        excludedGenres.isNotEmpty ||
        !allowAdult; // Considera como filtro se NÃO permite adulto
  }
}

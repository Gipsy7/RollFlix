// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'RollFlix';

  @override
  String get cancel => 'Cancelar';

  @override
  String get watchAd => 'Ver Anuncio';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get clear => 'Limpiar';

  @override
  String get watchAdConfirmTitle => '¿Ver un anuncio para obtener un recurso?';

  @override
  String get watchAdConfirmBody => 'Ver un anuncio te otorgará una recarga de recurso.';

  @override
  String resourceCount(Object uses, Object maxUses, Object resource) {
    return 'Tienes $uses/$maxUses $resource disponibles.';
  }

  @override
  String get testNotification => 'Probar Notificación';

  @override
  String get rollAndChill => 'Roll and Chill';

  @override
  String get welcome => '¡Bienvenido!';

  @override
  String get loginToAccess => 'Inicia sesión para acceder a la aplicación';

  @override
  String get connectingGoogle => 'Conectando con Google...';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get loginTerms => 'Al iniciar sesión, aceptas nuestros\nTérminos de Uso y Política de Privacidad';

  @override
  String loginError(Object error) {
    return 'Error al iniciar sesión con Google: $error';
  }

  @override
  String get settings => 'Configuraciones';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get receiveReleaseNotifications => 'Recibir notificaciones sobre lanzamientos';

  @override
  String get movieReleases => 'Lanzamientos de películas';

  @override
  String get notifyFavoriteMovieReleases => 'Notificar cuando se lancen películas favoritas';

  @override
  String get newEpisodes => 'Nuevos episodios';

  @override
  String get notifyFavoriteShowEpisodes => 'Notificar sobre episodios de series favoritas';

  @override
  String get backgroundExecution => 'Ejecución en segundo plano';

  @override
  String get automaticChecks => 'Verificaciones automáticas';

  @override
  String get every6HoursEvenClosed => 'Cada 6 horas, incluso con app cerrada';

  @override
  String get active => 'ACTIVO';

  @override
  String get testsMaintenance => 'Pruebas y Mantenimiento';

  @override
  String get sendTestNotification => 'Enviar notificación de prueba';

  @override
  String get clearSendHistory => 'Limpiar historial de envíos';

  @override
  String get allowResendNotifications => 'Permitir reenvío de notificaciones';

  @override
  String get clearHistory => 'Limpiar Historial';

  @override
  String get clearHistoryConfirm => '¿Realmente quieres limpiar todo el historial de notificaciones? Esta acción no se puede deshacer.';

  @override
  String get understood => 'Entendido';

  @override
  String get settingsSaved => 'Configuraciones guardadas exitosamente';

  @override
  String settingsSaveError(Object error) {
    return 'Error al guardar configuraciones: $error';
  }

  @override
  String get sendHistoryCleared => 'Historial de envíos limpiado exitosamente';

  @override
  String get testNotificationSent => '¡Notificación de prueba enviada!';

  @override
  String get notificationTestTitle => 'Prueba de Notificación';

  @override
  String get notificationTestBody => '¡Si estás viendo esto, las notificaciones funcionan! 🎉';

  @override
  String get backgroundInfoTitle => 'Cómo funciona:';

  @override
  String get backgroundInfoContent => '• Verificaciones automáticas cada 6 horas\n• Funciona incluso con app cerrada\n• Requiere conexión a internet\n• No ejecuta con batería baja\n• Sistema gestionado por Android';

  @override
  String get performanceTitle => 'Rendimiento:';

  @override
  String get performanceContent => '• Máximo 4 verificaciones por día\n• Solo verifica favoritos nuevos\n• Ahorro de 90% de batería\n• 96% menos llamadas a la API';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get portuguese => 'Portugués';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get languageChanged => 'Idioma cambiado exitosamente';

  @override
  String get restartApp => 'Reinicia la aplicación para que los cambios tengan efecto';

  @override
  String get cannotOpenLink => 'No se pudo abrir el enlace';

  @override
  String get errorOpeningLink => 'Error al abrir el enlace';

  @override
  String get watchTrailer => 'Ver Trailer';

  @override
  String get synopsis => 'Sinopsis';

  @override
  String get synopsisNotAvailable => 'Sinopsis no disponible.';

  @override
  String get direction => 'Dirección:';

  @override
  String get mainCast => 'Reparto Principal';

  @override
  String get videos => 'Videos';

  @override
  String get whereToWatch => 'Dónde Ver';

  @override
  String get streamingIncluded => 'Streaming (Incluido en la suscripción):';

  @override
  String get rent => 'Alquiler:';

  @override
  String get buy => 'Comprar:';

  @override
  String get streamingInfoNotAvailable => 'Información de streaming no disponible en este momento.';

  @override
  String get soundtrack => 'Banda Sonora';

  @override
  String get themeSong => 'Canción Tema';

  @override
  String get by => 'por';

  @override
  String get spotify => 'Spotify';

  @override
  String get youtube => 'YouTube';

  @override
  String get completePlaylist => 'Lista Completa';

  @override
  String get spotifyPlaylist => 'Lista en Spotify';

  @override
  String get youtubePlaylist => 'Lista en YouTube';

  @override
  String get genresLabel => 'Géneros';

  @override
  String get discoverMore => 'Descubre más películas geniales en RollFlix!';

  @override
  String get trailerNotAvailable => 'Trailer no disponible';

  @override
  String get shareTooltip => 'Compartir película';

  @override
  String get markAsWatched => 'Marcar como visto';

  @override
  String get markAsUnwatched => 'Marcar como no visto';

  @override
  String get removedFromWatched => 'Eliminado de vistos';

  @override
  String get markedAsWatched => 'Marcado como visto';

  @override
  String get errorLoadingDetails => 'Error al cargar detalles de la película';

  @override
  String get errorLoadingTVShowDetails => 'Error al cargar detalles de la serie';

  @override
  String get errorLoadingInitialData => 'Error al cargar datos iniciales';

  @override
  String get selectGenreFirst => 'Selecciona un género primero';

  @override
  String get rollError => 'No se pudo realizar el sorteo. Inténtalo de nuevo.';

  @override
  String get noSeriesFound => 'No se encontró ninguna serie para este filtro. Inténtalo de nuevo.';

  @override
  String get noMovieFound => 'No se encontró ninguna película para este filtro. Inténtalo de nuevo.';

  @override
  String get removedFromFavorites => 'Removido de favoritos';

  @override
  String addedToFavorites(Object title) {
    return '❤️ $title añadido a favoritos';
  }

  @override
  String allItemsRemoved(Object contentType) {
    return 'Todos los $contentType han sido eliminados';
  }

  @override
  String get searchError => 'Error al buscar series';

  @override
  String get favorites => 'Favoritos';

  @override
  String get watched => 'Visto';

  @override
  String get movies => 'Películas';

  @override
  String get series => 'Series';

  @override
  String get seriesUpper => 'SERIES';

  @override
  String get moviesUpper => 'PELÍCULAS';

  @override
  String get seriesLower => 'series';

  @override
  String get moviesLower => 'películas';

  @override
  String get removeFromWatched => 'Eliminar de vistos';

  @override
  String get removeFromWatchedQuestion => '¿Eliminar de vistos?';

  @override
  String confirmRemoveWatched(Object title) {
    return '¿Estás seguro de que quieres eliminar \"$title\" de la lista de vistos?';
  }

  @override
  String get clearAllWatched => '¿Limpiar todos los vistos?';

  @override
  String confirmClearAllWatched(Object contentType, Object count) {
    return '¿Estás seguro de que quieres eliminar todas las $count $contentType vistas?';
  }

  @override
  String get prioritizeHighRated => 'Prioriza películas con mayor calificación';

  @override
  String get prioritizePopular => 'Prioriza películas más conocidas';

  @override
  String get excludeWatched => 'Excluir ya vistas';

  @override
  String get excludeWatchedDescription => 'No muestra contenido ya marcado como visto';

  @override
  String get notificationDescription => 'Configura cuándo deseas recibir notificaciones sobre tus películas y series favoritas.';

  @override
  String get movieReleasesTitle => '🎬 Lanzamientos de Películas';

  @override
  String get movieReleasesSubtitle => 'Notificar cuando películas favoritas sean lanzadas';

  @override
  String get newEpisodesTitle => '📺 Nuevos Episodios';

  @override
  String get newEpisodesSubtitle => 'Notificar sobre nuevos episodios de series favoritas';

  @override
  String get close => 'Cerrar';

  @override
  String get searchSeries => 'Buscar Series';

  @override
  String get seriesMode => 'SERIES';

  @override
  String get movieMode => 'Modo: Películas';

  @override
  String get switchToSeries => 'Cambiar a Series';

  @override
  String get switchToMovies => 'Cambiar a Películas';

  @override
  String get loadingMovies => 'Cargando películas...';

  @override
  String get shareSeriesText => '🍿 ¡Descubre más series increíbles en RollFlix!';

  @override
  String get typeToSearchSeries => 'Escribe algo para buscar series';

  @override
  String initialGenreSelected(Object genre) {
    return 'Género inicial seleccionado: $genre';
  }

  @override
  String errorInitializingApp(Object error) {
    return 'Error al inicializar app: $error';
  }

  @override
  String modeChangedTo(Object mode) {
    return 'Modo cambiado a: $mode';
  }

  @override
  String modeSetTo(Object mode) {
    return 'Modo establecido a: $mode';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get addToFavorites => 'Agregar a favoritos';

  @override
  String get removeFromFavorites => 'Remover de favoritos';

  @override
  String get markAsNotWatched => 'Marcar como no visto';

  @override
  String get addToFavoritesTooltip => 'Agregar a favoritos';

  @override
  String get removeFromFavoritesTooltip => 'Eliminar de favoritos';

  @override
  String get clearAllTooltip => 'Limpiar todo';

  @override
  String get rollPreferencesTitle => 'Preferencias de Rol';

  @override
  String chooseGenre(Object contentType) {
    return 'Elige un Género de $contentType';
  }

  @override
  String get rolling => 'Rodando...';

  @override
  String get rollNewSeries => 'Rodar Nueva Serie';

  @override
  String get rollNewMovie => 'Rodar Nueva Película';

  @override
  String get rollSeries => 'Rodar Serie';

  @override
  String get rollMovie => 'Rodar Película';

  @override
  String get releasePeriod => 'Período de Lanzamiento';

  @override
  String get sortBy => 'Ordenar Por';

  @override
  String get contentRating => 'Clasificación de Contenido';

  @override
  String get otherOptions => 'Otras Opciones';

  @override
  String get apply => 'Aplicar';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get any => 'Cualquiera';

  @override
  String get clearPeriod => 'Limpiar período';

  @override
  String get selectInitialYear => 'Seleccionar Año Inicial';

  @override
  String get selectFinalYear => 'Seleccionar Año Final';

  @override
  String get random => 'Aleatorio';

  @override
  String get randomDescription => 'Orden completamente aleatorio';

  @override
  String get bestRated => 'Mejor Valorados';

  @override
  String get mostPopular => 'Más Populares';

  @override
  String get allowAdultContent => 'Permitir contenido +18';

  @override
  String get showAllContent => 'Mostrar todo tipo de contenido';

  @override
  String get onlyNonAdultContent => 'Solo contenido no adulto';

  @override
  String get activeNotifications => 'Notificaciones Activas';

  @override
  String get activeNotificationsDescription => 'Activar/desactivar todas las notificaciones';

  @override
  String get testNotificationHint => 'Toca para enviar una notificación de prueba';

  @override
  String get home => 'Inicio';

  @override
  String get searchMovies => 'Buscar Películas';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get discoverAmazingSeries => 'Descubre series increíbles';

  @override
  String get dateNight => 'Noche de Cita';

  @override
  String get dateNightComingSoon => '¡Date Night en desarrollo!\nPróximamente disponible 🚀';

  @override
  String get clearCache => 'Limpiar Caché';

  @override
  String get cacheCleared => '¡Caché de películas y recetas limpiado!';

  @override
  String get aboutApp => 'Acerca de la App';

  @override
  String get notificationHistory => 'Historial de Notificaciones';

  @override
  String get version => 'Versión';

  @override
  String get whatIsRollflix => '¿Qué es Rollflix?';

  @override
  String get whatIsRollflixDescription => 'Aplicación para descubrir películas y series aleatorias por género. ¡Elige entre más de 18 géneros diferentes y encuentra tu próximo entretenimiento!';

  @override
  String get availableFeatures => 'Características Disponibles';

  @override
  String get movieSeriesRoller => 'Sorteador de Películas y Series';

  @override
  String get movieSeriesRollerDescription => 'Descubre tu próximo entretenimiento de forma aleatoria';

  @override
  String get genresAvailable => '18+ Géneros Disponibles';

  @override
  String get genresAvailableDescription => 'Acción, comedia, terror, romance, ciencia ficción y mucho más';

  @override
  String get smartNotifications => 'Notificaciones Inteligentes';

  @override
  String get smartNotificationsDescription => 'Mantente al día con los lanzamientos de tus favoritos';

  @override
  String get favoritesSystem => 'Sistema de Favoritos';

  @override
  String get favoritesSystemDescription => 'Guarda y sigue tus películas y series favoritas';

  @override
  String get movieSeriesMode => 'Modo Películas y Series';

  @override
  String get movieSeriesModeDescription => 'Cambia fácilmente entre películas y series';

  @override
  String get inDevelopment => '🚀 En Desarrollo';

  @override
  String get newFeaturesComing => 'Nuevas características que se están desarrollando y estarán disponibles pronto:';

  @override
  String get movieQuiz => 'Quiz de Películas';

  @override
  String get movieQuizDescription => 'Pon a prueba tus conocimientos de cine con preguntas desafiantes';

  @override
  String get dateNightDescription => 'Encuentra la película o serie perfecta para ver juntos';

  @override
  String get soundtrackQuiz => 'Quiz de Banda Sonora';

  @override
  String get soundtrackQuizDescription => 'Adivina la película o serie por la música';

  @override
  String get technologies => 'Tecnologías';

  @override
  String get developedWithFlutter => 'Desarrollado con Flutter';

  @override
  String get copyright => '2025 Rollflix';

  @override
  String get allRightsReserved => 'Todos los derechos reservados';

  @override
  String get comingSoon => 'PRÓXIMAMENTE';

  @override
  String get noWatchedItems => 'Ningún elemento visto';

  @override
  String markWatchedHint(Object contentType) {
    return 'Marca las $contentType que ya has visto para verlas aquí';
  }

  @override
  String get seriesLabel => 'Serie';

  @override
  String get movieLabel => 'Película';

  @override
  String get watchedToday => 'Visto hoy';

  @override
  String get watchedYesterday => 'Visto ayer';

  @override
  String watchedDaysAgo(Object days) {
    return 'Visto hace $days días';
  }

  @override
  String watchedWeeksAgo(Object weeks, Object weekWord) {
    return 'Visto hace $weeks $weekWord';
  }

  @override
  String watchedMonthsAgo(Object months, Object monthWord) {
    return 'Visto hace $months $monthWord';
  }

  @override
  String watchedYearsAgo(Object years, Object yearWord) {
    return 'Visto hace $years $yearWord';
  }

  @override
  String get week => 'semana';

  @override
  String get weeks => 'semanas';

  @override
  String get month => 'mes';

  @override
  String get months => 'meses';

  @override
  String get year => 'año';

  @override
  String get years => 'años';

  @override
  String get clearAll => 'Limpiar todos';

  @override
  String get myFavorites => 'Mis Favoritos';

  @override
  String get loadingFavorites => 'Cargando favoritos...';

  @override
  String get noFavoritesYet => 'Ningún favorito aún';

  @override
  String addToFavoritesHint(Object contentType) {
    return '¡Agrega $contentType a favoritos\npara verlos aquí!';
  }

  @override
  String get removeFavorite => '¿Remover favorito?';

  @override
  String confirmRemoveFavorite(Object title) {
    return '¿Quieres remover \"$title\" de favoritos?';
  }

  @override
  String noFavoritesToClear(Object contentType) {
    return 'No hay $contentType favoritos para limpiar';
  }

  @override
  String get clearAllFavorites => '¿Limpiar todos los favoritos?';

  @override
  String confirmClearAllFavorites(Object contentType, Object count) {
    return 'Todos los $count $contentType favoritos serán removidos. Esta acción no se puede deshacer.';
  }

  @override
  String allFavoritesCleared(Object contentType) {
    return 'Todos los $contentType favoritos han sido removidos';
  }

  @override
  String get logoutConfirmTitle => '¿Salir de la cuenta?';

  @override
  String get logoutConfirmMessage => 'Serás desconectado y necesitarás iniciar sesión nuevamente.';

  @override
  String get logout => 'Salir';

  @override
  String logoutError(Object error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get loadingProfile => 'Cargando perfil...';

  @override
  String get logoutButton => 'Salir de la Cuenta';

  @override
  String get rolls => 'Sorteos';

  @override
  String get searchHint => 'Escribe el nombre de la película o serie...';

  @override
  String get searchMoviesError => 'Error al buscar películas';

  @override
  String get searchingMovies => 'Buscando películas...';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get tryDifferentKeywords => 'Intenta buscar con otras palabras clave';

  @override
  String get noMoviesFound => 'No se encontraron películas';

  @override
  String get loadingMoreResults => 'Cargando más resultados...';

  @override
  String get tapPlusOne => 'Toca +1';

  @override
  String get watchAdForExtraResource => '¡Mira un anuncio corto y obtén +1 recurso extra!';

  @override
  String get appVersion => 'Versión 4.0.0';

  @override
  String get basicInfo => 'Información Básica';

  @override
  String get biography => 'Biografía';

  @override
  String get filmography => 'Filmografía';

  @override
  String get filmographyAsDirector => 'Filmografía como Director';

  @override
  String errorLoadingHistory(Object error) {
    return 'Error al cargar el historial';
  }

  @override
  String get historyCleared => 'Historial limpiado exitosamente';

  @override
  String get noNotifications => 'No hay notificaciones';

  @override
  String get notificationHint => 'Serás notificado cuando haya nuevos lanzamientos de tus favoritos';

  @override
  String get firstAirDate => 'Primera emisión:';

  @override
  String get cast => 'Reparto';

  @override
  String get crew => 'Equipo';

  @override
  String get screenplay => 'Guión:';

  @override
  String get trailers => 'Tráilers';

  @override
  String get user => 'Usuario';

  @override
  String get accountInfo => 'Información de la Cuenta';

  @override
  String get userId => 'ID de Usuario';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get findYourNextFavoriteMovie => 'Encuentra tu próxima película favorita';

  @override
  String get heroes => 'Héroes';

  @override
  String get chooseGenreOf => 'Elige un Género de';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'No Disponible';

  @override
  String get dateNightPreferences => 'Preferencias de Cita Nocturna';

  @override
  String get customizeYourExperience => 'Personaliza Tu Experiencia';

  @override
  String get configurePreferencesForPersonalizedSuggestions => 'Configura tus preferencias para sugerencias personalizadas';

  @override
  String get dietaryRestrictions => 'Restricciones Alimentarias';

  @override
  String get budget => 'Presupuesto';

  @override
  String get preparationTime => 'Tiempo de Preparación';

  @override
  String get culinaryLevel => 'Nivel Culinario';

  @override
  String get drinkPreferences => 'Preferencias de Bebidas';

  @override
  String get ingredientsToAvoid => 'Ingredientes a Evitar';

  @override
  String get restoreDefault => 'Restaurar Predeterminado';

  @override
  String get savePreferences => 'Guardar Preferencias';

  @override
  String get includeAlcoholicBeverages => 'Incluir bebidas alcohólicas';

  @override
  String get suggestionsWillIncludeWinesAndDrinks => 'Las sugerencias incluirán vinos y bebidas';

  @override
  String get onlyNonAlcoholicBeverages => 'Solo bebidas no alcohólicas';

  @override
  String get selectIngredientsToAvoid => 'Selecciona ingredientes que deseas evitar:';

  @override
  String get preferencesRestoredToDefault => 'Preferencias restauradas a predeterminado';

  @override
  String get preferencesSavedSuccessfully => '¡Preferencias guardadas exitosamente!';

  @override
  String recipeReady(Object title) {
    return '⏰ ¡$title está listo!';
  }

  @override
  String get next => 'Siguiente';

  @override
  String get recipeLoadError => 'No se pudo cargar la receta. Inténtalo de nuevo.';

  @override
  String get adNotAvailable => 'Anuncio no disponible en este momento. Inténtalo de nuevo en unos momentos.';

  @override
  String get preferencesCleared => 'Preferencias limpiadas';

  @override
  String get shareSeries => 'Compartir serie';

  @override
  String get preferences => 'Preferencias';

  @override
  String get changeMeal => 'Cambiar comida';

  @override
  String get movieTab => 'Película';

  @override
  String get mealTab => 'Comida';

  @override
  String get checklistTab => 'Lista de verificación';

  @override
  String get romanticDate => '💕 Cita Romántica';

  @override
  String get casualDate => '🍿 Cita Casual';

  @override
  String get elegantDate => '🥂 Cita Elegante';

  @override
  String get funDate => '🎉 Cita Divertida';

  @override
  String get cozyDate => '🏠 Cita Acogedora';

  @override
  String get dateDetails => '🌟 Detalles de la Cita';

  @override
  String get releaseLabel => 'Lanzamiento:';

  @override
  String get durationLabel => 'Duración:';

  @override
  String get defaultMovieOverview => 'Una historia romántica emocionante que hará tu noche aún más especial.';

  @override
  String get technicalInfo => 'Información Técnica';

  @override
  String get productionLabel => 'Producción:';

  @override
  String get checklistHint => '¡Marca los artículos a medida que los agregas al carrito!';

  @override
  String get intimateQuestionsGame => '20 Preguntas Íntimas';

  @override
  String get intimateQuestionsDesc => 'Conozcan mejor el uno al otro con preguntas profundas y divertidas';

  @override
  String get easy => 'Fácil';

  @override
  String get romanticTruthOrDare => 'Verdad o Reto Romántico';

  @override
  String get romanticTruthOrDareDesc => 'Versión romántica del juego clásico';

  @override
  String get medium => 'Medio';

  @override
  String get cookingBattle => 'Batalla de Cocina';

  @override
  String get cookingBattleDesc => 'Competencia amistosa para preparar un plato';

  @override
  String get loserDoesDishes => '¡El perdedor lava los platos!';

  @override
  String get advanced => 'Avanzado';

  @override
  String get coupleQuizDesc => 'Prueba cuánto se conocen';

  @override
  String get dreamsAndAspirations => 'Sueños y Aspiraciones';

  @override
  String get dreamLocationQuestion => '¿Si pudieras vivir en cualquier lugar del mundo, dónde sería?';

  @override
  String get professionalDreamQuestion => '¿Cuál es tu mayor sueño profesional?';

  @override
  String get servingsUnit => 'porciones';

  @override
  String get nutritionalInfo => 'Información Nutricional';

  @override
  String get protein => 'Proteína';

  @override
  String get adultFilter => '🔞 Solo no adultos';

  @override
  String get preferencesApplied => '¡Preferencias aplicadas!';

  @override
  String get moviesMode => 'PELÍCULAS';

  @override
  String get rollGenre => 'Rodar Género';

  @override
  String seriesRolled(Object count) {
    return 'Serie $count rodada';
  }

  @override
  String movieRolled(Object count) {
    return 'Película $count rodada';
  }

  @override
  String get tryDifferentGenre => 'Intenta seleccionar un género diferente o recarga la página.';

  @override
  String get players => 'jugadores';

  @override
  String get minutes => 'min';

  @override
  String get rules => 'Reglas';

  @override
  String get questions => 'preguntas';

  @override
  String get interestingQuestions => 'Preguntas interesantes para conocerse mejor el uno al otro';

  @override
  String get conversationStarters => 'Iniciadores de Conversación';

  @override
  String get dateNightGames => 'Juegos para la Cita';

  @override
  String get makeNightFun => 'Haz la noche más divertida y memorable';
}

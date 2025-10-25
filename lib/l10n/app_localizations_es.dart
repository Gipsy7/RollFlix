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
  String get tryAgain => 'Intentar de Nuevo';

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
  String rollAndChillWithMode(Object mode) {
    return 'Roll and Chill • $mode';
  }

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
  String get shareTooltip => 'Compartir';

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
  String get noSeriesFound => 'No se encontraron series';

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
  String get watched => 'Vistos';

  @override
  String get movies => 'Películas';

  @override
  String get series => 'SERIES';

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
  String get findYourNextFavoriteSeries => 'Encuentra tu próxima serie favorita';

  @override
  String get noPopularSeriesFound => 'No se encontraron series populares';

  @override
  String initialGenreSelected(Object genre) {
    return 'Género inicial seleccionado: $genre';
  }

  @override
  String get newMovieSelected => '✅ ¡Nueva película seleccionada!';

  @override
  String get newMenuSelected => '✅ ¡Nuevo menú seleccionado!';

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
  String get dateNight => 'Noche de Cita 🚧';

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
  String get rolls => 'Tiradas';

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
  String watchAdForExtraResource(Object resource) {
    return '¡Mira un anuncio corto y gana +1 $resource extra!';
  }

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
  String get aboutTheDish => 'Sobre el Plato';

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
  String get cookingBattle => 'Batalla Culinaria';

  @override
  String get cookingBattleDesc => 'Competencia amigable para preparar un plato';

  @override
  String get loserDoesDishes => '¡El perdedor lava los platos!';

  @override
  String get advanced => 'Avanzado';

  @override
  String get coupleQuizDesc => 'Prueba cuánto se conocen';

  @override
  String get dreamsAndAspirations => 'Sueños y Aspiraciones';

  @override
  String get dreamLocationQuestion => 'Si pudieras vivir en cualquier lugar del mundo, ¿dónde sería?';

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
  String get tryDifferentGenre => 'Intenta seleccionar un género diferente o recargar la página.';

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
  String get movieGenreQuestion => 'Si tu vida fuera una película, ¿cuál sería el género?';

  @override
  String get dateNightGames => 'Juegos para la Cita';

  @override
  String get gamesAndActivities => 'Juegos y Actividades';

  @override
  String get makeNightFun => 'Haz la noche más divertida y memorable';

  @override
  String get season => 'temporada';

  @override
  String get seasons => 'temporadas';

  @override
  String get episode => 'episodio';

  @override
  String get episodes => 'episodios';

  @override
  String get genres => 'Géneros';

  @override
  String get newEpisodeAvailable => '¡Nuevo Episodio Disponible!';

  @override
  String get newEpisodeOf => 'Nuevo episodio de';

  @override
  String get earnExtraResource => 'Ganar Recurso Extra';

  @override
  String noResourceAvailable(Object resource) {
    return 'No tienes $resource disponible.';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String errorChangingMovie(Object error) {
    return 'Error cambiando película: $error';
  }

  @override
  String errorChangingMenu(Object error) {
    return 'Error cambiando menú: $error';
  }

  @override
  String errorSharing(Object error) {
    return 'Error compartiendo: $error';
  }

  @override
  String errorOpeningDetails(Object error) {
    return 'Error abriendo detalles: $error';
  }

  @override
  String get selectDateNightType => 'Selecciona un tipo de cita primero';

  @override
  String get noMoviesForDateNight => 'No se encontraron películas para este tipo de cita';

  @override
  String errorGeneratingDateNight(Object error) {
    return 'Error generando cita: $error';
  }

  @override
  String get seriesType => 'SERIE';

  @override
  String get movieType => 'PELÍCULA';

  @override
  String get reminderType => 'RECORDATORIO';

  @override
  String get otherType => 'OTRO';

  @override
  String get coupleQuizRule1 => 'Escriban respuestas sobre el otro';

  @override
  String get coupleQuizRule2 => 'Comparen las respuestas';

  @override
  String get coupleQuizRule3 => 'Ganen puntos por aciertos';

  @override
  String get coupleQuizRule4 => '¡Descubran cosas nuevas!';

  @override
  String get movieMimicRule1 => 'Uno hace mímica, el otro adivina';

  @override
  String get movieMimicRule2 => '¡Sin palabras!';

  @override
  String get movieMimicRule3 => 'Tiempo límite: 1 minuto por película';

  @override
  String get searchSeriesHint => 'Ingresa el nombre de la serie...';

  @override
  String get searchSeriesPrompt => 'Escribe algo para buscar series';

  @override
  String get trending => 'Tendencias';

  @override
  String get topRated => 'Mejor Valoradas';

  @override
  String get all => 'Todas';

  @override
  String get searchTVHint => 'Buscar series...';

  @override
  String get noSeriesAvailable => 'No hay series disponibles';

  @override
  String get reloading => 'Recargando';

  @override
  String get trendingTab => 'Tendencias';

  @override
  String get topRatedTab => 'Mejor Valoradas';

  @override
  String get tapForDetails => 'Toca para detalles';

  @override
  String get tapForMoreDetails => 'Toca para más detalles';

  @override
  String get recipeUnavailable => 'Receta No Disponible';

  @override
  String get calories => 'Calorías';

  @override
  String get carbohydrates => 'Carbohidratos';

  @override
  String get fat => 'Grasa';

  @override
  String get quick => 'Rápido';

  @override
  String get mediumTime => 'Medio';

  @override
  String get elaborate => 'Elaborado';

  @override
  String get gourmet => 'Gourmet';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advancedSkill => 'Avanzado';

  @override
  String get expert => 'Experto';

  @override
  String get beginnerDesc => 'Recetas simples y directas';

  @override
  String get intermediateDesc => 'Se requiere algo de experiencia';

  @override
  String get advancedDesc => 'Técnicas más complejas';

  @override
  String get expertDesc => 'Alta gastronomía';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get difficultyLabel => 'Dificultad';

  @override
  String get preparationTimePrefix => '⏱️ Tiempo de Preparación:';

  @override
  String get difficultyPrefix => '📊 Dificultad:';

  @override
  String get genreNovidades => 'Novedades';

  @override
  String get genreAcao => 'Acción';

  @override
  String get genreAventura => 'Aventura';

  @override
  String get genreAnimacao => 'Animación';

  @override
  String get genreComedia => 'Comedia';

  @override
  String get genreCrime => 'Crimen';

  @override
  String get genreDocumentario => 'Documental';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreFamilia => 'Familia';

  @override
  String get genreFantasia => 'Fantasía';

  @override
  String get genreHistoria => 'Historia';

  @override
  String get genreTerror => 'Terror';

  @override
  String get genreMusica => 'Música';

  @override
  String get genreMisterio => 'Misterio';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreFiccaoCientifica => 'Ciencia Ficción';

  @override
  String get genreSuspense => 'Suspense';

  @override
  String get genreGuerra => 'Guerra';

  @override
  String get genreWestern => 'Western';

  @override
  String get genreFavoritos => 'Favoritos';

  @override
  String get genreAssistidos => 'Vistos';

  @override
  String get tvGenreNovidades => 'Novedades';

  @override
  String get tvGenreAcaoAventura => 'Acción y Aventura';

  @override
  String get tvGenreAnimacao => 'Animación';

  @override
  String get tvGenreComedia => 'Comedia';

  @override
  String get tvGenreCrime => 'Crimen';

  @override
  String get tvGenreDocumentario => 'Documental';

  @override
  String get tvGenreDrama => 'Drama';

  @override
  String get tvGenreFamilia => 'Familia';

  @override
  String get tvGenreInfantil => 'Infantil';

  @override
  String get tvGenreMisterio => 'Misterio';

  @override
  String get tvGenreNovela => 'Telenovela';

  @override
  String get tvGenreFiccaoCientificaFantasia => 'Ciencia Ficción y Fantasía';

  @override
  String get tvGenreTalkShow => 'Programa de Entrevistas';

  @override
  String get tvGenreGuerraPolitica => 'Guerra y Política';

  @override
  String get tvGenreWestern => 'Western';

  @override
  String get tvGenreReality => 'Reality';

  @override
  String get tvGenreFavoritos => 'Favoritos';

  @override
  String get tvGenreAssistidos => 'Vistos';

  @override
  String get memoriesAndExperiences => 'Recuerdos y Experiencias';

  @override
  String get tastesAndPreferences => 'Gustos y Preferencias';

  @override
  String get funAndImagination => 'Diversión e Imaginación';

  @override
  String get philosophyAndValues => 'Filosofía y Valores';

  @override
  String get relationship => 'Relación';

  @override
  String get learnIn5YearsQuestion => '¿Qué te gustaría aprender en los próximos 5 años?';

  @override
  String get superpowerQuestion => 'Si pudieras tener cualquier superpoder, ¿cuál sería?';

  @override
  String get idealLifeQuestion => '¿Cómo sería tu vida ideal en 10 años?';

  @override
  String get bestChildhoodMemoryQuestion => '¿Cuál es tu mejor recuerdo de infancia?';

  @override
  String get mostMemorableTripQuestion => '¿Cuál fue el viaje más memorable que has hecho?';

  @override
  String get mostEmbarrassingMomentQuestion => '¿Cuál fue el momento más vergonzoso de tu vida?';

  @override
  String get bestGiftReceivedQuestion => '¿Cuál fue el mejor regalo que has recibido?';

  @override
  String get happiestDayQuestion => '¿Cuál fue el día más feliz de tu vida hasta ahora?';

  @override
  String get favoriteMovieQuestion => '¿Cuál es tu película favorita de todos los tiempos?';

  @override
  String get dinnerWithAnyoneQuestion => 'Si pudieras cenar con cualquier persona, viva o muerta, ¿quién sería?';

  @override
  String get comfortFoodQuestion => '¿Cuál es tu comida reconfortante?';

  @override
  String get beachOrMountainQuestion => '¿Playa o montaña? ¿Por qué?';

  @override
  String get musicThatMakesAliveQuestion => '¿Qué música te hace sentir más vivo?';

  @override
  String get superpowerNotWantedQuestion => '¿Qué superpoder NO te gustaría tener?';

  @override
  String get invisibleDayQuestion => 'Si pudieras ser invisible por un día, ¿qué harías?';

  @override
  String get movieStarNameQuestion => '¿Cuál sería tu nombre de estrella de cine?';

  @override
  String get decadeToReturnQuestion => 'Si pudieras volver a cualquier década, ¿cuál sería?';

  @override
  String get mostImportantInLifeQuestion => '¿Qué consideras más importante en la vida?';

  @override
  String get adviceToYoungerSelfQuestion => '¿Qué consejo le darías a tu yo de 10 años?';

  @override
  String get whatMakesGratefulQuestion => '¿Qué te hace sentir más agradecido?';

  @override
  String get biggestFearQuestion => '¿Cuál es tu mayor miedo?';

  @override
  String get successMeaningQuestion => '¿Qué significa el éxito para ti?';

  @override
  String get mostValuedInRelationshipQuestion => '¿Qué valoras más en una relación?';

  @override
  String get bestMemoryTogetherQuestion => '¿Cuál fue nuestro mejor recuerdo juntos?';

  @override
  String get doMoreFrequentlyQuestion => '¿Qué te gustaría que hiciéramos más frecuentemente?';

  @override
  String get feelMostLovedQuestion => '¿Cómo te sientes más amado(a)?';

  @override
  String get whereWeSeeIn5YearsQuestion => '¿Dónde nos ves en 5 años?';

  @override
  String get cookingBattleRule1 => 'Mismos ingredientes, platos diferentes';

  @override
  String get cookingBattleRule2 => 'Tiempo límite: 30 minutos';

  @override
  String get cookingBattleRule3 => 'Evalúen juntos';

  @override
  String get cookingBattleRule4 => '¡El perdedor lava los platos!';

  @override
  String get guessTheMovie => 'Adivina la Película';

  @override
  String get guessTheMovieDesc => 'Mímica de escenas de películas';

  @override
  String get buildTheStory => 'Construyan la Historia';

  @override
  String get buildTheStoryDesc => 'Creen una historia juntos';

  @override
  String get buildTheStoryRule1 => 'Uno comienza la historia';

  @override
  String get buildTheStoryRule2 => 'El otro continúa';

  @override
  String get buildTheStoryRule3 => 'Alternen cada oración';

  @override
  String get buildTheStoryRule4 => '¡Cuanto más absurdo, mejor!';

  @override
  String get alternateQuestionsRule => 'Alternen entre hacer preguntas';

  @override
  String get beHonestOpenRule => 'Sean honestos y abiertos';

  @override
  String get noJudgmentsRule => 'Sin juicios';

  @override
  String get canSkipQuestionRule => 'Pueden pasar una pregunta si quieren';

  @override
  String get chooseTruthOrDareRule => 'Elige verdad o reto';

  @override
  String get truthsMustBeSincereRule => 'Las verdades deben ser sinceras';

  @override
  String get daresMustBeCompletedRule => 'Los retos deben cumplirse';

  @override
  String get keepLightFunRule => 'Mantengan el clima ligero y divertido';

  @override
  String get whoGetsMoreRightWinsRule => 'Quien acierte más gana';

  @override
  String get jazzSmooth => 'Jazz suave';

  @override
  String get bossaNova => 'Bossa nova';

  @override
  String get romanticClassics => 'Clásicos románticos';

  @override
  String get romanticPop => 'Pop romántico';

  @override
  String get indieFolk => 'Indie folk';

  @override
  String get eightiesHits => 'Éxitos de los 80';

  @override
  String get classicalMusic => 'Música clásica';

  @override
  String get contemporaryJazz => 'Jazz contemporáneo';

  @override
  String get instrumental => 'Instrumental';

  @override
  String get spanishMusic => 'Música española';

  @override
  String get latinJazz => 'Latin jazz';

  @override
  String get musicalSoundtracks => 'Bandas sonoras musicales';

  @override
  String get softRock => 'Rock suave';

  @override
  String get romanticCountry => 'Country romántico';

  @override
  String get internationalPop => 'Pop internacional';

  @override
  String get classicRomance => 'Romance Clásico';

  @override
  String get romanticComedy => 'Comedia Romántica';

  @override
  String get romanticDrama => 'Drama Romántico';

  @override
  String get musicalRomance => 'Romance Musical';

  @override
  String get adventureRomance => 'Romance de Aventura';

  @override
  String get thrillerRomance => 'Romance de Suspenso';

  @override
  String get romanticFun => 'Diversión Romántica';

  @override
  String get elegantRomance => 'Romance Elegante';

  @override
  String get spanishPassion => 'Pasión Española';

  @override
  String get mysteryJazz => 'Jazz Misterioso';

  @override
  String get darkAmbient => 'Ambient Oscuro';

  @override
  String get intenseClassical => 'Clásico Intenso';

  @override
  String get romanticMusic => 'Música Romántica';

  @override
  String get bluesClassic => 'Blues clásico';

  @override
  String get soulfulRhythms => 'Ritmos soul';

  @override
  String get chooseStyle => 'Elige el Estilo';

  @override
  String get preparing => 'Preparando...';

  @override
  String get createPerfectDate => '💕 Crear Cita Perfecta';

  @override
  String get ready => '¡Listo!';

  @override
  String get restart => 'Reiniciar';

  @override
  String get pause => 'Pausar';

  @override
  String get start => 'Iniciar';

  @override
  String get add5Min => '+5 min';

  @override
  String get ingredientsList => 'Lista de Ingredientes';

  @override
  String get mainCourse => 'Plato Principal';

  @override
  String get dessert => 'Postre';

  @override
  String get appetizers => 'Entrantes';

  @override
  String get sideDishes => 'Acompañamientos';

  @override
  String get allIngredientsReady => '¡Todos los ingredientes listos! 🎉';

  @override
  String get item => 'elemento';

  @override
  String get items => 'elementos';

  @override
  String get dateNightSchedule => 'Cronograma de la Cita';

  @override
  String get shrimpRisotto => 'Risotto de camarones';

  @override
  String get homemadeMargheritaPizza => 'Pizza margarita casera';

  @override
  String get grilledSalmonWithAsparagus => 'Salmón a la parrilla con espárragos';

  @override
  String get valencianPaella => 'Paella valenciana';

  @override
  String get gourmetBarbecue => 'Barbacoa gourmet';

  @override
  String get wildMushroomRisotto => 'Risotto de champiñones silvestres';

  @override
  String get roseWine => 'Vino rosado';

  @override
  String get prosecco => 'Prosecco';

  @override
  String get softRedWine => 'Vino tinto suave';

  @override
  String get sangria => 'Sangría';

  @override
  String get redBerryCaipirinha => 'Caipirinha de frutas rojas';

  @override
  String get fullBodiedRedWine => 'Vino tinto corpulento';

  @override
  String get strawberriesWithChocolate => 'Fresas con chocolate';

  @override
  String get brownieWithIceCream => 'Brownie con helado';

  @override
  String get tiramisu => 'Tiramisú';

  @override
  String get cremeBrulee => 'Crème brûlée';

  @override
  String get fruitPavlova => 'Pavlova de frutas';

  @override
  String get darkChocolateCake => 'Torta de chocolate negro';

  @override
  String get specialCheeses => 'Quesos especiales';

  @override
  String get grapes => 'Uvas';

  @override
  String get nuts => 'Nueces';

  @override
  String get gourmetPopcorn => 'Palomitas gourmet';

  @override
  String get olives => 'Aceitunas';

  @override
  String get garlicBread => 'Pan de ajo';

  @override
  String get cheeseBoard => 'Tabla de quesos';

  @override
  String get artisanBreads => 'Panes artesanales';

  @override
  String get varietyTapas => 'Tapas variadas';

  @override
  String get roastedPeppers => 'Pimientos asados';

  @override
  String get cheeseSkewers => 'Pinchos de queso';

  @override
  String get sweetPotatoChips => 'Chips de batata dulce';

  @override
  String get guacamole => 'Guacamole';

  @override
  String get agedCheeses => 'Quesos curados';

  @override
  String get rusticBreads => 'Panes rústicos';

  @override
  String get blackOlives => 'Aceitunas negras';

  @override
  String get lowLightsAromaticCandles => 'Luces bajas y velas aromáticas';

  @override
  String get relaxedFunAtmosphere => 'Ambiente relajado y divertido';

  @override
  String get sophisticatedIntimate => 'Sofisticado e íntimo';

  @override
  String get vibrantMusical => 'Vibrante y musical';

  @override
  String get adventurousRelaxed => 'Aventurero y relajado';

  @override
  String get mysteriousIntense => 'Misterioso e intenso';

  @override
  String get fortyFiveMinutes => '45 minutos';

  @override
  String get thirtyMinutes => '30 minutos';

  @override
  String get fiftyMinutes => '50 minutos';

  @override
  String get sixtyMinutes => '60 minutos';

  @override
  String get fortyMinutes => '40 minutos';

  @override
  String get fiftyFiveMinutes => '55 minutos';

  @override
  String get arborioRice => 'Arroz arborio';

  @override
  String get freshShrimp => 'Camarones frescos';

  @override
  String get whiteWine => 'Vino blanco';

  @override
  String get fishBroth => 'Caldo de pescado';

  @override
  String get parmesanCheese => 'Queso parmesano';

  @override
  String get strawberries => 'Fresas';

  @override
  String get seventyPercentChocolate => 'Chocolate 70%';

  @override
  String get pizzaDough => 'Masa de pizza lista';

  @override
  String get tomatoSauce => 'Salsa de tomate';

  @override
  String get buffaloMozzarella => 'Mozzarella de búfala';

  @override
  String get freshBasil => 'Albahaca fresca';

  @override
  String get brownieMix => 'Mezcla para brownie';

  @override
  String get vanillaIceCream => 'Helado de vainilla';

  @override
  String get salmonFillet => 'Filete de salmón';

  @override
  String get freshAsparagus => 'Espárragos frescos';

  @override
  String get sicilianLemon => 'Limón siciliano';

  @override
  String get extraVirginOliveOil => 'Aceite de oliva extra virgen';

  @override
  String get tiramisuIngredients => 'Ingredientes para tiramisú';

  @override
  String get espressoCoffee => 'Café expreso';

  @override
  String get bombaRice => 'Arroz bomba';

  @override
  String get seafood => 'Mariscos';

  @override
  String get chicken => 'Pollo';

  @override
  String get saffron => 'Azafrán';

  @override
  String get peppers => 'Pimientos';

  @override
  String get redWine => 'Vino tinto';

  @override
  String get fruitsForSangria => 'Frutas para sangría';

  @override
  String get nobleMeatForBarbecue => 'Carne noble para barbacoa';

  @override
  String get specialSeasonings => 'Condimentos especiales';

  @override
  String get cachaca => 'Cachaça';

  @override
  String get redBerries => 'Frutas rojas';

  @override
  String get readyMeringue => 'Merengue listo';

  @override
  String get seasonalFruits => 'Frutas de temporada';

  @override
  String get wildMushrooms => 'Champiñones silvestres';

  @override
  String get vegetableBroth => 'Caldo de verduras';

  @override
  String get eightyFivePercentChocolate => 'Chocolate 85%';

  @override
  String get heavyCream => 'Crema espesa';

  @override
  String get stirRisottoConstantly => 'Revuelve el risotto constantemente para que quede cremoso';

  @override
  String get useFreshIngredients => 'Usa ingredientes frescos para un sabor auténtico';

  @override
  String get dontOvercookSalmon => 'No cocines demasiado el salmón para mantener la textura';

  @override
  String get useTraditionalPaellaPan => 'Usa paellera tradicional si es posible';

  @override
  String get marinateMeatForHours => 'Deja la carne marinando por varias horas';

  @override
  String get useFreshMushrooms => 'Usa champiñones frescos para mejor sabor';

  @override
  String get classicRomanceTheme => 'Romance Clásico';

  @override
  String get romanticFunTheme => 'Diversión Romántica';

  @override
  String get elegantRomanceTheme => 'Romance Elegante';

  @override
  String get spanishPassionTheme => 'Pasión Española';

  @override
  String get adventureRomanceTheme => 'Romance de Aventura';

  @override
  String get thrillerRomanceTheme => 'Romance de Suspenso';

  @override
  String get candlesWarmLED => 'Velas y luces LED cálidas';

  @override
  String get colorfulLightsCheerful => 'Luces coloridas y ambiente alegre';

  @override
  String get softLightingElegant => 'Iluminación suave y ambiente elegante';

  @override
  String get warmLightsFestive => 'Luces cálidas y atmósfera festiva';

  @override
  String get outdoorNaturalLight => 'Ambiente al aire libre o luces naturales';

  @override
  String get lowLightsDramatic => 'Luces bajas y atmósfera dramática';

  @override
  String get cost80120 => '€80-120';

  @override
  String get cost4060 => '€40-60';

  @override
  String get cost100150 => '€100-150';

  @override
  String get cost90130 => '€90-130';

  @override
  String get cost70100 => '€70-100';

  @override
  String get cost85125 => '€85-125';

  @override
  String get mushrooms => 'Champiñones';

  @override
  String get onion => 'Cebolla';

  @override
  String get garlic => 'Ajo';

  @override
  String get bellPepper => 'Pimiento';

  @override
  String get strongCheeses => 'Quesos fuertes';

  @override
  String get fish => 'Pescado';

  @override
  String get redMeat => 'Carne roja';

  @override
  String get milk => 'Leche';

  @override
  String get eggs => 'Huevos';
}

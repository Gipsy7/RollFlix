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
  String get watchAd => 'Ver anuncio';

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
  String get testNotification => 'Probar notificación';

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
  String get clearHistoryConfirm => '¿Desea limpiar el historial de notificaciones enviadas? Esto permite que las notificaciones se envíen nuevamente.';

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
  String get testNotificationSent => 'Notificación de prueba enviada';

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
  String get direction => 'Dirección';

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
  String get buy => 'Compra:';

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
  String get completePlaylist => 'Lista de Reproducción Completa';

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
  String get removedFromFavorites => 'Eliminado de favoritos';

  @override
  String get addedToFavorites => 'Añadido a favoritos';

  @override
  String get errorLoadingDetails => 'Error al cargar detalles de la película';
}

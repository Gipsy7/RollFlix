/// Modelo para representar uma notificação no histórico
class NotificationHistoryItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final String? movieId;
  final String? showId;
  final String? posterPath;
  
  NotificationHistoryItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.movieId,
    this.showId,
    this.posterPath,
  });
  
  /// Cria uma instância a partir de JSON
  factory NotificationHistoryItem.fromJson(Map<String, dynamic> json) {
    return NotificationHistoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.other,
      ),
      movieId: json['movieId'] as String?,
      showId: json['showId'] as String?,
      posterPath: json['posterPath'] as String?,
    );
  }
  
  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'movieId': movieId,
      'showId': showId,
      'posterPath': posterPath,
    };
  }
  
  /// Formata a data de forma amigável
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
  
  /// Ícone baseado no tipo
  String get icon {
    switch (type) {
      case NotificationType.movieRelease:
        return '🎬';
      case NotificationType.tvShowEpisode:
        return '📺';
      case NotificationType.reminder:
        return '⏰';
      case NotificationType.other:
        return '🔔';
    }
  }
}

/// Tipos de notificação
enum NotificationType {
  movieRelease,
  tvShowEpisode,
  reminder,
  other,
}

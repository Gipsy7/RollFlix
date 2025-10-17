import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../models/notification_history_item.dart';

/// Tela de histórico de notificações
class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final _notificationService = NotificationService.instance;
  List<NotificationHistoryItem> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    try {
      final history = await _notificationService.getNotificationHistory();
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorLoadingHistory(e.toString()))),
        );
      }
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearHistory),
        content: Text(AppLocalizations.of(context)!.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _notificationService.clearNotificationHistory();
      _loadHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.historyCleared),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationHistory),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: AppLocalizations.of(context)!.clearHistory,
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      return _buildHistoryItem(item, theme);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noNotifications,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.notificationHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(NotificationHistoryItem item, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(item.type).withOpacity(0.2),
        child: Text(
          item.icon,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            item.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                item.formattedDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(item.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTypeLabel(item.type),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(item.type),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.movieRelease:
        return const Color(0xFFE50914); // Vermelho Rollflix
      case NotificationType.tvShowEpisode:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.other:
        return Colors.blue;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.movieRelease:
        return 'FILME';
      case NotificationType.tvShowEpisode:
        return 'SÉRIE';
      case NotificationType.reminder:
        return 'LEMBRETE';
      case NotificationType.other:
        return 'OUTRO';
    }
  }
}

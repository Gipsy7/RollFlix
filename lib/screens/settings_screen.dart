import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode
import '../services/notification_service.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../controllers/locale_controller.dart';

/// Tela de configurações do aplicativo
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _notificationService = NotificationService.instance;
  
  bool _notificationsEnabled = true;
  bool _movieReleasesEnabled = true;
  bool _tvShowEpisodesEnabled = true;
  bool _isLoading = false;
  String _selectedLanguage = 'pt'; // Default to Portuguese

  @override
  void initState() {
    super.initState();
    _loadSettings();
    // Initialize selected language from LocaleController
    _selectedLanguage = LocaleController.instance.locale?.languageCode ?? 'pt';
  }

  void _loadSettings() {
    setState(() {
      _notificationsEnabled = _notificationService.notificationsEnabled;
      _movieReleasesEnabled = _notificationService.movieReleasesEnabled;
      _tvShowEpisodesEnabled = _notificationService.tvShowEpisodesEnabled;
    });
  }

  Future<void> _updateSettings() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.updateSettings(
        notificationsEnabled: _notificationsEnabled,
        movieReleasesEnabled: _movieReleasesEnabled,
        tvShowEpisodesEnabled: _tvShowEpisodesEnabled,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsSaved),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsSaveError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearNotificationHistory() async {
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
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _notificationService.clearSentNotificationsHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sendHistoryCleared),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _testNotification() async {
    await _notificationService.showTestNotification(
      title: AppLocalizations.of(context)!.notificationTestTitle,
      body: AppLocalizations.of(context)!.notificationTestBody,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.testNotificationSent),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getCurrentLanguageName() {
    switch (_selectedLanguage) {
      case 'en': return AppLocalizations.of(context)!.english;
      case 'pt': return AppLocalizations.of(context)!.portuguese;
      case 'es': return AppLocalizations.of(context)!.spanish;
      case 'fr': return AppLocalizations.of(context)!.french;
      default: return AppLocalizations.of(context)!.portuguese;
    }
  }

  Future<void> _showLanguageDialog() async {
    final languages = {
      'en': AppLocalizations.of(context)!.english,
      'pt': AppLocalizations.of(context)!.portuguese,
      'es': AppLocalizations.of(context)!.spanish,
      'fr': AppLocalizations.of(context)!.french,
    };

    final selected = await showDialog<String>(
      context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.entries.map((entry) => RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: _selectedLanguage,
              onChanged: (value) => Navigator.pop(context, value),
            )).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
    );

    if (selected != null && selected != _selectedLanguage) {
      setState(() => _selectedLanguage = selected);
      // Save the language preference using LocaleController
      await LocaleController.instance.setLocale(selected);
      // The app will automatically update due to the listener in main.dart
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageChanged),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showBackgroundInfo() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.backgroundExecution),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.backgroundInfoTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.backgroundInfoContent),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.performanceTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.performanceContent),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.understood),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
      LocaleController.instance.setLocale(languageCode); // Corrigido para passar apenas a string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Seção de Notificações
              _buildSectionHeader(AppLocalizations.of(context)!.notifications, Icons.notifications),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.enableNotifications),
                      subtitle: Text(AppLocalizations.of(context)!.receiveReleaseNotifications),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                        _updateSettings();
                      },
                      secondary: const Icon(Icons.notifications_active),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.movieReleases),
                      subtitle: Text(AppLocalizations.of(context)!.notifyFavoriteMovieReleases),
                      value: _movieReleasesEnabled,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() => _movieReleasesEnabled = value);
                              _updateSettings();
                            }
                          : null,
                      secondary: const Icon(Icons.movie),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.newEpisodes),
                      subtitle: Text(AppLocalizations.of(context)!.notifyFavoriteShowEpisodes),
                      value: _tvShowEpisodesEnabled,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() => _tvShowEpisodesEnabled = value);
                              _updateSettings();
                            }
                          : null,
                      secondary: const Icon(Icons.tv),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Seção de Idioma
              _buildSectionHeader(AppLocalizations.of(context)!.language, Icons.language),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.translate, color: Colors.blue),
                  title: Text(AppLocalizations.of(context)!.selectLanguage),
                  subtitle: Text(_getCurrentLanguageName()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showLanguageDialog,
                ),
              ),
              const SizedBox(height: 24),
              
              // Seção de Execução em Background (apenas em Debug)
              if (kDebugMode) ...[
                _buildSectionHeader(AppLocalizations.of(context)!.backgroundExecution, Icons.settings_backup_restore),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.sync, color: Colors.blue),
                        title: Text(AppLocalizations.of(context)!.automaticChecks),
                        subtitle: Text(AppLocalizations.of(context)!.every6HoursEvenClosed),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ATIVO',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        onTap: _showBackgroundInfo,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Seção de Testes e Manutenção (apenas em Debug)
              if (kDebugMode) ...[
                _buildSectionHeader(AppLocalizations.of(context)!.testsMaintenance, Icons.build),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications_active, color: Colors.blue),
                        title: Text(AppLocalizations.of(context)!.testNotification),
                        subtitle: Text(AppLocalizations.of(context)!.sendTestNotification),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _testNotification,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.delete_sweep, color: Colors.orange),
                        title: Text(AppLocalizations.of(context)!.clearSendHistory),
                        subtitle: Text(AppLocalizations.of(context)!.allowResendNotifications),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _clearNotificationHistory,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              const SizedBox(height: 80), // Espaço para o botão flutuante
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/app_mode_controller.dart';
import '../../theme/app_theme.dart';
import 'package:rollflix/l10n/app_localizations.dart';

/// Diálogo para configurar notificações
class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  State<NotificationSettingsDialog> createState() => _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState extends State<NotificationSettingsDialog> {
  late final NotificationController _notificationController;
  late final AppModeController _appModeController;

  // Getters para cores dinâmicas baseadas no modo série
  Color get primaryColor => _appModeController.isSeriesMode ? AppColors.secondary : AppColors.primary;
  Color get accentColor => _appModeController.isSeriesMode ? AppColors.secondary : AppColors.primary;

  @override
  void initState() {
    super.initState();
    _notificationController = NotificationController.instance;
    _appModeController = AppModeController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      title: Row(
        children: [
          Icon(
            Icons.notifications,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.notifications,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.notificationDescription,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Notificações gerais
            _buildSettingTile(
              title: AppLocalizations.of(context)!.activeNotifications,
              subtitle: AppLocalizations.of(context)!.activeNotificationsDescription,
              value: _notificationController.notificationsEnabled,
              onChanged: (value) {
                _notificationController.updateNotificationSettings(
                  notificationsEnabled: value,
                );
                setState(() {});
              },
            ),

            const SizedBox(height: 16),

            // Lançamentos de filmes
            _buildSettingTile(
              title: AppLocalizations.of(context)!.movieReleasesTitle,
              subtitle: AppLocalizations.of(context)!.movieReleasesSubtitle,
              value: _notificationController.movieReleasesEnabled,
              onChanged: _notificationController.notificationsEnabled
                  ? (value) {
                      _notificationController.updateNotificationSettings(
                        movieReleasesEnabled: value,
                      );
                      setState(() {});
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            // Novos episódios
            _buildSettingTile(
              title: AppLocalizations.of(context)!.newEpisodesTitle,
              subtitle: AppLocalizations.of(context)!.newEpisodesSubtitle,
              value: _notificationController.tvShowEpisodesEnabled,
              onChanged: _notificationController.notificationsEnabled
                  ? (value) {
                      _notificationController.updateNotificationSettings(
                        tvShowEpisodesEnabled: value,
                      );
                      setState(() {});
                    }
                  : null,
            ),

            const SizedBox(height: 24),

            // Botão de teste
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _notificationController.notificationsEnabled
                    ? () async {
                        await _notificationController.testNotification();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.testNotificationSent),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.play_arrow),
                label: Text(AppLocalizations.of(context)!.testNotification),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: AppColors.backgroundDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.testNotificationHint,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.close,
            style: AppTextStyles.labelLarge.copyWith(
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
            activeTrackColor: primaryColor.withOpacity(0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }
}
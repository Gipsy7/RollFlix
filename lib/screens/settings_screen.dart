import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode
import '../services/notification_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
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
          const SnackBar(
            content: Text('Configurações salvas com sucesso'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: $e'),
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
        title: const Text('Limpar Histórico'),
        content: const Text(
          'Deseja limpar o histórico de notificações enviadas? '
          'Isso permite que notificações sejam enviadas novamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _notificationService.clearSentNotificationsHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Histórico de envios limpo com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _testNotification() async {
    await _notificationService.showTestNotification(
      title: 'Teste de Notificação',
      body: 'Se você está vendo isso, as notificações estão funcionando! 🎉',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificação de teste enviada'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showBackgroundInfo() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Execução em Background'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Como funciona:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Verificações automáticas a cada 6 horas\n'
                '• Funciona mesmo com app fechado\n'
                '• Requer conexão com internet\n'
                '• Não executa com bateria baixa\n'
                '• Sistema gerenciado pelo Android',
              ),
              SizedBox(height: 16),
              Text(
                'Performance:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Máximo 4 verificações por dia\n'
                '• Verifica apenas favoritos novos\n'
                '• Economia de 90% de bateria\n'
                '• 96% menos chamadas à API',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Seção de Notificações
              _buildSectionHeader('Notificações', Icons.notifications),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Ativar notificações'),
                      subtitle: const Text('Receber notificações sobre lançamentos'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                        _updateSettings();
                      },
                      secondary: const Icon(Icons.notifications_active),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Lançamentos de filmes'),
                      subtitle: const Text('Notificar quando filmes favoritos forem lançados'),
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
                      title: const Text('Novos episódios'),
                      subtitle: const Text('Notificar sobre episódios de séries favoritas'),
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
              
              // Seção de Execução em Background (apenas em Debug)
              if (kDebugMode) ...[
                _buildSectionHeader('Execução em Background', Icons.settings_backup_restore),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.sync, color: Colors.blue),
                        title: const Text('Verificações automáticas'),
                        subtitle: const Text('A cada 6 horas, mesmo com app fechado'),
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
                _buildSectionHeader('Testes e Manutenção', Icons.build),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications_active, color: Colors.blue),
                        title: const Text('Testar notificação'),
                        subtitle: const Text('Enviar notificação de teste'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _testNotification,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.delete_sweep, color: Colors.orange),
                        title: const Text('Limpar histórico de envios'),
                        subtitle: const Text('Permite reenvio de notificações'),
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

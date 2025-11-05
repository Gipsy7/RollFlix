import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/ux_components.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/watched_controller.dart';
import '../controllers/movie_controller.dart';
import '../controllers/tv_show_controller.dart';
import '../controllers/user_preferences_controller.dart';
import '../controllers/app_mode_controller.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import '../services/revenuecat_service.dart';
import '../config/revenuecat_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = false;
  late final FavoritesController _favoritesController;
  late final WatchedController _watchedController;
  late final MovieController _movieController;
  late final TVShowController _tvShowController;
  late final UserPreferencesController _userPreferencesController;
  late final AppModeController _appModeController;
  bool _isProcessingPurchase = false;
  dynamic _offerings;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
    _favoritesController = FavoritesController.instance;
    _watchedController = WatchedController.instance;
    _movieController = MovieController.instance;
    _tvShowController = TVShowController.instance;
    _userPreferencesController = UserPreferencesController.instance;
    _appModeController = AppModeController.instance;

    _favoritesController.addListener(_onDataChanged);
    _watchedController.addListener(_onDataChanged);
    _movieController.addListener(_onDataChanged);
    _tvShowController.addListener(_onDataChanged);
    _userPreferencesController.addListener(_onDataChanged);

    // Load RevenueCat offerings (if configured) to show dynamic price labels
    RevenueCatService.instance.getOfferings().then((o) {
      if (mounted) setState(() => _offerings = o);
    }).catchError((e) {
      debugPrint('⚠️ Could not load RevenueCat offerings: $e');
    });
  }

  Future<void> _restorePurchases() async {
    if (_isProcessingPurchase) return;
    setState(() => _isProcessingPurchase = true);
    try {
      final ok = await RevenueCatService.instance.restorePurchases();
      // Refresh subscription info from RevenueCat/Firestore
      await SubscriptionService.loadSubscription();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ok ? 'Compras restauradas' : 'Nenhuma compra encontrada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao restaurar compras: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessingPurchase = false);
    }
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _favoritesController.removeListener(_onDataChanged);
    _watchedController.removeListener(_onDataChanged);
    _movieController.removeListener(_onDataChanged);
    _tvShowController.removeListener(_onDataChanged);
    _userPreferencesController.removeListener(_onDataChanged);
    // no listeners here for subscription because we use ValueListenableBuilder
    super.dispose();
  }

  Future<void> _purchasePlan(Plan plan) async {
    if (_isProcessingPurchase) return;
    setState(() => _isProcessingPurchase = true);
    try {
      if (plan == Plan.monthly) {
        await SubscriptionService.purchaseMonthly();
      } else if (plan == Plan.annual) {
        await SubscriptionService.purchaseAnnual();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assinatura ativada: ${SubscriptionService.planLabel(plan)}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logoutError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessingPurchase = false);
    }
  }

  Future<void> _cancelSubscription() async {
    if (_isProcessingPurchase) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText('Cancelar Assinatura', style: AppTextStyles.headlineSmall),
        content: SafeText(
          'Deseja cancelar sua assinatura? Se a compra foi há menos de 5 dias, você poderá solicitar reembolso.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: SafeText('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: SafeText('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessingPurchase = true);
    try {
      final result = await RevenueCatService.instance.cancelSubscription();
      
      if (!mounted) return;

      final refundEligible = result['refundEligible'] as bool;
      final daysFromPurchase = result['daysFromPurchase'] as int;
      final appUserId = result['appUserId'] as String?;
      final productId = result['productId'] as String?;
      final purchaseDate = result['purchaseDate'] as String?;

      if (refundEligible) {
        // Redirecionar para solicitar reembolso no Google Play
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: SafeText('Reembolso Disponível', style: AppTextStyles.headlineSmall),
            content: SafeText(
              'Sua compra foi feita há $daysFromPurchase dias. Você pode solicitar reembolso abrindo o Google Play Store:\n\n'
              '1. Abra o Google Play Store\n'
              '2. Menu → Assinaturas\n'
              '3. Selecione RollFlix\n'
              '4. Toque em "Cancelar assinatura"\n'
              '5. Selecione "Solicitar reembolso"\n\n'
              '📋 Informações para suporte:\n'
              'ID do Usuário: ${appUserId ?? 'N/A'}\n'
              'Produto: ${productId ?? 'N/A'}\n'
              'Data da compra: ${purchaseDate ?? 'N/A'}',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Copiar ID do usuário para clipboard
                  if (appUserId != null) {
                    // TODO: Implementar clipboard copy se necessário
                  }
                  Navigator.of(context).pop();
                },
                child: SafeText('Entendi'),
              ),
            ],
          ),
        );
      } else {
        // Apenas cancelar recorrência
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: SafeText('Cancelar Recorrência', style: AppTextStyles.headlineSmall),
            content: SafeText(
              'Sua compra foi feita há $daysFromPurchase dias (prazo de reembolso expirado).\n\n'
              'Para cancelar a renovação automática, abra o Google Play Store:\n\n'
              '1. Abra o Google Play Store\n'
              '2. Menu → Assinaturas\n'
              '3. Selecione RollFlix\n'
              '4. Toque em "Cancelar assinatura"\n\n'
              'Seu plano permanecerá ativo até o fim do período pago.\n\n'
              '📋 Informações para suporte:\n'
              'ID do Usuário: ${appUserId ?? 'N/A'}\n'
              'Produto: ${productId ?? 'N/A'}\n'
              'Data da compra: ${purchaseDate ?? 'N/A'}',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: SafeText('Entendi'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao verificar assinatura: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessingPurchase = false);
    }
  }

  String _getPriceLabel(String productId, String defaultLabel) {
    try {
      if (_offerings == null) return defaultLabel;
      final current = _offerings!.current;
      if (current == null) return defaultLabel;
      for (final pack in current.availablePackages) {
        try {
          final storeProduct = pack.storeProduct;
          // priceString is available on StoreProduct
          if (storeProduct.productIdentifier == productId) {
            final price = storeProduct.priceString ?? '';
            return '${defaultLabel.split(' (').first} ($price)';
          }
        } catch (_) {
          // ignore package-specific issues
        }
      }
    } catch (_) {}
    return defaultLabel;
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: SafeText(
          AppLocalizations.of(context)!.logoutConfirmTitle,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: SafeText(
          AppLocalizations.of(context)!.logoutConfirmMessage,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: SafeText(
              AppLocalizations.of(context)!.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: SafeText(
              AppLocalizations.of(context)!.logout,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      
        try {
        // Use the session service which signs out and clears local cache
        await SessionService.signOutAndClearCache();

        // Navega de volta para a raiz (MaterialApp) removendo todas as rotas
        // Isso força o AuthWrapper a rebuildar e detectar que não há usuário
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.logoutError(e.toString())),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final provider = AuthService.getLoginProvider();

    return ListenableBuilder(
      listenable: _appModeController,
      builder: (context, _) {
        // Cores dinâmicas baseadas no modo
        final primaryColor = _appModeController.isSeriesMode
            ? const Color(0xFFBB86FC)  // Roxo para séries
            : AppColors.primary;        // Dourado para filmes

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: AppBar(
            title: SafeText(
              AppLocalizations.of(context)!.myProfile,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.surfaceDark,
            iconTheme: IconThemeData(color: primaryColor),
            elevation: 0,
          ),
          body: _isLoading
              ? UXComponents.loadingWithText(
                  text: AppLocalizations.of(context)!.loadingProfile,
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    children: [
                      // Avatar e informações básicas
                      _buildProfileHeader(isMobile, primaryColor),
                      const SizedBox(height: 32),
                      
                      // Informações da conta
                      _buildAccountInfo(isMobile, provider, primaryColor),
                      const SizedBox(height: 24),
                      
                      // Estatísticas
                      _buildStatsSection(isMobile, primaryColor),
                      const SizedBox(height: 32),
                      
                      // Botão de logout
                      _buildLogoutButton(isMobile),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildProfileHeader(bool isMobile, Color primaryColor) {
    // Gradiente adaptativo
    final gradient = _appModeController.isSeriesMode
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFBB86FC),  // Roxo
              Color(0xFF9C27B0),  // Roxo mais escuro
            ],
          )
        : AppColors.cinemaGradient;  // Gradiente dourado para filmes

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: isMobile ? 50 : 60,
            backgroundColor: AppColors.surfaceDark,
            backgroundImage: _user?.photoURL != null
                ? NetworkImage(_user!.photoURL!)
                : null,
            child: _user?.photoURL == null
                ? Icon(
                    Icons.person,
                    size: isMobile ? 50 : 60,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          
          // Nome
          SafeText(
            _user?.displayName ?? AppLocalizations.of(context)!.user,
            style: (isMobile 
                ? AppTextStyles.headlineSmall
                : AppTextStyles.headlineMedium).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Email
          if (_user?.email != null)
            SafeText(
              _user!.email!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(bool isMobile, String? provider, Color primaryColor) {
    return Card(
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeText(
              AppLocalizations.of(context)!.accountInfo,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow(
              Icons.badge,
              AppLocalizations.of(context)!.userId,
              _user?.uid ?? 'N/A',
              primaryColor,
            ),
            Divider(color: AppColors.textSecondary.withAlpha(80)),
            
            if (provider != null)
              _buildInfoRow(
                provider == 'Google' ? Icons.g_mobiledata : Icons.facebook,
                'Conectado via',
                provider,
                primaryColor,
              ),
            if (provider != null)
              Divider(color: AppColors.textSecondary.withAlpha(80)),
            
            _buildInfoRow(
              _user?.emailVerified == true ? Icons.verified : Icons.email,
              'Email verificado',
              _user?.emailVerified == true ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no,
              primaryColor,
            ),
            Divider(color: AppColors.textSecondary.withAlpha(80)),

            // Status de assinatura
            ValueListenableBuilder<bool>(
              valueListenable: SubscriptionService.isActive,
              builder: (context, active, _) {
                final plan = SubscriptionService.currentPlan.value;
                final planLabel = SubscriptionService.planLabel(plan);
                final statusText = active ? '$planLabel (ativo)' : planLabel == 'Free' ? 'Free' : '$planLabel (inativo)';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.workspace_premium,
                      'Plano',
                      statusText,
                      primaryColor,
                    ),
                    const SizedBox(height: 8),
                    if (!active)
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 8,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isProcessingPurchase ? null : () => _purchasePlan(Plan.monthly),
                                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                            child: SafeText(_getPriceLabel(RevenueCatConfig.monthlyProductId, 'Assinar Mensal (R\$1)')),
                                          ),
                                          ElevatedButton(
                                            onPressed: _isProcessingPurchase ? null : () => _purchasePlan(Plan.annual),
                                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                            child: SafeText(_getPriceLabel(RevenueCatConfig.annualProductId, 'Assinar Anual (R\$7)')),
                                          ),
                                          OutlinedButton(
                                            onPressed: _isProcessingPurchase ? null : () async => await _restorePurchases(),
                                            child: SafeText('Restaurar compras'),
                                          ),
                                        ],
                                      ),
                    if (active && plan != Plan.free)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton.icon(
                          onPressed: _isProcessingPurchase ? null : _cancelSubscription,
                          icon: Icon(Icons.cancel, size: 18),
                          label: SafeText('Cancelar Assinatura'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.withAlpha(150)),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeText(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                SafeText(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile, Color primaryColor) {
    final favoritesCount = _favoritesController.count;
    final watchedCount = _watchedController.count;
    final rollStats = _userPreferencesController.rollStats;
    final totalRolls = rollStats.totalRolls;

    return Card(
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeText(
              AppLocalizations.of(context)!.statistics,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.favorite, AppLocalizations.of(context)!.favorites, favoritesCount.toString(), isMobile, primaryColor),
                _buildStatItem(Icons.casino, AppLocalizations.of(context)!.rolls, totalRolls.toString(), isMobile, primaryColor),
                _buildStatItem(Icons.visibility, AppLocalizations.of(context)!.watched, watchedCount.toString(), isMobile, primaryColor),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estatísticas detalhadas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailedStatItem(Icons.movie, AppLocalizations.of(context)!.movies, rollStats.movieRolls.toString(), isMobile, primaryColor),
                _buildDetailedStatItem(Icons.tv, AppLocalizations.of(context)!.series, rollStats.seriesRolls.toString(), isMobile, primaryColor),
                _buildDetailedStatItem(Icons.favorite_border, 'Date Nights', rollStats.dateNightCount.toString(), isMobile, primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, bool isMobile, Color primaryColor) {
    return Column(
      children: [
        Icon(icon, color: primaryColor, size: isMobile ? 32 : 40),
        const SizedBox(height: 8),
        SafeText(
          value,
          style: (isMobile 
              ? AppTextStyles.headlineSmall
              : AppTextStyles.headlineMedium).copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SafeText(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStatItem(IconData icon, String label, String value, bool isMobile, Color primaryColor) {
    // Cor secundária baseada no modo
    final secondaryColor = _appModeController.isSeriesMode
        ? const Color(0xFF9C27B0)  // Roxo mais escuro para séries
        : AppColors.secondary;      // Secundária padrão para filmes
    
    return Column(
      children: [
        Icon(icon, color: secondaryColor, size: isMobile ? 24 : 28),
        const SizedBox(height: 6),
        SafeText(
          value,
          style: (isMobile 
              ? AppTextStyles.titleMedium
              : AppTextStyles.titleLarge).copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SafeText(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
            fontSize: isMobile ? 11 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(bool isMobile) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 16 : 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout),
            const SizedBox(width: 8),
            SafeText(
              AppLocalizations.of(context)!.logoutButton,
              style: (isMobile 
                  ? AppTextStyles.labelLarge
                  : AppTextStyles.bodyLarge).copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

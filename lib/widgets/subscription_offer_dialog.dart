import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:rollflix/l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import '../config/revenuecat_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Dialog que oferece assinatura para usuários sem plano premium
class SubscriptionOfferDialog extends StatefulWidget {
  const SubscriptionOfferDialog({super.key});

  @override
  State<SubscriptionOfferDialog> createState() => _SubscriptionOfferDialogState();
}

class _SubscriptionOfferDialogState extends State<SubscriptionOfferDialog> {
  bool _isProcessing = false;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) {
        setState(() => _offerings = offerings);
      }
    } catch (e) {
      debugPrint('Error loading offerings: $e');
    }
  }

  String _getPriceLabel(String productId, String defaultPrice) {
    try {
      if (_offerings?.current == null) return defaultPrice;
      for (final pack in _offerings!.current!.availablePackages) {
        final storeProduct = pack.storeProduct;
        if (storeProduct.identifier == productId || 
            storeProduct.identifier.startsWith('$productId:')) {
          return storeProduct.priceString;
        }
      }
    } catch (_) {}
    return defaultPrice;
  }

  Future<void> _purchase(Plan plan) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      if (plan == Plan.monthly) {
        await SubscriptionService.purchaseMonthly();
      } else if (plan == Plan.annual) {
        await SubscriptionService.purchaseAnnual();
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Fecha o dialog com sucesso
        final loc = AppLocalizations.of(context)!;
        final planLabel = plan == Plan.monthly ? loc.planMonthly : plan == Plan.annual ? loc.planAnnual : loc.freePlan;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${loc.subscriptionActivated(planLabel)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.subscriptionError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthlyPrice = _getPriceLabel(RevenueCatConfig.monthlyProductId, 'R\$ 0,99');
    final annualPrice = _getPriceLabel(RevenueCatConfig.annualProductId, 'R\$ 7,00');
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 480 ? 440.0 : constraints.maxWidth - 24.0;
          final maxHeight = MediaQuery.of(context).size.height * 0.85;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Botão fechar alinhado certo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: _isProcessing ? null : () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),

                  // Ícone premium reduzido para caber em telas pequenas
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 48,
                      color: Colors.amber,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Título
                  Text(
                    loc.subscriptionOfferTitle,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  // Subtítulo
                  Text(
                    loc.subscriptionOfferSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  // Benefícios
                  _buildBenefit(Icons.movie_filter, loc.benefitUnlimitedAccess),
                  _buildBenefit(Icons.block, loc.benefitNoAds),
                  _buildBenefit(Icons.favorite, loc.benefitUnlimitedFavorites),
                  _buildBenefit(Icons.download, loc.benefitEarlyAccess),

                  const SizedBox(height: 18),

                  // Botão plano mensal (titulo e preço alinhados em linha)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : () => _purchase(Plan.monthly),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.black),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loc.planMonthly,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  monthlyPrice,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botão plano anual (com badge de economia)
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        OutlinedButton(
                          onPressed: _isProcessing ? null : () => _purchase(Plan.annual),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber,
                            side: const BorderSide(color: Colors.amber, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loc.planAnnual,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '$annualPrice/ano',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Badge de economia — evita overflow usando constraints
                        Positioned(
                          top: -10,
                          right: 12,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  loc.economize,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Texto pequeno
                  Text(
                    loc.cancelAnytime,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Assinatura ativada: ${SubscriptionService.planLabel(plan)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar assinatura: ${e.toString()}'),
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

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botão fechar
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: _isProcessing ? null : () => Navigator.of(context).pop(false),
              ),
            ),
            
            // Ícone premium
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 64,
                color: Colors.amber,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Título
            Text(
              'Desbloqueie o Premium!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              'Aproveite recursos ilimitados e sem anúncios',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Benefícios
            _buildBenefit(Icons.movie_filter, 'Acesso ilimitado a filmes e séries'),
            _buildBenefit(Icons.block, 'Sem anúncios'),
            _buildBenefit(Icons.favorite, 'Favoritos ilimitados'),
            _buildBenefit(Icons.download, 'Novos recursos primeiro'),
            
            const SizedBox(height: 24),
            
            // Botão plano mensal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _purchase(Plan.monthly),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                    : Column(
                        children: [
                          Text(
                            'Plano Mensal',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            monthlyPrice,
                            style: const TextStyle(
                              fontSize: 14,
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Plano Anual',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$annualPrice/ano',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Badge de economia
                  Positioned(
                    top: -10,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ECONOMIZE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Texto pequeno
            Text(
              'Cancele a qualquer momento',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

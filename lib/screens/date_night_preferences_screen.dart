import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/date_night_preferences.dart';
import '../services/preferences_service.dart';
import '../utils/color_extensions.dart';
import '../widgets/responsive_widgets.dart';

class DateNightPreferencesScreen extends StatefulWidget {
  final DateNightPreferences? initialPreferences;
  
  const DateNightPreferencesScreen({
    super.key,
    this.initialPreferences,
  });

  @override
  State<DateNightPreferencesScreen> createState() => _DateNightPreferencesScreenState();
}

class _DateNightPreferencesScreenState extends State<DateNightPreferencesScreen> {
  late DateNightPreferences _preferences;
  final List<String> _dislikedIngredients = [];

  // Cores do tema romântico
  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);
  static const Color _darkRose = Color(0xFF880E4F);

  @override
  void initState() {
    super.initState();
    _preferences = widget.initialPreferences ?? const DateNightPreferences();
    _dislikedIngredients.addAll(_preferences.dislikedIngredients);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: SafeText(
          'Preferências do Date Night',
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        ),
        backgroundColor: _darkRose,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _savePreferences,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_darkRose, AppColors.backgroundDark],
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.tune,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  SafeText(
                    'Personalize Sua Experiência',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SafeText(
                    'Configure suas preferências para sugestões personalizadas',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restrições Alimentares
                  _buildSection(
                    title: 'Restrições Alimentares',
                    icon: Icons.restaurant_menu,
                    child: _buildDietaryRestrictionSelector(),
                  ),

                  const SizedBox(height: 24),

                  // Orçamento
                  _buildSection(
                    title: 'Orçamento',
                    icon: Icons.attach_money,
                    child: _buildBudgetSelector(),
                  ),

                  const SizedBox(height: 24),

                  // Tempo de Preparo
                  _buildSection(
                    title: 'Tempo de Preparo',
                    icon: Icons.timer,
                    child: _buildPreparationTimeSelector(),
                  ),

                  const SizedBox(height: 24),

                  // Nível de Habilidade
                  _buildSection(
                    title: 'Nível Culinário',
                    icon: Icons.restaurant,
                    child: _buildSkillLevelSelector(),
                  ),

                  const SizedBox(height: 24),

                  // Bebidas Alcoólicas
                  _buildSection(
                    title: 'Preferências de Bebidas',
                    icon: Icons.local_bar,
                    child: _buildAlcoholSwitch(),
                  ),

                  const SizedBox(height: 24),

                  // Ingredientes que Não Gosta
                  _buildSection(
                    title: 'Ingredientes a Evitar',
                    icon: Icons.block,
                    child: _buildDislikedIngredients(),
                  ),

                  const SizedBox(height: 32),

                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetToDefaults,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: _primaryRose),
                          ),
                          child: const Text('Restaurar Padrão'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _savePreferences,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: _primaryRose,
                          ),
                          child: const Text('Salvar Preferências'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryRose.withOpacitySafe(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryRose, size: 24),
              const SizedBox(width: 12),
              SafeText(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDietaryRestrictionSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DietaryRestriction.values.map((restriction) {
        final isSelected = _preferences.dietaryRestriction == restriction;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(restriction.emoji),
              const SizedBox(width: 8),
              Text(restriction.label),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _preferences = _preferences.copyWith(
                dietaryRestriction: selected ? restriction : DietaryRestriction.none,
              );
            });
          },
          selectedColor: _primaryRose.withOpacitySafe(0.3),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetSelector() {
    return Column(
      children: BudgetRange.values.map((budget) {
        final isSelected = _preferences.budgetRange == budget;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _preferences = _preferences.copyWith(budgetRange: budget);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? _primaryRose.withOpacitySafe(0.2) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _primaryRose : Colors.grey.withOpacitySafe(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    budget.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          budget.range,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: _primaryRose),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreparationTimeSelector() {
    return Column(
      children: PreparationTime.values.map((time) {
        final isSelected = _preferences.preparationTime == time;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _preferences = _preferences.copyWith(preparationTime: time);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? _secondaryGold.withOpacitySafe(0.2) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _secondaryGold : Colors.grey.withOpacitySafe(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    time.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          time.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          time.duration,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: _secondaryGold),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillLevelSelector() {
    return Column(
      children: CookingSkillLevel.values.map((level) {
        final isSelected = _preferences.skillLevel == level;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _preferences = _preferences.copyWith(skillLevel: level);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? _primaryRose.withOpacitySafe(0.2) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _primaryRose : Colors.grey.withOpacitySafe(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    level.stars,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          level.description,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: _primaryRose),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlcoholSwitch() {
    return SwitchListTile(
      title: const Text(
        'Incluir bebidas alcoólicas',
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        _preferences.includeAlcohol 
            ? 'Sugestões incluirão vinhos e drinques' 
            : 'Apenas bebidas não-alcoólicas',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
      value: _preferences.includeAlcohol,
      onChanged: (value) {
        setState(() {
          _preferences = _preferences.copyWith(includeAlcohol: value);
        });
      },
      activeColor: _primaryRose,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDislikedIngredients() {
    final commonIngredients = [
      'Frutos do mar',
      'Cogumelos',
      'Cebola',
      'Alho',
      'Pimentão',
      'Azeitonas',
      'Queijos fortes',
      'Peixe',
      'Carne vermelha',
      'Leite',
      'Ovos',
      'Nozes',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione ingredientes que deseja evitar:',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commonIngredients.map((ingredient) {
            final isDisliked = _dislikedIngredients.contains(ingredient);
            return FilterChip(
              label: Text(ingredient),
              selected: isDisliked,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _dislikedIngredients.add(ingredient);
                  } else {
                    _dislikedIngredients.remove(ingredient);
                  }
                  _preferences = _preferences.copyWith(
                    dislikedIngredients: List.from(_dislikedIngredients),
                  );
                });
              },
              selectedColor: Colors.red.withOpacitySafe(0.3),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isDisliked ? Colors.white : Colors.white70,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _resetToDefaults() {
    setState(() {
      _preferences = const DateNightPreferences();
      _dislikedIngredients.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferências restauradas para o padrão'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _savePreferences() async {
    // Salvar preferências no SharedPreferences
    await PreferencesService.savePreferences(_preferences);
    
    if (!mounted) return;
    
    Navigator.pop(context, _preferences);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferências salvas com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

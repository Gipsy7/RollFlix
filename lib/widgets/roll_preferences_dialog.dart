import 'package:flutter/material.dart';
import '../models/roll_preferences.dart';
import '../theme/app_theme.dart';

class RollPreferencesDialog extends StatefulWidget {
  final RollPreferences initialPreferences;
  final bool isSeriesMode;

  const RollPreferencesDialog({
    super.key,
    required this.initialPreferences,
    this.isSeriesMode = false,
  });

  @override
  State<RollPreferencesDialog> createState() => _RollPreferencesDialogState();
}

class _RollPreferencesDialogState extends State<RollPreferencesDialog> {
  late int? _minYear;
  late int? _maxYear;
  late bool _excludeWatched;
  late String _sortBy;
  late bool _allowAdult;

  @override
  void initState() {
    super.initState();
    _minYear = widget.initialPreferences.minYear;
    _maxYear = widget.initialPreferences.maxYear;
    _excludeWatched = widget.initialPreferences.excludeWatched;
    _sortBy = widget.initialPreferences.sortBy;
    _allowAdult = widget.initialPreferences.allowAdult;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: AppColors.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: isMobile ? double.infinity : 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Preferências de Rolagem',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Período
                    _buildSectionTitle('Período de Lançamento'),
                    const SizedBox(height: 12),
                    _buildYearRangePicker(),
                    const SizedBox(height: 24),

                    // Ordenação
                    _buildSectionTitle('Ordenar Por'),
                    const SizedBox(height: 12),
                    _buildSortByOptions(),
                    const SizedBox(height: 24),

                    // Classificação Indicativa
                    _buildSectionTitle('Classificação Indicativa'),
                    const SizedBox(height: 12),
                    _buildAdultContentToggle(),
                    const SizedBox(height: 24),

                    // Outras opções
                    _buildSectionTitle('Outras Opções'),
                    const SizedBox(height: 8),
                    _buildExcludeWatchedOption(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetPreferences,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyPreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.backgroundDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Aplicar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildYearRangePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'De',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectYear(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _minYear?.toString() ?? 'Qualquer',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Até',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectYear(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _maxYear?.toString() ?? 'Qualquer',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_minYear != null || _maxYear != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _minYear = null;
                  _maxYear = null;
                });
              },
              icon: Icon(Icons.clear, size: 16, color: AppColors.textSecondary),
              label: Text(
                'Limpar período',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectYear(bool isMinYear) async {
    final currentYear = DateTime.now().year;
    final initialYear = isMinYear 
        ? (_minYear ?? 1900)
        : (_maxYear ?? currentYear);
    
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.backgroundDark,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecionar Ano ${isMinYear ? "Inicial" : "Final"}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentYear - 1900 + 1,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final year = currentYear - index;
                    return ListTile(
                      title: Text(
                        year.toString(),
                        style: TextStyle(
                          color: year == initialYear 
                              ? AppColors.primary 
                              : AppColors.textPrimary,
                          fontWeight: year == initialYear 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (isMinYear) {
                            _minYear = year;
                          } else {
                            _maxYear = year;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortByOptions() {
    return Column(
      children: [
        _buildSortOption(
          'random',
          'Aleatório',
          'Ordem completamente aleatória',
          Icons.shuffle,
        ),
        const SizedBox(height: 8),
        _buildSortOption(
          'rating',
          'Melhor Avaliados',
          'Prioriza filmes com maior nota',
          Icons.star,
        ),
        const SizedBox(height: 8),
        _buildSortOption(
          'popularity',
          'Mais Populares',
          'Prioriza filmes mais conhecidos',
          Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildSortOption(String value, String title, String subtitle, IconData icon) {
    final isSelected = _sortBy == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : AppColors.primary.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdultContentToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !_allowAdult 
              ? AppColors.primary 
              : AppColors.primary.withValues(alpha: 0.2),
          width: !_allowAdult ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _allowAdult ? Icons.public : Icons.family_restroom,
            color: !_allowAdult ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Permitir conteúdo +18',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _allowAdult 
                      ? 'Exibir todo tipo de conteúdo' 
                      : 'Apenas conteúdo não adulto',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _allowAdult,
            onChanged: (value) {
              setState(() {
                _allowAdult = value;
              });
            },
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildExcludeWatchedOption() {
    return InkWell(
      onTap: () {
        setState(() {
          _excludeWatched = !_excludeWatched;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _excludeWatched 
                ? AppColors.primary 
                : AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _excludeWatched ? Icons.check_box : Icons.check_box_outline_blank,
              color: _excludeWatched ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Excluir já assistidos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Não mostra conteúdos já marcados como assistidos',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPreferences() {
    setState(() {
      _minYear = null;
      _maxYear = null;
      _excludeWatched = false;
      _sortBy = 'random';
      _allowAdult = true;
    });
  }

  void _applyPreferences() {
    final preferences = RollPreferences(
      minYear: _minYear,
      maxYear: _maxYear,
      excludeWatched: _excludeWatched,
      sortBy: _sortBy,
      allowAdult: _allowAdult,
    );
    Navigator.pop(context, preferences);
  }
}

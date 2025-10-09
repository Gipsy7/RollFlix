import 'package:flutter/material.dart';
import '../models/roll_preferences.dart';
import '../theme/app_theme.dart';
import '../controllers/user_preferences_controller.dart';

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

  Color get _accentColor => widget.isSeriesMode
    ? const Color(0xFFF02B6D)
    : AppColors.primary;

  Color get _accentColorSoft => widget.isSeriesMode
    ? const Color(0xFFFF4FA6)
    : AppColors.primaryLight;

  Color get _backgroundColor => widget.isSeriesMode
    ? const Color(0xFF120017)
    : AppColors.backgroundDark;

  Color get _surfaceColor => widget.isSeriesMode
    ? const Color(0xFF1E0A2A)
    : AppColors.surfaceDark;

  Color get _surfaceOverlayColor => widget.isSeriesMode
    ? const Color(0xFF2A1438).withValues(alpha: 0.85)
    : AppColors.surfaceDark.withValues(alpha: 0.5);

  Color get _borderTintColor => widget.isSeriesMode
    ? const Color(0xFF7A3EB1).withValues(alpha: 0.4)
    : AppColors.primary.withValues(alpha: 0.2);

  Color get _secondaryTextColor => widget.isSeriesMode
    ? const Color(0xFFE8AFFF)
    : AppColors.textSecondary;

  Color get _mutedTextColor => widget.isSeriesMode
    ? const Color(0xFFB98BCD)
    : AppColors.textSecondary.withValues(alpha: 0.7);

  Color get _inactiveThumbColor => widget.isSeriesMode
    ? const Color(0xFFB98BCD)
    : AppColors.textSecondary;

  Color get _inactiveTrackColor => widget.isSeriesMode
    ? const Color(0xFF7A3EB1).withValues(alpha: 0.35)
    : AppColors.textSecondary.withValues(alpha: 0.3);

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
      backgroundColor: _backgroundColor,
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
                  color: _accentColor,
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
                  icon: Icon(Icons.close, color: _secondaryTextColor),
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
                      foregroundColor: _secondaryTextColor,
                      side: BorderSide(color: _secondaryTextColor.withValues(alpha: 0.3)),
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
                      backgroundColor: _accentColor,
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
        color: _surfaceOverlayColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderTintColor),
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
                        color: _mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectYear(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _accentColor.withValues(alpha: widget.isSeriesMode ? 0.45 : 0.3),
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
                        color: _mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectYear(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _accentColor.withValues(alpha: widget.isSeriesMode ? 0.45 : 0.3),
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
              icon: Icon(Icons.clear, size: 16, color: _secondaryTextColor),
              label: Text(
                'Limpar período',
                style: TextStyle(color: _secondaryTextColor, fontSize: 12),
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
        backgroundColor: _backgroundColor,
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
                              ? _accentColor 
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
              ? _accentColor.withValues(alpha: widget.isSeriesMode ? 0.25 : 0.2)
              : _surfaceOverlayColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? _accentColor 
                : _accentColor.withValues(alpha: widget.isSeriesMode ? 0.35 : 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? _accentColor : _secondaryTextColor,
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
                      color: isSelected ? _accentColor : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _mutedTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: _accentColor,
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
        color: _surfaceOverlayColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !_allowAdult 
              ? _accentColor 
              : _accentColor.withValues(alpha: widget.isSeriesMode ? 0.35 : 0.2),
          width: !_allowAdult ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _allowAdult ? Icons.public : Icons.family_restroom,
            color: !_allowAdult ? _accentColor : _secondaryTextColor,
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
                    color: _mutedTextColor,
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
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _accentColor;
              }
              return _inactiveThumbColor;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _accentColorSoft.withValues(alpha: 0.6);
              }
              return _inactiveTrackColor;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExcludeWatchedOption() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _excludeWatched = !_excludeWatched;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surfaceOverlayColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _excludeWatched 
                ? _accentColor 
                : _accentColor.withValues(alpha: widget.isSeriesMode ? 0.35 : 0.1),
            width: _excludeWatched ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _excludeWatched ? Icons.check_box : Icons.check_box_outline_blank,
              color: _excludeWatched ? _accentColor : _secondaryTextColor,
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
                      color: _mutedTextColor,
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

  void _applyPreferences() async {
    final preferences = RollPreferences(
      minYear: _minYear,
      maxYear: _maxYear,
      excludeWatched: _excludeWatched,
      sortBy: _sortBy,
      allowAdult: _allowAdult,
    );

    try {
      await UserPreferencesController.instance.updateRollPreferences(preferences);
      if (mounted) {
        Navigator.pop(context, preferences);
      }
    } catch (e) {
      // Em caso de erro, ainda retorna as preferências para manter compatibilidade
      if (mounted) {
        Navigator.pop(context, preferences);
      }
    }
  }
}

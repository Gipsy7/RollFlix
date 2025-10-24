import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';

import '../utils/color_extensions.dart';

class CookingTimerWidget extends StatefulWidget {
  final int totalMinutes;
  final VoidCallback? onComplete;

  const CookingTimerWidget({
    super.key,
    required this.totalMinutes,
    this.onComplete,
  });

  @override
  State<CookingTimerWidget> createState() => _CookingTimerWidgetState();
}

class _CookingTimerWidgetState extends State<CookingTimerWidget> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isCompleted) {
      setState(() {
        _remainingSeconds = widget.totalMinutes * 60;
        _isCompleted = false;
      });
    }

    setState(() => _isRunning = true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isRunning = false;
          _isCompleted = true;
          _timer?.cancel();
          widget.onComplete?.call();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.totalMinutes * 60;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    final totalSeconds = widget.totalMinutes * 60;
    return totalSeconds > 0 ? 1 - (_remainingSeconds / totalSeconds) : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryRose.withOpacitySafe(0.1),
            _secondaryGold.withOpacitySafe(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryRose.withOpacitySafe(0.3)),
      ),
      child: Column(
        children: [
          // Relógio visual
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.withOpacitySafe(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isCompleted ? Colors.green : _primaryRose,
                  ),
                ),
              ),
              Column(
                children: [
                  Icon(
                    _isCompleted ? Icons.check_circle : Icons.timer,
                    size: 32,
                    color: _isCompleted ? Colors.green : _secondaryGold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedTime,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_isCompleted)
                    Text(
                      AppLocalizations.of(context)!.ready,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Controles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão Reset
              IconButton(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                color: Colors.white70,
                iconSize: 28,
                tooltip: AppLocalizations.of(context)!.restart,
              ),

              // Botão Play/Pause
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_primaryRose, _secondaryGold],
                  ),
                ),
                child: IconButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  color: Colors.white,
                  iconSize: 36,
                  tooltip: _isRunning ? AppLocalizations.of(context)!.pause : AppLocalizations.of(context)!.start,
                ),
              ),

              // Adicionar 5 minutos
              IconButton(
                onPressed: () {
                  setState(() {
                    _remainingSeconds += 300; // 5 minutos
                  });
                },
                icon: const Icon(Icons.add),
                color: Colors.white70,
                iconSize: 28,
                tooltip: AppLocalizations.of(context)!.add5Min,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IngredientsChecklistWidget extends StatefulWidget {
  final List<String> ingredients;
  final List<String>? mainCourseIngredients;
  final List<String>? dessertIngredients;
  final List<String>? appetizerIngredients;
  final List<String>? sideDishIngredients;

  const IngredientsChecklistWidget({
    super.key,
    required this.ingredients,
    this.mainCourseIngredients,
    this.dessertIngredients,
    this.appetizerIngredients,
    this.sideDishIngredients,
  });

  @override
  State<IngredientsChecklistWidget> createState() => _IngredientsChecklistWidgetState();
}

class _IngredientsChecklistWidgetState extends State<IngredientsChecklistWidget> {
  final Set<int> _checkedItems = {};

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  int get _totalIngredients {
    int total = widget.ingredients.length;
    if (widget.mainCourseIngredients != null) total += widget.mainCourseIngredients!.length;
    if (widget.dessertIngredients != null) total += widget.dessertIngredients!.length;
    if (widget.appetizerIngredients != null) total += widget.appetizerIngredients!.length;
    if (widget.sideDishIngredients != null) total += widget.sideDishIngredients!.length;
    // Subtrair a lista geral se temos categorias (para não duplicar)
    if (widget.mainCourseIngredients != null || widget.dessertIngredients != null) {
      total -= widget.ingredients.length;
    }
    return total;
  }

  double get _completionPercentage {
    final total = _totalIngredients;
    if (total == 0) return 0;
    return (_checkedItems.length / total) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryRose.withOpacitySafe(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com progresso
          Row(
            children: [
              const Icon(Icons.shopping_cart, color: _secondaryGold),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.ingredientsList,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_checkedItems.length}/${_totalIngredients} itens ($_completionPercentage.toStringAsFixed(0)%)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Barra de progresso
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _completionPercentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.withOpacitySafe(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                _completionPercentage == 100 ? Colors.green : _primaryRose,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lista de ingredientes (categorizada ou simples)
          if (widget.mainCourseIngredients != null || widget.dessertIngredients != null ||
              widget.appetizerIngredients != null || widget.sideDishIngredients != null) ...[
            // Layout categorizado
            if (widget.mainCourseIngredients != null && widget.mainCourseIngredients!.isNotEmpty)
              _buildCategorySection(
                AppLocalizations.of(context)!.mainCourse,
                Icons.restaurant,
                widget.mainCourseIngredients!,
                0,
              ),
            
            if (widget.dessertIngredients != null && widget.dessertIngredients!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildCategorySection(
                AppLocalizations.of(context)!.dessert,
                Icons.cake,
                widget.dessertIngredients!,
                (widget.mainCourseIngredients?.length ?? 0),
              ),
            ],

            if (widget.appetizerIngredients != null && widget.appetizerIngredients!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildCategorySection(
                AppLocalizations.of(context)!.appetizers,
                Icons.tapas,
                widget.appetizerIngredients!,
                (widget.mainCourseIngredients?.length ?? 0) + 
                (widget.dessertIngredients?.length ?? 0),
              ),
            ],

            if (widget.sideDishIngredients != null && widget.sideDishIngredients!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildCategorySection(
                AppLocalizations.of(context)!.sideDishes,
                Icons.rice_bowl,
                widget.sideDishIngredients!,
                (widget.mainCourseIngredients?.length ?? 0) + 
                (widget.dessertIngredients?.length ?? 0) +
                (widget.appetizerIngredients?.length ?? 0),
              ),
            ],
          ] else ...[
            // Lista simples (fallback para dados legados)
            ...widget.ingredients.asMap().entries.map((entry) {
              return _buildIngredientItem(entry.key, entry.value);
            }),
          ],

          if (_completionPercentage == 100) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacitySafe(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.allIngredientsReady,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    List<String> ingredients,
    int indexOffset,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _primaryRose, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: _primaryRose,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _primaryRose.withOpacitySafe(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${ingredients.length} ${ingredients.length == 1 ? AppLocalizations.of(context)!.item : AppLocalizations.of(context)!.items}',
                style: const TextStyle(
                  color: _primaryRose,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...ingredients.asMap().entries.map((entry) {
          final index = indexOffset + entry.key;
          return _buildIngredientItem(index, entry.value);
        }),
      ],
    );
  }

  Widget _buildIngredientItem(int index, String ingredient) {
    final isChecked = _checkedItems.contains(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isChecked) {
              _checkedItems.remove(index);
            } else {
              _checkedItems.add(index);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
      color: isChecked 
        ? Colors.green.withOpacitySafe(0.1) 
        : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
        color: isChecked 
          ? Colors.green 
          : Colors.grey.withOpacitySafe(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isChecked 
                    ? Icons.check_box 
                    : Icons.check_box_outline_blank,
                color: isChecked ? Colors.green : Colors.white70,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: isChecked 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateNightScheduleWidget extends StatelessWidget {
  final List<Map<String, dynamic>> schedule;

  const DateNightScheduleWidget({
    super.key,
    required this.schedule,
  });

  static const Color _primaryRose = Color(0xFFE91E63);
  static const Color _secondaryGold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _secondaryGold.withOpacitySafe(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: _secondaryGold),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.dateNightSchedule,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...schedule.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == schedule.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [_primaryRose, _secondaryGold],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          item['icon'] ?? '⏰',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 60,
                        color: _primaryRose.withOpacitySafe(0.3),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['time'] ?? '',
                          style: TextStyle(
                            color: _secondaryGold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['activity'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item['tips'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item['tips'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class GenreWheel extends StatefulWidget {
  final List<String> genres;
  final String? selectedGenre;
  final Function(String) onGenreSelected;
  final VoidCallback? onRandomSpin;

  const GenreWheel({
    super.key,
    required this.genres,
    this.selectedGenre,
    required this.onGenreSelected,
    this.onRandomSpin,
  });

  @override
  State<GenreWheel> createState() => _GenreWheelState();
}

class _GenreWheelState extends State<GenreWheel>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  double _currentRotation = 0.0;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotationController.addListener(() {
      setState(() {
        _currentRotation = _rotationAnimation.value;
      });
    });
    
    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
        });
        _selectGenreFromRotation();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;
    
    setState(() {
      _isSpinning = true;
    });
    
    // Gera um número aleatório de voltas entre 3 e 8
    final random = Random();
    final spins = 3 + random.nextDouble() * 5;
    final targetRotation = _currentRotation + spins;
    
    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotationController.reset();
    _rotationController.forward();
    
    widget.onRandomSpin?.call();
  }

  void _selectGenreFromRotation() {
    // Calcula qual gênero está no topo após a rotação
    final normalizedRotation = _currentRotation % 1.0;
    final genreIndex = ((1.0 - normalizedRotation) * widget.genres.length).floor() % widget.genres.length;
    final selectedGenre = widget.genres[genreIndex];
    widget.onGenreSelected(selectedGenre);
  }

  void _onGenreTap(String genre) {
    if (_isSpinning) return;
    widget.onGenreSelected(genre);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;
    final wheelSize = size.clamp(280.0, 400.0);
    final centerButtonSize = wheelSize * 0.2;
    
    return Center(
      child: SizedBox(
        width: wheelSize,
        height: wheelSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Roleta
            Transform.rotate(
              angle: _currentRotation * 2 * pi,
              child: CustomPaint(
                size: Size(wheelSize, wheelSize),
                painter: GenreWheelPainter(
                  genres: widget.genres,
                  selectedGenre: widget.selectedGenre,
                ),
              ),
            ),
            
            // Área clicável da roleta
            GestureDetector(
              onTapDown: (details) {
                if (_isSpinning) return;
                
                final center = Offset(wheelSize / 2, wheelSize / 2);
                final tapPosition = details.localPosition - center;
                final distance = tapPosition.distance;
                
                // Verifica se clicou na área da roleta (não no centro)
                if (distance > wheelSize * 0.15 && distance < wheelSize * 0.45) {
                  // Calcula qual segmento foi clicado
                  final angle = atan2(tapPosition.dy, tapPosition.dx);
                  final normalizedAngle = (angle + pi / 2 + 2 * pi) % (2 * pi);
                  final segmentAngle = 2 * pi / widget.genres.length;
                  final segmentIndex = (normalizedAngle / segmentAngle).floor() % widget.genres.length;
                  
                  _onGenreTap(widget.genres[segmentIndex]);
                }
              },
              child: Container(
                width: wheelSize,
                height: wheelSize,
                color: Colors.transparent,
              ),
            ),
            
            // Indicador no topo
            Positioned(
              top: 0,
              child: Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 15,
                      color: Colors.transparent,
                    ),
                    right: BorderSide(
                      width: 15,
                      color: Colors.transparent,
                    ),
                    bottom: BorderSide(
                      width: 25,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            
            // Botão central
            GestureDetector(
              onTap: _spinWheel,
              child: AnimatedContainer(
                duration: AppConstants.fastAnimation,
                width: centerButtonSize,
                height: centerButtonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _isSpinning ? Icons.hourglass_empty : Icons.casino,
                  color: Colors.white,
                  size: centerButtonSize * 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenreWheelPainter extends CustomPainter {
  final List<String> genres;
  final String? selectedGenre;

  GenreWheelPainter({
    required this.genres,
    this.selectedGenre,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * pi / genres.length;
    
    // Cores para os segmentos
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFF97316),
      const Color(0xFF84CC16),
      const Color(0xFFEC4899),
      const Color(0xFF6366F1),
      const Color(0xFF14B8A6),
      const Color(0xFFFBBF24),
      const Color(0xFFF472B6),
      const Color(0xFF9333EA),
      const Color(0xFF0EA5E9),
      const Color(0xFF22C55E),
    ];

    for (int i = 0; i < genres.length; i++) {
      final startAngle = i * segmentAngle - (pi / 2);
      final color = colors[i % colors.length];
      final isSelected = genres[i] == selectedGenre;
      
      // Desenha o segmento
      final paint = Paint()
        ..color = isSelected ? color : color.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );
      
      // Desenha a borda
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3 : 1;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );
      
      // Desenha o texto
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.7; // Posição média no segmento
      final textCenter = Offset(
        center.dx + cos(textAngle) * textRadius,
        center.dy + sin(textAngle) * textRadius,
      );
      
      final textSpan = TextSpan(
        text: genres[i],
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.3,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.8),
              offset: const Offset(0, 0),
            ),
            Shadow(
              blurRadius: 1,
              color: Colors.black.withOpacity(0.9),
              offset: const Offset(1, 1),
            ),
          ],
        ),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );
      
      textPainter.layout();
      
      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      
      // Rotação para ficar paralelo ao raio, mas ajustando a orientação
      // para evitar texto de cabeça para baixo na parte inferior
      double rotation = textAngle;
      
      // Se o texto estiver na metade inferior do círculo, 
      // adiciona 180 graus para não ficar invertido
      if (textAngle > pi / 2 && textAngle < 3 * pi / 2) {
        rotation += pi;
      }
      
      canvas.rotate(rotation);
      
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
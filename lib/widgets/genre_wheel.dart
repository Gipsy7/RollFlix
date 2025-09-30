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
    
    // Cores cinematográficas para os segmentos
    final colors = [
      AppColors.primary,           // Gold
      AppColors.secondary,         // Crimson Red
      AppColors.accent,            // Popcorn Yellow
      AppColors.curtainRed,        // Burgundy
      AppColors.primaryDark,       // Dark Gold
      AppColors.secondaryLight,    // Light Red
      AppColors.accentDark,        // Banana Yellow
      const Color(0xFF4A5568),     // Film Strip Gray
      const Color(0xFF2D3748),     // Dark Charcoal
      const Color(0xFF744210),     // Bronze
      const Color(0xFF9B2C2C),     // Dark Red
      const Color(0xFFD69E2E),     // Amber
      const Color(0xFF553C9A),     // Purple
      const Color(0xFF285E61),     // Teal
      const Color(0xFF975A16),     // Orange
      const Color(0xFF68D391),     // Green
      const Color(0xFF667EEA),     // Blue
      const Color(0xFFED8936),     // Orange
    ];

    for (int i = 0; i < genres.length; i++) {
      final startAngle = i * segmentAngle - (pi / 2);
      final color = colors[i % colors.length];
      final isSelected = genres[i] == selectedGenre;
      
      // Desenha o segmento com gradiente cinematográfico
      final paint = Paint()
        ..shader = RadialGradient(
          colors: isSelected
              ? [color, color.withOpacity(0.9), color.withOpacity(0.7)]
              : [color.withOpacity(0.8), color.withOpacity(0.6), color.withOpacity(0.4)],
          stops: const [0.3, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );
      
      // Desenha a borda dourada
      final borderPaint = Paint()
        ..color = isSelected ? AppColors.primary : AppColors.filmStrip
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 4 : 2;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );
      
      // Desenha o texto com estilo cinematográfico
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.6; // Posição mais próxima do centro para evitar extrapolar
      final textCenter = Offset(
        center.dx + cos(textAngle) * textRadius,
        center.dy + sin(textAngle) * textRadius,
      );
      
      // Ajusta o texto para caber no segmento
      String displayText = genres[i];
      double fontSize = isSelected ? 12 : 10;
      
      // Para textos muito longos, usa abreviação
      if (displayText.length > 10) {
        fontSize = isSelected ? 10 : 8;
        if (displayText.length > 12) {
          displayText = '${displayText.substring(0, 8)}...';
        }
      }
      
      // Ajusta o tamanho da fonte baseado no número de segmentos
      if (genres.length > 12) {
        fontSize *= 0.9;
      }
      if (genres.length > 16) {
        fontSize *= 0.8;
      }
      
      final textSpan = TextSpan(
        text: displayText,
        style: AppTextStyles.genreLabel.copyWith(
          color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: fontSize,
          letterSpacing: 0.5,
          shadows: [
            Shadow(
              blurRadius: 3,
              color: AppColors.backgroundDark.withOpacity(0.9),
              offset: const Offset(1, 1),
            ),
            Shadow(
              blurRadius: 1,
              color: isSelected ? AppColors.primary.withOpacity(0.5) : AppColors.backgroundDark.withOpacity(0.7),
              offset: const Offset(0, 0),
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
      
      // Verifica se o texto é muito largo para o segmento e ajusta
      final maxWidth = radius * 0.8; // Largura máxima permitida
      if (textPainter.width > maxWidth) {
        // Cria um novo textSpan com texto menor
        final adjustedTextSpan = TextSpan(
          text: displayText,
          style: AppTextStyles.genreLabel.copyWith(
            color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: fontSize * 0.8, // Reduz ainda mais o tamanho
            letterSpacing: 0.3,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: AppColors.backgroundDark.withOpacity(0.8),
                offset: const Offset(0.5, 0.5),
              ),
            ],
          ),
        );
        
        final adjustedTextPainter = TextPainter(
          text: adjustedTextSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        );
        
        adjustedTextPainter.layout();
        
        canvas.save();
        canvas.translate(textCenter.dx, textCenter.dy);
        
        // Rotação para ficar paralelo ao raio
        double rotation = textAngle;
        if (textAngle > pi / 2 && textAngle < 3 * pi / 2) {
          rotation += pi;
        }
        
        canvas.rotate(rotation);
        
        adjustedTextPainter.paint(
          canvas,
          Offset(-adjustedTextPainter.width / 2, -adjustedTextPainter.height / 2),
        );
        canvas.restore();
      } else {
        canvas.save();
        canvas.translate(textCenter.dx, textCenter.dy);
        
        // Rotação para ficar paralelo ao raio
        double rotation = textAngle;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
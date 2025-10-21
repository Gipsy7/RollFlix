import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:rollflix/l10n/app_localizations.dart';

class GenreWheel extends StatefulWidget {
  final List<String> genres;
  final String? selectedGenre;
  final Function(String) onGenreSelected;
  final VoidCallback? onRandomSpin;
  final VoidCallback? onRollContent;
  final bool isLoadingContent;
  final Color? accentColor;
  final bool isSeriesMode;

  const GenreWheel({
    super.key,
    required this.genres,
    this.selectedGenre,
    required this.onGenreSelected,
    this.onRandomSpin,
    this.onRollContent,
    this.isLoadingContent = false,
    this.accentColor,
    this.isSeriesMode = false,
  });

  @override
  State<GenreWheel> createState() => _GenreWheelState();
}

class _GenreWheelState extends State<GenreWheel>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _pendulumController;
  late Animation<double> _scrollAnimation;
  late Animation<double> _pendulumAnimation;
  
  double _currentScroll = 0.0;
  double _velocity = 0.0;
  bool _isSpinning = false;
  bool _isPendulumActive = false;

  // Getter para cor primária dinâmica
  Color get primaryColor => widget.accentColor ?? AppColors.primary;

  void _setInitialPosition() {
    if (widget.selectedGenre != null && widget.genres.isNotEmpty) {
      final selectedIndex = widget.genres.indexOf(widget.selectedGenre!);
      if (selectedIndex != -1) {
        _currentScroll = selectedIndex.toDouble();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    
    _scrollController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    
    _pendulumController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Configura posição inicial baseada no gênero selecionado
    _setInitialPosition();
    
    _scrollAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scrollController,
      curve: Curves.easeOutCubic,
    ));
    
    _pendulumAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pendulumController,
      curve: Curves.easeOutCirc,
    ));
    
    _scrollController.addListener(() {
      setState(() {
        _currentScroll = _scrollAnimation.value;
      });
    });
    
    _pendulumController.addListener(() {
      if (_isPendulumActive) {
        setState(() {
          _currentScroll = _pendulumAnimation.value;
        });
      }
    });
    
    _scrollController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
        });
        // Ajusta a posição final para garantir centralização perfeita
        _snapToCenter();
        _selectCenterGenre();
      }
    });
    
    _pendulumController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isPendulumActive = false;
        });
        _selectCenterGenre();
      }
    });
  }

  @override
  void didUpdateWidget(GenreWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Se o gênero selecionado mudou externamente, atualiza a posição
    if (widget.selectedGenre != oldWidget.selectedGenre && 
        widget.selectedGenre != null && 
        !_isSpinning && 
        !_isPendulumActive) {
      _setInitialPosition();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pendulumController.dispose();
    super.dispose();
  }

  void _spinFilmReel() {
    if (_isSpinning || widget.genres.isEmpty) return;
    
    // Para qualquer animação de pêndulo ativa
    _pendulumController.stop();
    
    setState(() {
      _isSpinning = true;
      _isPendulumActive = false;
    });
    
    // Seleciona um gênero aleatório
    final random = Random();
    final selectedGenreIndex = random.nextInt(widget.genres.length);
    
    // Calcula a posição atual em termos de "slots de gênero"
    final currentPosition = _currentScroll;
    
    // Calcula voltas extras para dar efeito de rolagem (em número de gêneros)
    final extraSpins = (3 + random.nextDouble() * 3) * widget.genres.length;
    
    // Calcula a posição final para centralizar o gênero selecionado
    // A posição final deve ser um número inteiro para ficar perfeitamente centralizado
    final targetPosition = currentPosition + extraSpins + (selectedGenreIndex - (currentPosition % widget.genres.length));
    
    _scrollAnimation = Tween<double>(
      begin: _currentScroll,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _scrollController,
      curve: Curves.easeOutQuart,
    ));
    
    _scrollController.reset();
    _scrollController.forward();
    
    widget.onRandomSpin?.call();
  }

  void _selectCenterGenre() {
    if (widget.genres.isEmpty) return;
    
    // Calcula qual gênero está centralizado baseado na posição atual
    final currentIndex = _currentScroll.round();
    final centerIndex = ((currentIndex % widget.genres.length) + widget.genres.length) % widget.genres.length;
    final selectedGenre = widget.genres[centerIndex];
    
    // Só chama onGenreSelected se o gênero realmente mudou
    if (widget.selectedGenre != selectedGenre) {
      widget.onGenreSelected(selectedGenre);
    }
  }

  void _snapToCenter() {
    if (widget.genres.isEmpty) return;
    
    // Arredonda a posição atual para o gênero mais próximo
    final nearestPosition = _currentScroll.round().toDouble();
    
    setState(() {
      _currentScroll = nearestPosition;
    });
  }

  void _handlePanStart(DragStartDetails details) {
    if (_isSpinning) return;
    
    // Para qualquer animação de pêndulo ativa
    _pendulumController.stop();
    setState(() {
      _isPendulumActive = false;
      _velocity = 0.0;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isSpinning) return;
    
    setState(() {
      // Movimento horizontal - agora em unidades de gêneros
      // Ajusta a sensibilidade para que o movimento seja proporcional ao espaçamento
      final sensitivity = 0.005 * (120.0 / 120.0); // Normalizado para o espaçamento
      final deltaScroll = -details.delta.dx * sensitivity;
      _currentScroll += deltaScroll;
      
      // Calcula a velocidade para o efeito de momentum
      _velocity = deltaScroll;
    });
    
    _selectCenterGenre();
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_isSpinning) return;
    
    // Ativa o efeito de pêndulo baseado na velocidade
    _startPendulumEffect();
  }

  void _startPendulumEffect() {
    // Calcula a posição mais próxima do centro (efeito de gravidade)
    final currentPosition = _currentScroll;
    final nearestPosition = currentPosition.round().toDouble();
    
    // Considera a velocidade para o momentum
    final momentumDistance = _velocity * 30; // Multiplica a velocidade para dar mais momentum
    final targetWithMomentum = currentPosition + momentumDistance;
    final finalTarget = targetWithMomentum.round().toDouble();
    
    // Se a diferença for pequena, vai direto para o centro
    final difference = (currentPosition - nearestPosition).abs();
    final target = difference < 0.1 ? nearestPosition : finalTarget;
    
    _pendulumAnimation = Tween<double>(
      begin: currentPosition,
      end: target,
    ).animate(CurvedAnimation(
      parent: _pendulumController,
      curve: Curves.easeOutCirc, // Curva mais suave
    ));
    
    setState(() {
      _isPendulumActive = true;
    });
    
    _pendulumController.reset();
    _pendulumController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isSpinning || widget.genres.isEmpty) return;
    
    // Obtém a posição do toque na tela
    final tapX = details.localPosition.dx;
    final screenWidth = context.size?.width ?? 0;
    final centerX = screenWidth / 2;
    
    // Calcula qual gênero foi clicado baseado na posição
    final genreSpacing = 120.0;
    final scrollPixels = _currentScroll * genreSpacing;
    
    // Calcula o offset do toque em relação ao centro
    final offsetFromCenter = tapX - centerX;
    
    // Calcula qual índice de gênero foi clicado
    final clickedGenreOffset = (scrollPixels + offsetFromCenter) / genreSpacing;
    final clickedGenreIndex = clickedGenreOffset.round();
    
    // Calcula a diferença entre a posição atual e a posição do gênero clicado
    final targetScroll = clickedGenreIndex.toDouble();
    
    // Anima suavemente até o gênero clicado
    _animateToPosition(targetScroll);
  }

  void _animateToPosition(double targetPosition) {
    // Para qualquer animação ativa
    _scrollController.stop();
    _pendulumController.stop();
    
    setState(() {
      _isPendulumActive = false;
    });
    
    // Configura a animação para a nova posição
    _pendulumAnimation = Tween<double>(
      begin: _currentScroll,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _pendulumController,
      curve: Curves.easeOutCirc,
    ));
    
    setState(() {
      _isPendulumActive = true;
    });
    
    _pendulumController.reset();
    _pendulumController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // Rolo de filme principal
          GestureDetector(
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onTapUp: _handleTapUp,
            child: CustomPaint(
              size: Size(double.infinity, 200),
              painter: FilmReelPainter(
                genres: widget.genres,
                scrollOffset: _currentScroll,
                selectedGenre: widget.selectedGenre,
                accentColor: primaryColor,
              ),
            ),
          ),
          
          // Botões de ação
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Botão de rolar filme/série
                if (widget.onRollContent != null && widget.selectedGenre != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: widget.isLoadingContent ? null : widget.onRollContent,
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.isLoadingContent 
                                  ? Icons.refresh 
                                  : (widget.isSeriesMode ? Icons.tv : Icons.local_movies),
                              color: AppColors.backgroundDark,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isLoadingContent 
                                  ? AppLocalizations.of(context)!.rolling 
                                  : widget.isSeriesMode 
                                      ? AppLocalizations.of(context)!.rollSeries 
                                      : AppLocalizations.of(context)!.rollMovie,
                              style: TextStyle(
                                color: AppColors.backgroundDark,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                // Botão de sorteio de gênero
                GestureDetector(
                  onTap: _spinFilmReel,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha:0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isSpinning
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: AppColors.backgroundDark,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rolando...',
                                style: TextStyle(
                                  color: AppColors.backgroundDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shuffle,
                                color: AppColors.backgroundDark,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.rollGenre,
                                style: TextStyle(
                                  color: AppColors.backgroundDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          
          // Indicador do centro
          Center(
            child: Container(
              width: 4,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha:0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilmReelPainter extends CustomPainter {
  final List<String> genres;
  final double scrollOffset;
  final String? selectedGenre;
  final Color accentColor;

  FilmReelPainter({
    required this.genres,
    required this.scrollOffset,
    this.selectedGenre,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (genres.isEmpty) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Desenha o fundo do rolo de filme
    _drawFilmBackground(canvas, size);
    
    // Desenha os círculos de gêneros
    _drawGenreCircles(canvas, center, size);
    
    // Desenha os furos do filme
    _drawFilmHoles(canvas, size);
  }

  void _drawFilmBackground(Canvas canvas, Size size) {
    // Fundo principal do filme - estilo cinema clássico
    // Agora desenha de borda a borda sem margens
    final filmPaint = Paint()
      ..color = AppColors.backgroundDark.withValues(alpha:0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.6),
        const Radius.circular(0), // Sem bordas arredondadas nas laterais
      ),
      filmPaint,
    );
    
    // Bordas superior e inferior do filme - com cor dinâmica
    final borderPaint = Paint()
      ..color = accentColor.withValues(alpha:0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    // Linha superior - vai até as bordas
    canvas.drawLine(
      Offset(0, size.height * 0.2),
      Offset(size.width, size.height * 0.2),
      borderPaint,
    );
    
    // Linha inferior - vai até as bordas
    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.8),
      borderPaint,
    );
  }

  void _drawGenreCircles(Canvas canvas, Offset center, Size size) {
    final genreRadius = 40.0;
    final genreSpacing = 120.0;
    final yPosition = center.dy;
    
    // Calcula o offset horizontal baseado no scroll
    final scrollPixels = scrollOffset * genreSpacing;
    
    // Calcula quantos círculos são necessários para preencher a tela COMPLETA + buffer
    final screenWidth = size.width;
    final circlesOnScreen = (screenWidth / genreSpacing).ceil();
    final bufferCircles = 8; // Buffer ainda maior para garantir cobertura nas bordas
    final totalCirclesToDraw = circlesOnScreen + (bufferCircles * 2);
    
    // Encontra o índice base baseado na posição atual
    final baseIndex = scrollOffset.floor();
    
    // Ajusta o início para cobrir a borda esquerda
    // Calcula quantos círculos cabem à esquerda do centro
    final leftCircles = (center.dx / genreSpacing).ceil() + 2;
    
    // Desenha círculos começando bem antes da borda esquerda
    for (int i = -leftCircles - bufferCircles; i < totalCirclesToDraw - bufferCircles; i++) {
      final currentIndex = baseIndex + i;
      
      // Usa modulo para criar o loop infinito
      final genreIndex = ((currentIndex % genres.length) + genres.length) % genres.length;
      final genre = genres[genreIndex];
      
      final xPosition = center.dx + (currentIndex * genreSpacing) - scrollPixels;
      
      // Desenha se estiver visível ou próximo das bordas
      if (xPosition > -genreRadius * 2 && xPosition < screenWidth + genreRadius * 2) {
        final position = Offset(xPosition, yPosition);
        
        // Determina se é o gênero central (destacado)
        final distanceFromCenter = (xPosition - center.dx).abs();
        final isHighlighted = distanceFromCenter < genreSpacing * 0.3;
        
        _drawGenreCircle(canvas, position, genreRadius, genre, isHighlighted);
      }
    }
  }

  void _drawGenreCircle(Canvas canvas, Offset center, double radius, String genre, bool isHighlighted) {
    // Círculo do gênero com tema cinema clássico
    if (isHighlighted) {
      // Círculo destacado com gradiente
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = LinearGradient(
        colors: [
          accentColor.withValues(alpha:0.8), 
          accentColor, 
          accentColor.withValues(alpha:0.9)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, radius, paint);
      
      // Borda escura para contraste
      final borderPaint = Paint()
        ..color = AppColors.backgroundDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      
      canvas.drawCircle(center, radius, borderPaint);
      
      // Efeito de brilho com cor do tema
      final glowPaint = Paint()
        ..color = accentColor.withValues(alpha:0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius + 2, glowPaint);
    } else {
      // Círculo normal com tema escuro
      final circlePaint = Paint()
        ..color = AppColors.surfaceDark.withValues(alpha:0.9)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, circlePaint);

      // Borda sutil com cor do tema
      final borderPaint = Paint()
        ..color = accentColor.withValues(alpha:0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;      canvas.drawCircle(center, radius, borderPaint);
    }
    
    // Texto do gênero seguindo as regras de cores
    final textSpan = TextSpan(
      text: genre,
      style: TextStyle(
        // Fundo amarelo = texto preto; Fundo preto = texto branco/amarelo
        color: isHighlighted ? AppColors.backgroundDark : AppColors.textPrimary,
        fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
        fontSize: isHighlighted ? 13 : 11,
        shadows: !isHighlighted ? [
          Shadow(
            color: AppColors.backgroundDark.withValues(alpha:0.8),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ] : null,
      ),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );
    
    textPainter.layout(maxWidth: radius * 1.8);
    
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, textOffset);
  }

  void _drawFilmHoles(Canvas canvas, Size size) {
    // Desenha os furos característicos do filme - estilo clássico
    final holePaint = Paint()
      ..color = AppColors.backgroundDark.withValues(alpha:0.8)
      ..style = PaintingStyle.fill;
    
    final holeRadius = 7.0;
    final holeSpacing = 30.0;
    final scrollPixels = scrollOffset * 120.0;
    
    // Calcula o offset dos furos para rolagem infinita
    final holeOffset = scrollPixels % holeSpacing;
    
    // Calcula quantos furos são necessários para cobrir a largura COMPLETA + buffer
    final holesNeeded = (size.width / holeSpacing).ceil() + 6; // Mais buffer para cobrir bordas
    
    // Furos superiores - estilo cinema clássico
    for (int i = -2; i < holesNeeded; i++) { // Começa antes da borda
      final x = (i * holeSpacing) - holeOffset;
      // Desenha mesmo que esteja ligeiramente fora para garantir cobertura total
      if (x > -holeRadius * 2 && x < size.width + holeRadius * 2) {
        canvas.drawCircle(
          Offset(x, size.height * 0.1),
          holeRadius,
          holePaint,
        );
        
        // Borda com cor do tema para furos superiores
        final borderPaint = Paint()
          ..color = accentColor.withValues(alpha:0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        
        canvas.drawCircle(
          Offset(x, size.height * 0.1),
          holeRadius,
          borderPaint,
        );
      }
    }
    
    // Furos inferiores - estilo cinema clássico
    for (int i = -2; i < holesNeeded; i++) { // Começa antes da borda
      final x = (i * holeSpacing) - holeOffset;
      // Desenha mesmo que esteja ligeiramente fora para garantir cobertura total
      if (x > -holeRadius * 2 && x < size.width + holeRadius * 2) {
        canvas.drawCircle(
          Offset(x, size.height * 0.9),
          holeRadius,
          holePaint,
        );
        
        // Borda com cor do tema para furos inferiores
        final borderPaint = Paint()
          ..color = accentColor.withValues(alpha:0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        
        canvas.drawCircle(
          Offset(x, size.height * 0.9),
          holeRadius,
          borderPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
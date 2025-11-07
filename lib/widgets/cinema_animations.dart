import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../core/constants/constants.dart';

class ProjectorAnimation extends StatefulWidget {
  final double size;
  final bool isAnimating;
  
  const ProjectorAnimation({
    super.key,
    this.size = 80,
    this.isAnimating = true,
  });

  @override
  State<ProjectorAnimation> createState() => _ProjectorAnimationState();
}

class _ProjectorAnimationState extends State<ProjectorAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _lightController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _lightAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: AppDurations.cinemaLong, // Mais lento para suavidade
      vsync: this,
    );

    _lightController = AnimationController(
      duration: AppDurations.cinemaMedium, // Mais lento
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut, // Curva mais suave
    ));

    _lightAnimation = Tween<double>(
      begin: 0.2, // Menos escuro
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lightController,
      curve: Curves.easeInOutCubic, // Curva mais sofisticada
    ));
    
    if (widget.isAnimating) {
      _rotationController.repeat();
      _lightController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Projector Light Beam
          AnimatedBuilder(
            animation: _lightAnimation,
            builder: (context, child) {
              return Container(
                width: widget.size * 1.5,
                height: widget.size * 0.3,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.projectorLight.withValues(alpha:_lightAnimation.value * 0.6),
                      AppColors.projectorLight.withValues(alpha:_lightAnimation.value * 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Projector Body
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: ProjectorPainter(),
          ),
          
          // Film Reel
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: CustomPaint(
                  size: Size(widget.size * 0.4, widget.size * 0.4),
                  painter: FilmReelPainter(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProjectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.filmStrip
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Main projector body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: size.width * 0.8,
          height: size.height * 0.6,
        ),
        const Radius.circular(8),
      ),
      paint,
    );
    
    // Lens
    paint.color = AppColors.primary;
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.3, center.dy),
      size.width * 0.15,
      paint,
    );
    
    // Lens reflection
    paint.color = AppColors.projectorLight.withValues(alpha:0.8);
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.3, center.dy),
      size.width * 0.1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FilmReelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Outer ring
    canvas.drawCircle(center, radius, paint);
    
    // Inner circle
    paint.color = AppColors.backgroundDark;
    canvas.drawCircle(center, radius * 0.3, paint);
    
    // Spokes
    paint.color = AppColors.primary;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final startX = center.dx + math.cos(angle) * radius * 0.3;
      final startY = center.dy + math.sin(angle) * radius * 0.3;
      final endX = center.dx + math.cos(angle) * radius * 0.9;
      final endY = center.dy + math.sin(angle) * radius * 0.9;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PopcornAnimation extends StatefulWidget {
  final double size;
  final bool isAnimating;
  
  const PopcornAnimation({
    super.key,
    this.size = 60,
    this.isAnimating = true,
  });

  @override
  State<PopcornAnimation> createState() => _PopcornAnimationState();
}

class _PopcornAnimationState extends State<PopcornAnimation>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late List<AnimationController> _kernelControllers;
  late List<Animation<double>> _kernelAnimations;

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: AppDurations.veryLong,
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    // Create individual kernel animations
    _kernelControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      );
    });
    
    _kernelAnimations = _kernelControllers.map((controller) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ));
    }).toList();
    
    if (widget.isAnimating) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _bounceController.repeat(reverse: true);
    
    for (int i = 0; i < _kernelControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) {
          _kernelControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    for (var controller in _kernelControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_bounceAnimation.value),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: PopcornPainter(_kernelAnimations),
            ),
          );
        },
      ),
    );
  }
}

class PopcornPainter extends CustomPainter {
  final List<Animation<double>> kernelAnimations;
  
  PopcornPainter(this.kernelAnimations);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Popcorn container (red striped box)
    paint.color = AppColors.secondary;
    final containerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.2),
        width: size.width * 0.6,
        height: size.height * 0.5,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(containerRect, paint);
    
    // White stripes on container
    paint.color = Colors.white;
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          center.dx - size.width * 0.25,
          center.dy + size.height * 0.1 + (i * 8),
          size.width * 0.5,
          3,
        ),
        paint,
      );
    }
    
    // Popcorn kernels
    paint.color = AppColors.accent;
    final kernelPositions = [
      Offset(center.dx - 8, center.dy - 10),
      Offset(center.dx + 5, center.dy - 15),
      Offset(center.dx - 3, center.dy - 20),
      Offset(center.dx + 10, center.dy - 8),
      Offset(center.dx - 12, center.dy - 25),
    ];
    
    for (int i = 0; i < kernelPositions.length && i < kernelAnimations.length; i++) {
      final animation = kernelAnimations[i];
      final scale = animation.value;
      final position = kernelPositions[i];
      
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.scale(scale);
      
      // Draw irregular popcorn shape
      final path = Path();
      path.addOval(Rect.fromCenter(center: Offset.zero, width: 6, height: 8));
      path.addOval(Rect.fromCenter(center: const Offset(3, -2), width: 5, height: 6));
      path.addOval(Rect.fromCenter(center: const Offset(-2, 3), width: 4, height: 5));
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FilmStripDecoration extends StatelessWidget {
  final Widget child;
  final double height;
  
  const FilmStripDecoration({
    super.key,
    required this.child,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.filmStrip,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.backgroundDark,
            width: 4,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Film perforations
          Positioned.fill(
            child: Row(
              children: List.generate(20, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: child,
          ),
        ],
      ),
    );
  }
}

class CurtainAnimation extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  
  const CurtainAnimation({
    super.key,
    required this.child,
    this.isOpen = true,
  });

  @override
  State<CurtainAnimation> createState() => _CurtainAnimationState();
}

class _CurtainAnimationState extends State<CurtainAnimation>
    with TickerProviderStateMixin {
  late AnimationController _curtainController;
  late Animation<double> _curtainAnimation;

  @override
  void initState() {
    super.initState();
    
    _curtainController = AnimationController(
      duration: AppDurations.cinemaShort,
      vsync: this,
    );
    
    _curtainAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _curtainController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isOpen) {
      _curtainController.forward();
    }
  }

  @override
  void didUpdateWidget(CurtainAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _curtainController.forward();
      } else {
        _curtainController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _curtainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Left curtain
        AnimatedBuilder(
          animation: _curtainAnimation,
          builder: (context, child) {
            return Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.5 * (1 - _curtainAnimation.value),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.curtainRed,
                      AppColors.curtainRed.withValues(alpha:0.8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Right curtain
        AnimatedBuilder(
          animation: _curtainAnimation,
          builder: (context, child) {
            return Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.5 * (1 - _curtainAnimation.value),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      AppColors.curtainRed,
                      AppColors.curtainRed.withValues(alpha:0.8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

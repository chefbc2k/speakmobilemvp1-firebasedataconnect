import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _soundWaveHeights = List.generate(300, (index) => math.Random().nextDouble());
  bool _showOptions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _showOptions = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: SoundWavePainter(
                  animation: _controller,
                  waveHeights: _soundWaveHeights,
                ),
              ),
            ),
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.record);
                  },
                  child: DecoratedBox(
                    decoration: const BoxDecoration(),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [CupertinoColors.systemYellow, Color(0xFF0D47A1)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds);
                      },
                      child: Text(
                        'SPEAK',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w800,
                          color: CupertinoColors.white,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              offset: const Offset(4, 4),
                              color: CupertinoColors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              if (_showOptions) ...[
                const SizedBox(height: 40),
                CupertinoButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
                  color: const Color(0xFF0D47A1),
                  child: const Text(
                    'Explore Dashboard',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap SPEAK to Start Recording',
                  style: TextStyle(
                    color: CupertinoColors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SoundWavePainter extends CustomPainter {
  final Animation<double> animation;
  final List<double> waveHeights;

  SoundWavePainter({required this.animation, required this.waveHeights}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    
    final paint = Paint()
      ..color = const Color.fromARGB(255, 173, 162, 3).withOpacity(0.3)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final totalBars = waveHeights.length;
    const spacing = AppSpacing.xs;
    final barWidth = (size.width - (spacing * (totalBars - 1))) / totalBars;

    try {
      for (int i = 0; i < totalBars; i++) {
        final x = i * (barWidth + spacing);
        final normalizedHeight = (waveHeights[i] * size.height * 0.3).clamp(0.0, size.height / 2);
        final animatedHeight = normalizedHeight * (0.5 + (animation.value * 0.5));
        
        if (x.isFinite && animatedHeight.isFinite) {
          canvas.drawLine(
            Offset(x, centerY - animatedHeight),
            Offset(x, centerY + animatedHeight),
            paint,
          );
        }
      }
    } catch (e) {
      debugPrint('Error during painting: $e');
    }
  }

  @override
  bool shouldRepaint(covariant SoundWavePainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

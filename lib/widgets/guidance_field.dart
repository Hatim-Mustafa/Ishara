import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/guidance.dart';
import '../theme.dart';

/// The full-screen ambient signal.
///
/// Color carries collision meaning, *position* carries direction, and *motion*
/// carries turns and uncertainty — so each dimension is readable on its own.
class GuidanceField extends StatefulWidget {
  const GuidanceField({super.key, required this.guidance});

  final Guidance guidance;

  @override
  State<GuidanceField> createState() => _GuidanceFieldState();
}

class _GuidanceFieldState extends State<GuidanceField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.guidance;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeOut,
      decoration: BoxDecoration(color: _baseColor(g.kind)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        child: KeyedSubtree(
          key: ValueKey<GuidanceKind>(g.kind),
          child: _visualFor(g),
        ),
      ),
    );
  }

  Color _baseColor(GuidanceKind kind) {
    switch (kind) {
      case GuidanceKind.clear:
      case GuidanceKind.turnLeft:
      case GuidanceKind.turnRight:
        return IsharaPalette.clear;
      case GuidanceKind.obstacle:
      case GuidanceKind.halt:
        return IsharaPalette.obstacle;
      case GuidanceKind.reacquiring:
        return IsharaPalette.neutral;
      case GuidanceKind.arrived:
        return IsharaPalette.arrival;
      case GuidanceKind.nudgeLeft:
      case GuidanceKind.nudgeRight:
        return IsharaPalette.clear;
    }
  }

  Widget _visualFor(Guidance g) {
    switch (g.kind) {
      case GuidanceKind.clear:
        return _Breathe(controller: _c, color: IsharaPalette.clearBright);
      case GuidanceKind.nudgeLeft:
        return _SplitField(controller: _c, clearLeft: true, icon: g.icon);
      case GuidanceKind.nudgeRight:
        return _SplitField(controller: _c, clearLeft: false, icon: g.icon);
      case GuidanceKind.turnLeft:
        return _TurnField(controller: _c, right: false);
      case GuidanceKind.turnRight:
        return _TurnField(controller: _c, right: true);
      case GuidanceKind.obstacle:
        return _ObstacleField(controller: _c, icon: g.icon, hard: false);
      case GuidanceKind.halt:
        return _ObstacleField(controller: _c, icon: g.icon, hard: true);
      case GuidanceKind.reacquiring:
        return _ReacquireField(controller: _c, icon: g.icon);
      case GuidanceKind.arrived:
        return _ArrivalField(controller: _c, icon: g.icon);
    }
  }
}

/// A slow, calm "breathing" glow on the clear field.
class _Breathe extends StatelessWidget {
  const _Breathe({required this.controller, required this.color});

  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = 0.5 - 0.5 * math.cos(controller.value * 2 * math.pi);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 0.9 + 0.12 * t,
              colors: <Color>[
                color,
                IsharaPalette.clear,
              ],
            ),
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

/// Clear on one side, obstacle on the other. The clear side is where the user
/// should move, and a chevron reinforces it without relying on color.
class _SplitField extends StatelessWidget {
  const _SplitField({
    required this.controller,
    required this.clearLeft,
    required this.icon,
  });

  final AnimationController controller;
  final bool clearLeft;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final clearSide = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: clearLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: clearLeft ? Alignment.centerLeft : Alignment.centerRight,
          colors: <Color>[
            IsharaPalette.clear,
            IsharaPalette.clearBright,
          ],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final t = 0.5 - 0.5 * math.cos(controller.value * 2 * math.pi);
            return Transform.translate(
              offset: Offset(clearLeft ? -10 * t : 10 * t, 0),
              child: Icon(icon, size: 132, color: IsharaPalette.ink),
            );
          },
        ),
      ),
    );

    final blockedSide = const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF0A3D91), Color(0xFF072B66)],
        ),
      ),
      child: SizedBox.expand(),
    );

    return Row(
      children: <Widget>[
        Expanded(
          flex: clearLeft ? 62 : 38,
          child: clearLeft ? clearSide : blockedSide,
        ),
        Expanded(
          flex: clearLeft ? 38 : 62,
          child: clearLeft ? blockedSide : clearSide,
        ),
      ],
    );
  }
}

/// Alternating blue/orange bars flowing in the direction of the turn.
class _TurnField extends StatelessWidget {
  const _TurnField({required this.controller, required this.right});

  final AnimationController controller;
  final bool right;

  @override
  Widget build(BuildContext context) {
    const double barWidth = 96;
    return LayoutBuilder(
      builder: (context, constraints) {
        final int count = (constraints.maxWidth / barWidth).ceil() + 4;
        return Stack(
          children: <Widget>[
            const Positioned.fill(
              child: ColoredBox(color: IsharaPalette.clear),
            ),
            ClipRect(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final double shift = controller.value * barWidth * 2;
                  final double dx = right ? shift - barWidth * 2 : -(shift - barWidth * 2);
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      maxWidth: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List<Widget>.generate(
                          count,
                          (i) => DecoratedBox(
                            decoration: BoxDecoration(
                              color: i.isEven
                                  ? IsharaPalette.obstacle
                                  : IsharaPalette.clearBright,
                            ),
                            child: SizedBox(
                              width: barWidth,
                              height: constraints.maxHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: IsharaPalette.arrival.withValues(alpha: 0.86),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  right ? Icons.turn_right_rounded : Icons.turn_left_rounded,
                  size: 96,
                  color: IsharaPalette.ink,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Obstacle / halt. [hard] adds the strong alarm pulse reserved for "stop".
class _ObstacleField extends StatelessWidget {
  const _ObstacleField({
    required this.controller,
    required this.icon,
    required this.hard,
  });

  final AnimationController controller;
  final IconData icon;
  final bool hard;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final double t = 0.5 - 0.5 * math.cos(controller.value * 2 * math.pi);
        final double intensity = hard ? 1.0 : 0.35;
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.scale(
              scale: 1 + 0.25 * intensity * t,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12 * intensity * t),
                ),
              ),
            ),
            Icon(icon, size: 168, color: Colors.white),
          ],
        );
      },
    );
  }
}

/// Uncertainty. Deliberately desaturated and slow — never reads as an alarm.
class _ReacquireField extends StatelessWidget {
  const _ReacquireField({required this.controller, required this.icon});

  final AnimationController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        RotationTransition(
          turns: controller,
          child: CustomPaint(
            size: const Size(300, 300),
            painter: _ArcPainter(color: Colors.white.withValues(alpha: 0.75)),
          ),
        ),
        Icon(icon, size: 120, color: Colors.white.withValues(alpha: 0.9)),
      ],
    );
  }
}

/// Arrival. Warm, expanding rings — definitive and relieving.
class _ArrivalField extends StatelessWidget {
  const _ArrivalField({required this.controller, required this.icon});

  final AnimationController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return CustomPaint(
              size: const Size(420, 420),
              painter: _RingsPainter(progress: controller.value),
            );
          },
        ),
        Icon(icon, size: 150, color: IsharaPalette.ink),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: <Color>[color.withValues(alpha: 0), color],
      ).createShader(rect);
    canvas.drawArc(rect.deflate(6), 0, math.pi * 1.4, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double maxRadius = size.shortestSide / 2;
    for (int i = 0; i < 3; i++) {
      final double p = (progress + i / 3) % 1.0;
      final double radius = 60 + p * (maxRadius - 60);
      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = IsharaPalette.clear.withValues(alpha: (1 - p) * 0.8);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

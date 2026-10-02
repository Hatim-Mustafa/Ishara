import 'package:flutter/material.dart';

/// Destination used throughout the mockup.
const String demoDestination = 'Ferry Building';

/// Every distinct thing the system can be telling the user.
///
/// These are deliberately few and instantly distinguishable from one another.
enum GuidanceKind {
  clear,
  nudgeLeft,
  nudgeRight,
  turnLeft,
  turnRight,
  obstacle,
  halt,
  reacquiring,
  arrived,
}

/// Everything the UI needs to render one moment of guidance.
///
/// [title] is the huge glanceable word, [detail] is the one-line subtext,
/// [voice] is what would be spoken/announced, and [haptic] describes the
/// vibration pattern so the demo can surface it.
@immutable
class Guidance {
  final GuidanceKind kind;
  final String title;
  final String detail;
  final String voice;
  final String haptic;
  final IconData icon;

  /// How long this beat lasts during the auto-playing demo walk.
  final Duration dwell;

  const Guidance({
    required this.kind,
    required this.title,
    required this.detail,
    required this.voice,
    required this.haptic,
    required this.icon,
    this.dwell = const Duration(seconds: 3),
  });

  /// A dark foreground reads best on the bright amber/white fields.
  bool get isBrightField =>
      kind == GuidanceKind.clear ||
      kind == GuidanceKind.arrived ||
      kind == GuidanceKind.turnLeft ||
      kind == GuidanceKind.turnRight;
}

/// The scripted walk used by the mockup, in order.
const List<Guidance> demoWalk = <Guidance>[
  Guidance(
    kind: GuidanceKind.clear,
    title: 'Go',
    detail: 'Path clear — keep walking straight',
    voice: 'Path is clear. Keep walking straight.',
    haptic: 'No vibration',
    icon: Icons.arrow_upward_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.nudgeRight,
    title: 'Ease right',
    detail: 'More space on your right — drift gently',
    voice: 'Move slightly to your right.',
    haptic: 'Soft double-tap, right side',
    icon: Icons.arrow_forward_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.clear,
    title: 'Go',
    detail: 'Path clear — keep walking straight',
    voice: 'Path is clear. Keep walking straight.',
    haptic: 'No vibration',
    icon: Icons.arrow_upward_rounded,
    dwell: Duration(seconds: 2),
  ),
  Guidance(
    kind: GuidanceKind.turnRight,
    title: 'Turn right',
    detail: 'Turn right at the corner ahead',
    voice: 'Turn right at the corner.',
    haptic: 'Three quick pulses, then pause',
    icon: Icons.turn_right_rounded,
    dwell: Duration(seconds: 4),
  ),
  Guidance(
    kind: GuidanceKind.clear,
    title: 'Go',
    detail: 'Path clear — keep walking straight',
    voice: 'Path is clear. Keep walking straight.',
    haptic: 'No vibration',
    icon: Icons.arrow_upward_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.obstacle,
    title: 'Obstacle',
    detail: 'Something ahead — slowing you down',
    voice: 'Obstacle ahead. Adjusting your path.',
    haptic: 'Single firm pulse',
    icon: Icons.warning_amber_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.halt,
    title: 'Stop',
    detail: 'Stop now — obstacle directly ahead',
    voice: 'Stop. Obstacle directly ahead.',
    haptic: 'Continuous strong vibration',
    icon: Icons.back_hand_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.clear,
    title: 'Go',
    detail: 'Path clear — keep walking straight',
    voice: 'Path is clear. Keep walking straight.',
    haptic: 'No vibration',
    icon: Icons.arrow_upward_rounded,
    dwell: Duration(seconds: 2),
  ),
  Guidance(
    kind: GuidanceKind.reacquiring,
    title: 'Reconnecting',
    detail: 'Hold still — finding your position again',
    voice: 'Reconnecting. Please hold still for a moment.',
    haptic: 'Slow gentle pulses',
    icon: Icons.sync_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.clear,
    title: 'Go',
    detail: 'Path clear — keep walking straight',
    voice: 'Path is clear. Keep walking straight.',
    haptic: 'No vibration',
    icon: Icons.arrow_upward_rounded,
    dwell: Duration(seconds: 2),
  ),
  Guidance(
    kind: GuidanceKind.nudgeLeft,
    title: 'Ease left',
    detail: 'More space on your left — drift gently',
    voice: 'Move slightly to your left.',
    haptic: 'Soft double-tap, left side',
    icon: Icons.arrow_back_rounded,
    dwell: Duration(seconds: 3),
  ),
  Guidance(
    kind: GuidanceKind.turnLeft,
    title: 'Turn left',
    detail: 'Turn left — you are almost there',
    voice: 'Turn left. You are almost there.',
    haptic: 'Three quick pulses, then pause',
    icon: Icons.turn_left_rounded,
    dwell: Duration(seconds: 4),
  ),
  Guidance(
    kind: GuidanceKind.arrived,
    title: 'Arrived',
    detail: 'You are at your destination',
    voice: 'You have arrived at your destination.',
    haptic: 'Warm rising pattern',
    icon: Icons.check_rounded,
    dwell: Duration(seconds: 4),
  ),
];

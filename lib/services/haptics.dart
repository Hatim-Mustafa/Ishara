import 'package:flutter/services.dart';

import '../models/guidance.dart';

/// Plays a short, distinct vibration pattern for each kind of guidance.
///
/// Real phone motors can't convey direction, so vibration is reserved for
/// discrete, attention-worthy events (turns, halts, reconnection, arrival).
/// Color carries the spatial information continuously.
Future<void> playGuidanceHaptic(GuidanceKind kind) async {
  switch (kind) {
    case GuidanceKind.clear:
      break;
    case GuidanceKind.nudgeLeft:
    case GuidanceKind.nudgeRight:
      await HapticFeedback.selectionClick();
      await Future<void>.delayed(const Duration(milliseconds: 90));
      await HapticFeedback.selectionClick();
      break;
    case GuidanceKind.turnLeft:
    case GuidanceKind.turnRight:
      for (int i = 0; i < 3; i++) {
        await HapticFeedback.mediumImpact();
        await Future<void>.delayed(const Duration(milliseconds: 130));
      }
      break;
    case GuidanceKind.obstacle:
      await HapticFeedback.mediumImpact();
      break;
    case GuidanceKind.halt:
      for (int i = 0; i < 6; i++) {
        await HapticFeedback.heavyImpact();
        await Future<void>.delayed(const Duration(milliseconds: 110));
      }
      break;
    case GuidanceKind.reacquiring:
      for (int i = 0; i < 2; i++) {
        await HapticFeedback.lightImpact();
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
      break;
    case GuidanceKind.arrived:
      await HapticFeedback.lightImpact();
      await Future<void>.delayed(const Duration(milliseconds: 160));
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 160));
      await HapticFeedback.heavyImpact();
      break;
  }
}

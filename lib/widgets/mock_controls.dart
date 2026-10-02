import 'package:flutter/material.dart';

/// Demo-only transport for walking through the scripted guidance states.
class MockControls extends StatelessWidget {
  const MockControls({
    super.key,
    required this.stateLabel,
    required this.index,
    required this.total,
    required this.playing,
    required this.finished,
    required this.onPrevious,
    required this.onNext,
    required this.onTogglePlay,
    required this.onVibrate,
  });

  final String stateLabel;
  final int index;
  final int total;
  final bool playing;
  final bool finished;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTogglePlay;
  final VoidCallback onVibrate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F14).withValues(alpha: 0.78),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.science_rounded,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Demo walk-through',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${index + 1}/$total · $stateLabel',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _ControlButton(
                  icon: Icons.skip_previous_rounded,
                  label: 'Back',
                  onTap: index == 0 ? null : onPrevious,
                ),
                _ControlButton(
                  icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  label: playing ? 'Pause' : 'Auto',
                  highlighted: playing,
                  onTap: onTogglePlay,
                ),
                _ControlButton(
                  icon: finished
                      ? Icons.flag_rounded
                      : Icons.skip_next_rounded,
                  label: finished ? 'Finish' : 'Next',
                  onTap: onNext,
                ),
                _ControlButton(
                  icon: Icons.vibration_rounded,
                  label: 'Buzz',
                  onTap: onVibrate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    final Color fg = enabled ? Colors.white : Colors.white24;
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 42,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: highlighted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withValues(alpha: 0.10),
                ),
                child: Icon(icon, color: fg, size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: enabled ? Colors.white70 : Colors.white24,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

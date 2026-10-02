import 'dart:async';

import 'package:flutter/material.dart';

import '../models/guidance.dart';
import '../services/haptics.dart';
import '../theme.dart';
import '../widgets/guidance_field.dart';
import '../widgets/mock_controls.dart';
import 'arrival_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _index = 0;
  bool _playing = false;
  Timer? _timer;

  Guidance get _current => demoWalk[_index];
  bool get _finished => _index == demoWalk.length - 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playGuidanceHaptic(_current.kind);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goTo(int index) {
    final int next = index.clamp(0, demoWalk.length - 1);
    if (next == _index) return;
    setState(() => _index = next);
    playGuidanceHaptic(_current.kind);
  }

  void _next() {
    if (_finished) {
      _finish();
      return;
    }
    _goTo(_index + 1);
  }

  void _previous() => _goTo(_index - 1);

  void _togglePlay() {
    if (_playing) {
      _stop();
    } else if (_finished) {
      _finish();
    } else {
      setState(() => _playing = true);
      _scheduleNext();
    }
  }

  void _scheduleNext() {
    _timer?.cancel();
    _timer = Timer(_current.dwell, () {
      if (!mounted) return;
      if (_finished) {
        _stop();
        return;
      }
      _goTo(_index + 1);
      _scheduleNext();
    });
  }

  void _stop() {
    _timer?.cancel();
    if (mounted) setState(() => _playing = false);
  }

  void _finish() {
    _stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ArrivalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Guidance g = _current;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: GuidanceField(guidance: g)),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SafeArea(bottom: false, child: _TopBar(guidance: g)),
                const Spacer(),
                _CenterMessage(guidance: g),
                const Spacer(),
                _HapticRow(guidance: g),
                const SizedBox(height: 12),
                MockControls(
                  stateLabel: g.title,
                  index: _index,
                  total: demoWalk.length,
                  playing: _playing,
                  finished: _finished,
                  onPrevious: _previous,
                  onNext: _next,
                  onTogglePlay: _togglePlay,
                  onVibrate: () => playGuidanceHaptic(g.kind),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.guidance});

  final Guidance guidance;

  @override
  Widget build(BuildContext context) {
    final bool uncertain = guidance.kind == GuidanceKind.reacquiring;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: <Widget>[
          _Chip(
            icon: Icons.place_rounded,
            label: demoDestination,
            background: Colors.black.withValues(alpha: 0.40),
            foreground: Colors.white,
          ),
          const Spacer(),
          _Chip(
            icon: uncertain ? Icons.sync_rounded : Icons.gps_fixed_rounded,
            label: uncertain ? 'Reconnecting' : 'Tracking',
            background: uncertain
                ? Colors.black.withValues(alpha: 0.40)
                : IsharaPalette.clearBright.withValues(alpha: 0.92),
            foreground: uncertain ? Colors.white70 : IsharaPalette.ink,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.guidance});

  final Guidance guidance;

  @override
  Widget build(BuildContext context) {
    final bool bright = guidance.isBrightField;
    final Color foreground = bright ? IsharaPalette.ink : Colors.white;
    return Semantics(
      liveRegion: true,
      label: '${guidance.title}. ${guidance.detail}.',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          decoration: BoxDecoration(
            color: bright
                ? Colors.white.withValues(alpha: 0.58)
                : Colors.black.withValues(alpha: 0.34),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                guidance.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 62,
                  height: 1.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                guidance.detail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: foreground.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HapticRow extends StatelessWidget {
  const _HapticRow({required this.guidance});

  final Guidance guidance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.vibration_rounded,
                color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(
              guidance.haptic,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

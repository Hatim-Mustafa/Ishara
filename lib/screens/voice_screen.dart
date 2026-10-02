import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/guidance.dart';
import '../theme.dart';
import 'route_preview_screen.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  Timer? _timer;
  bool _listening = true;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _startListening();
  }

  void _startListening() {
    _timer?.cancel();
    setState(() => _listening = true);
    _c.repeat();
    _timer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      setState(() => _listening = false);
      _c.stop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destination')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 12),
              Text(
                _listening ? 'Listening…' : 'Got it.',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: IsharaPalette.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _listening
                    ? 'Say where you want to go.'
                    : 'Tap the mic to say it again.',
                style: const TextStyle(fontSize: 17, color: Colors.black54),
              ),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _MicOrb(controller: _c, listening: _listening),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _listening
                    ? const SizedBox(height: 116)
                    : _TranscriptCard(destination: demoDestination),
              ),
              const SizedBox(height: 20),
              if (!_listening)
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RoutePreviewScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.route_rounded),
                  label: const Text('Find my route'),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text('Stop listening'),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _startListening,
                child: const Text('Try again'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _MicOrb extends StatelessWidget {
  const _MicOrb({required this.controller, required this.listening});

  final AnimationController controller;
  final bool listening;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final double t = 0.5 - 0.5 * math.cos(controller.value * 2 * math.pi);
        final double ringScale = listening ? 1 + 0.35 * t : 1.0;
        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: ringScale,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: IsharaPalette.clear.withValues(
                      alpha: listening ? 0.28 * (1 - t) + 0.08 : 0.10,
                    ),
                  ),
                ),
              ),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      IsharaPalette.clearBright,
                      IsharaPalette.clear,
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: IsharaPalette.clear.withValues(alpha: 0.45),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  listening ? Icons.mic_rounded : Icons.check_rounded,
                  size: 64,
                  color: IsharaPalette.ink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TranscriptCard extends StatelessWidget {
  const _TranscriptCard({required this.destination});

  final String destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('transcript'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.format_quote_rounded, color: IsharaPalette.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '“Take me to the $demoDestination”',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: IsharaPalette.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Heard clearly · 1 destination',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

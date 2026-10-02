import 'package:flutter/material.dart';

import '../theme.dart';
import 'voice_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              Center(
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
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
                        blurRadius: 40,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.signpost_rounded,
                    size: 68,
                    color: IsharaPalette.ink,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Ishara',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: IsharaPalette.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Navigation you can feel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              _Legend(),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const VoiceScreen(),
                  ),
                ),
                icon: const Icon(Icons.mic_rounded),
                label: const Text('Tell us where to go'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pair with your cane or guide dog — Ishara guides alongside you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'What the colors mean',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          SizedBox(height: 12),
          _LegendRow(
            color: IsharaPalette.clearBright,
            title: 'Warm / bright',
            body: 'Clear path — keep going',
          ),
          SizedBox(height: 10),
          _LegendRow(
            color: IsharaPalette.obstacle,
            title: 'Deep blue',
            body: 'Obstacle — stop or move aside',
          ),
          SizedBox(height: 10),
          _LegendRow(
            color: Colors.white,
            border: Color(0x22000000),
            title: 'Position & motion',
            body: 'Side + movement show direction',
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.title,
    required this.body,
    this.border,
  });

  final Color color;
  final Color? border;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: border == null ? null : Border.all(color: border!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                  text: '$title  ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: body,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

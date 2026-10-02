import 'package:flutter/material.dart';

import '../models/guidance.dart';
import '../theme.dart';
import 'navigation_screen.dart';

class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your route')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      _RouteSummaryCard(destination: demoDestination),
                      const SizedBox(height: 22),
                      const Text(
                        'You’ll be guided turn by turn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: IsharaPalette.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _StepTile(
                        icon: Icons.straight_rounded,
                        title: 'Walk straight to the crossing',
                        sub: 'About 400 m',
                      ),
                      const _StepTile(
                        icon: Icons.turn_right_rounded,
                        title: 'Turn right onto the promenade',
                        sub: 'Follow the warm glow',
                      ),
                      const _StepTile(
                        icon: Icons.straight_rounded,
                        title: 'Continue past the market stalls',
                        sub: 'We’ll warn you about obstacles',
                      ),
                      const _StepTile(
                        icon: Icons.flag_rounded,
                        title: 'Arrive at the $demoDestination',
                        sub: 'We’ll tell you when you’re there',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: IsharaPalette.clear.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.info_outline_rounded,
                                color: IsharaPalette.ink),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Hold your phone out in front of you. '
                                'Vibration will warn you to stop.',
                                style: TextStyle(fontSize: 14, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NavigationScreen(),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Begin walking'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  const _RouteSummaryCard({required this.destination});

  final String destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IsharaPalette.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.place_rounded, color: IsharaPalette.clearBright),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const <Widget>[
              _Stat(value: '1.2 km', label: 'distance'),
              _Stat(value: '16 min', label: 'walk'),
              _Stat(value: '4', label: 'guidance points'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.icon,
    required this.title,
    required this.sub,
  });

  final IconData icon;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x11000000)),
            ),
            child: Icon(icon, color: IsharaPalette.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: IsharaPalette.ink,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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

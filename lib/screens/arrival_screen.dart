import 'package:flutter/material.dart';

import '../models/guidance.dart';
import '../theme.dart';
import '../widgets/guidance_field.dart';
import 'welcome_screen.dart';

class ArrivalScreen extends StatelessWidget {
  const ArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GuidanceField(guidance: demoWalk.last),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 3),
                    Semantics(
                      liveRegion: true,
                      label: 'You have arrived at $demoDestination.',
                      child: Column(
                        children: const <Widget>[
                          Text(
                            'You’ve arrived',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: IsharaPalette.ink,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            demoDestination,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 4),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      ),
                      icon: const Icon(Icons.done_all_rounded),
                      label: const Text('Done'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

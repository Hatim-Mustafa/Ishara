# Ishara

**Navigation you can feel.**

Ishara is a Flutter mockup of an assistive navigation app for visually impaired
users. The user speaks a destination, the app builds a path, then guides them
along it through **color on the screen** and **vibration**, leaving the audio
channel free for the world around them.

> This repository is a **UX mockup**. Routing, voice recognition, and obstacle
> detection are simulated. The goal is to demonstrate the interaction model, not
> the navigation engine.

---

## The idea

1. Open the app and **say where you want to go**.
2. The app confirms the destination and shows the route.
3. Hold the phone out in front. As you walk, a full-screen **ambient color field**
   tells you what to do at a glance, and **vibration** warns you when to stop.
4. Reaching the destination is announced with its own warm, distinct state.

Ishara is designed to work **alongside** a cane or guide dog — an extra layer of
information, not a replacement.

---

## What the guidance means

| State | Screen | Vibration |
| --- | --- | --- |
| **Clear** | Bright amber, softly breathing | none |
| **Ease left / right** | Amber on the side to move toward, blue on the other side, sliding chevron | soft double-tap |
| **Turn left / right** | Alternating amber/blue bars flowing in the turn direction | three quick pulses |
| **Obstacle** | Deep blue with a warning | single firm pulse |
| **Halt** | Deep blue with a strong alarm pulse | continuous strong vibration |
| **Reconnecting** | Desaturated slate with a slow scanning arc | slow gentle pulses |
| **Arrived** | Warm field with expanding rings | rising pattern |

---

## Design principles

- **Never ambiguous.** Every state must be instantly distinguishable from every
  other.
- **Blue / orange by design.** The pairing sits on the red–green axis that trips
  up the most common color blindness, and the two extremes give strong luminance
  contrast.
- **Color is only one channel.** *Position* (which side is clear) and *motion*
  (turn direction, uncertainty) each carry meaning on their own, so the signal
  survives color-insensitive eyes, glare, and peripheral vision.
- **Calm by default, alarm by exception.** Only `halt` pulses hard, so alarm
  always means something.
- **Continuous, not silent.** If the system loses confidence it says
  *Reconnecting* rather than going quiet.
- **Fast permission to trust.** The user must be able to tell within a second
  that the system is working.
- **Glanceable.** Huge text and screen-reader live regions accompany the visual
  field.

---

## Running the mockup

```bash
flutter pub get
flutter run
```

Then:
1. Tap **Tell us where to go** and watch the voice step resolve.
2. Review the route and tap **Begin walking**.
3. Use the **demo controls** at the bottom of the navigation screen:
   - **Back / Next** step through every guidance state
   - **Auto / Pause** plays the whole scripted walk
   - **Buzz** replays the current state's vibration pattern

> Vibration uses the device's real haptics (`HapticFeedback`). On a simulator or
> desktop it will be a no-op; the **Buzz** button and the on-screen haptic label
> show what would fire.

### Tests

```bash
flutter analyze
flutter test
```

---

## Project structure

```
lib/
  main.dart                     app entry point
  theme.dart                    palette + theme (color-blind-safe colors)
  models/
    guidance.dart               guidance states + the scripted demo walk
  screens/
    welcome_screen.dart         brand, legend, start
    voice_screen.dart           spoken destination + confirmation
    route_preview_screen.dart   route summary and steps
    navigation_screen.dart      the core ambient guidance experience
    arrival_screen.dart         destination reached
  services/
    haptics.dart                vibration pattern per guidance state
  widgets/
    guidance_field.dart         full-screen visuals for every state
    mock_controls.dart          demo transport (back / auto / next / buzz)
```

The guidance model lives in [`lib/models/guidance.dart`](lib/models/guidance.dart)
— each state carries its glanceable title, subtext, spoken line, and haptic
description. The scripted walk used by the demo is `demoWalk` in the same file.

---

## Status

Mockup / prototype. Not yet wired to real maps, speech recognition, computer
vision, or turn-by-turn routing. Not a certified mobility aid.

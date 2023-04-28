// ignore_for_file: implementation_imports

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequencer/models/instrument.dart';
import 'package:flutter_sequencer/sequence.dart';
import 'package:flutter_turtle/flutter_turtle.dart';
import 'package:lindenmayer_systems/src/lindenmayer_systems/dol_system/dol_system.dart';
import 'package:lindenmayer_systems/src/production_rules/production_rule.dart';

final dragonCurve = DolSystem(
  alphabet: ['F', 'X', '+', '-', 'Y'],
  axiom: 'FX',
  productionRuleSet: {
    ProductionRule(predecessor: 'X', successor: 'X+YF+'),
    ProductionRule(predecessor: 'Y', successor: '-FX-Y'),
  },
);

const midiCSharpScale = [
  49,
  51,
  52,
  54,
  56,
  58,
  60,
  61,
  63,
  64,
  66,
  68,
  70,
  72,
  73,
  75,
  76,
  78,
  80,
  82,
  84,
];

class DragonCurve extends StatefulWidget {
  const DragonCurve({
    Key? key,
  }) : super(key: key);

  @override
  State<DragonCurve> createState() => _DragonCurveState();
}

class _DragonCurveState extends State<DragonCurve> {
  @override
  Widget build(BuildContext context) {
    final sentence = dragonCurve.generate(12);
    final commands = <TurtleCommand>[
      PenDown(),
      SetColor(
        (_) => Colors.pink,
      ),
      SetStrokeWidth(
        (_) => 2,
      ),
    ];
    for (int i = 0; i < sentence.length; i++) {
      String character = sentence[i];
      if (character == 'F') commands.add(Forward((_) => 5.0));
      if (character == '-') commands.add(Right((_) => 90.0));
      if (character == '+') commands.add(Left((_) => 90.0));
    }
    final sequence = Sequence(
      tempo: 120,
      endBeat: sentence.length.toDouble(),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            sequence.pause();
            sequence.stop();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        title: const Text('Dragon Curve'),
        actions: <Widget>[
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text(
              'Animation',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              final instrument = SfzInstrument(
                path: 'assets/sfz/GMPiano.sfz',
                isAsset: true,
                tuningPath: "assets/sfz/meanquar.scl",
              );
              await sequence.createTracks(
                [
                  instrument,
                ],
              );
              int firstVoice = midiCSharpScale.last;
              int secondVoice = midiCSharpScale.first;
              double firstVoiceCurrentBeat = 0.0;
              double secondVoiceCurrentBeat = 0.0;
              final firstVoiceTrack = sequence.getTracks().first;
              final secondVoiceTrack = sequence.getTracks().last;
              const firstVoiceVelocity = 1.0;
              const secondVoiceVelocity = 0.5;
              for (int i = 0; i < sentence.length; i++) {
                String character = sentence[i];
                if (character == 'F') {
                  firstVoiceTrack.addNote(
                    noteNumber: firstVoice,
                    velocity: firstVoiceVelocity,
                    startBeat: firstVoiceCurrentBeat,
                    durationBeats: 0.5,
                  );
                  if (i % 2 == 0) {
                    firstVoiceCurrentBeat += 0.25;
                  } else {
                    firstVoiceCurrentBeat += 0.5;
                  }
                  secondVoiceTrack.addNote(
                    noteNumber: secondVoice,
                    velocity: secondVoiceVelocity,
                    startBeat: secondVoiceCurrentBeat,
                    durationBeats: 1.0,
                  );
                  secondVoiceCurrentBeat += 0.5;
                }
                if (character == '-') {
                  if (firstVoice != midiCSharpScale.first) {
                    firstVoice = midiCSharpScale[
                        midiCSharpScale.indexOf(firstVoice) - 1];
                  } else {
                    firstVoice = midiCSharpScale.first;
                  }
                  if (secondVoice != midiCSharpScale.first) {
                    secondVoice = midiCSharpScale[
                        midiCSharpScale.indexOf(secondVoice) - 1];
                  } else {
                    secondVoice = midiCSharpScale.first;
                  }
                }
                if (character == '+') {
                  if (firstVoice != midiCSharpScale.last) {
                    firstVoice = midiCSharpScale[Random().nextInt(20)];
                  } else {
                    firstVoice = midiCSharpScale.last;
                  }
                  if (secondVoice != midiCSharpScale.last) {
                    secondVoice = midiCSharpScale[
                        midiCSharpScale.indexOf(secondVoice) + 1];
                  } else {
                    secondVoice = midiCSharpScale.last;
                  }
                }
              }
              sequence.play();
            },
            child: const Text(
              'Music',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ClipRect(
        child: AnimatedTurtleView(
          animationDuration: const Duration(seconds: 15),
          commands: commands,
          child: Container(),
        ),
      ),
    );
  }
}

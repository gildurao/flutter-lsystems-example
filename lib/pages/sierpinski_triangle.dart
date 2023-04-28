// ignore_for_file: implementation_imports

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequencer/models/instrument.dart';
import 'package:flutter_sequencer/sequence.dart';
import 'package:flutter_turtle/flutter_turtle.dart';
import 'package:lindenmayer_systems/src/lindenmayer_systems/dol_system/dol_system.dart';
import 'package:lindenmayer_systems/src/production_rules/production_rule.dart';

final sierpsinkiTriangle = DolSystem(
  alphabet: ['F', 'G', '+', '-'],
  axiom: 'F-G-G',
  productionRuleSet: {
    ProductionRule(predecessor: 'F', successor: 'F-G+F+G-F'),
    ProductionRule(predecessor: 'G', successor: 'GG'),
  },
);

const midiCScale = [60, 62, 64, 65, 67, 69, 71, 72];

class SierpinskiTriangle extends StatefulWidget {
  const SierpinskiTriangle({
    Key? key,
  }) : super(key: key);

  @override
  State<SierpinskiTriangle> createState() => _SierpinskiTriangleState();
}

class _SierpinskiTriangleState extends State<SierpinskiTriangle> {
  @override
  Widget build(BuildContext context) {
    final sentence = sierpsinkiTriangle.generate(5);
    final commands = <TurtleCommand>[
      PenDown(),
      SetColor(
        (_) => Colors.lightGreen,
      ),
      SetStrokeWidth(
        (_) => 2,
      ),
    ];
    for (int i = 0; i < sentence.length; i++) {
      String character = sentence[i];
      if (character == 'F') commands.add(Forward((_) => 10.0));
      if (character == 'G') commands.add(Forward((_) => 10.0));
      if (character == '-') commands.add(Right((_) => 120.0));
      if (character == '+') commands.add(Left((_) => 120.0));
    }
    final sequence = Sequence(
      tempo: 60,
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
        title: const Text('Sierpinski Triangle'),
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
              int firstVoice = midiCScale.first;
              int secondVoice = midiCScale[2];
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
                  firstVoiceCurrentBeat += 1.0;
                }
                if (character == 'G') {
                  secondVoiceTrack.addNote(
                    noteNumber: secondVoice,
                    velocity: secondVoiceVelocity,
                    startBeat: secondVoiceCurrentBeat,
                    durationBeats: 1.0,
                  );
                  secondVoiceCurrentBeat += 0.5;
                }
                if (character == '-') {
                  if (firstVoice != midiCScale.first) {
                    firstVoice = midiCScale[midiCScale.indexOf(firstVoice) - 1];
                  } else {
                    firstVoice = midiCScale.first;
                  }
                  if (secondVoice != midiCScale.first) {
                    secondVoice =
                        midiCScale[midiCScale.indexOf(secondVoice) - 2];
                  } else {
                    secondVoice = midiCScale[2];
                  }
                }
                if (character == '+') {
                  if (firstVoice != midiCScale.last) {
                    firstVoice = midiCScale[Random().nextInt(8)];
                  } else {
                    firstVoice = midiCScale.last;
                  }
                  if (secondVoice != midiCScale.last) {
                    secondVoice =
                        midiCScale[midiCScale.indexOf(secondVoice) + 2];
                  } else {
                    secondVoice = midiCScale[5];
                  }
                }
              }
              sequence.play();
            },
            child: const Text(
              'Music',
              style: TextStyle(color: Colors.white),
            ),
          )
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

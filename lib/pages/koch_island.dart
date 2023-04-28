// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_turtle/flutter_turtle.dart';
import 'package:lindenmayer_systems/src/lindenmayer_systems/dol_system/dol_system.dart';
import 'package:lindenmayer_systems/src/production_rules/production_rule.dart';

final kochIsland = DolSystem(
  alphabet: ['F', '+', '-'],
  axiom: 'F+F+F+F',
  productionRuleSet: {
    ProductionRule(predecessor: 'F', successor: 'F+F-F-FF+F+F-F'),
  },
);

class KochIsland extends StatefulWidget {
  const KochIsland({
    Key? key,
  }) : super(key: key);

  @override
  State<KochIsland> createState() => _KochIslandState();
}

class _KochIslandState extends State<KochIsland> {
  @override
  Widget build(BuildContext context) {
    final sentence = kochIsland.generate(4);
    final commands = <TurtleCommand>[
      GoTo((_) => const Offset(250, 250)),
      PenDown(),
      SetColor(
        (_) => Colors.purple,
      ),
      SetStrokeWidth(
        (_) => 2,
      ),
    ];
    for (int i = 0; i < sentence.length; i++) {
      String character = sentence[i];
      if (character == 'F') commands.add(Forward((_) => 2.0));
      if (character == '-') commands.add(Right((_) => 90.0));
      if (character == '+') commands.add(Left((_) => 90.0));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koch Island'),
        actions: <Widget>[
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text(
              'Run',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ClipRect(
        child: AnimatedTurtleView(
          animationDuration: const Duration(seconds: 12),
          commands: commands,
          child: Container(),
        ),
      ),
    );
  }
}

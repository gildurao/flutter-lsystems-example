// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sierpinski Triangle'),
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
          animationDuration: const Duration(seconds: 15),
          commands: commands,
          child: Container(),
        ),
      ),
    );
  }
}

// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dragon Curve'),
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

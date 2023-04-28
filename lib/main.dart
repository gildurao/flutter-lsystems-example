import 'package:flutter/material.dart';
import 'package:lsystems_example/pages/dragon_curve.dart';
import 'package:lsystems_example/pages/koch_island.dart';
import 'package:lsystems_example/pages/peano_curve.dart';
import 'package:lsystems_example/pages/sierpinski_triangle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'L-Systems Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'L-Systems Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'L-System Examples',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SierpinskiTriangle(),
                  ),
                );
              },
              child: const Text(
                'Sierpinski Triangle',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DragonCurve(),
                  ),
                );
              },
              child: const Text(
                'Dragon Curve',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PeanoCurve(),
                  ),
                );
              },
              child: const Text(
                'Peano Curve',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const KochIsland(),
                  ),
                );
              },
              child: const Text(
                'Koch Island',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

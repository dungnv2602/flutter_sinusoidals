import 'package:flutter/material.dart';

import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: _MagmaWaveDemo(),
      ),
    );
  }
}

const _colors = [
  Colors.brown,
  Colors.amber,
  Colors.teal,
  Colors.cyan,
  Colors.blue,
  Colors.grey,
];

class _SinusoidalsDemo extends StatelessWidget {
  const _SinusoidalsDemo({Key? key}) : super(key: key);

  static const _amplitude = 45.0;
  static const _waves = 3.0;
  static const _height = 200.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Sinusoidals(
          reverse: true,
          itemCount: 3,
          builder: (context, index) {
            return SinusoidalItem(
              model: SinusoidalModel(
                formular: WaveFormular.standing,
                amplitude: _amplitude,
                waves: _waves,
                translate: 5.0 * (index + 1),
                center: 5.0 * (index + 1),
                frequency: 0.5,
              ),
              child: Container(
                height: _height,
                color: _colors[index],
              ),
            );
          },
        ),
        const Spacer(),
        Sinusoidals(
          itemCount: 3,
          builder: (context, index) {
            return SinusoidalItem(
              model: SinusoidalModel(
                formular: WaveFormular.travelling,
                amplitude: _amplitude,
                waves: _waves,
                translate: 5.0 * (index + 1),
                center: 5.0 * (index + 1),
                frequency: 0.5,
              ),
              child: Container(
                height: _height,
                color: _colors[index],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SinusoidalDemo extends StatelessWidget {
  const _SinusoidalDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Sinusoidal(
          reverse: true,
          model: const SinusoidalModel(
            amplitude: 15,
            waves: 5,
            frequency: -0.5,
          ),
          child: Container(
            height: 100,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 50),
        Sinusoidal(
          model: const SinusoidalModel(
            amplitude: 15,
            waves: 5,
          ),
          child: Container(
            height: 100,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 50),
        Sinusoidal(
          model: const SinusoidalModel(
            formular: WaveFormular.standing,
            translate: 5.0,
            amplitude: 25,
            waves: 2,
            frequency: 0.5,
          ),
          child: Container(
            height: 100,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 50),
        Sinusoidal(
          model: const SinusoidalModel(
            formular: WaveFormular.travelling,
            amplitude: 25,
            waves: 2.5,
            frequency: 0.5,
          ),
          child: Container(
            height: 100,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _CombinedWaveDemo extends StatelessWidget {
  const _CombinedWaveDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        CombinedWave(
          reverse: true,
          models: const [
            SinusoidalModel(
              amplitude: 25,
              waves: 20,
              translate: 2.5,
              frequency: 0.5,
            ),
            SinusoidalModel(
              amplitude: 25,
              waves: 15,
              translate: 7.5,
              frequency: 1.5,
            ),
          ],
          child: Container(
            height: 200,
            color: Colors.blue,
          ),
        ),
        const Spacer(),
        CombinedWave(
          models: const [
            SinusoidalModel(
              amplitude: 25,
              waves: 20,
              translate: 2.5,
              frequency: 0.5,
            ),
            SinusoidalModel(
              amplitude: 25,
              waves: 15,
              translate: 7.5,
              frequency: 1.5,
            ),
          ],
          child: Container(
            height: 200,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _MagmaWaveDemo extends StatelessWidget {
  const _MagmaWaveDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        MagmaWave(
          reverse: true,
          child: Container(
            height: 200,
            color: Colors.red,
          ),
        ),
        const Spacer(),
        MagmaWave(
          child: Container(
            height: 200,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

# flutter_sinusoidals

[![Pub](https://img.shields.io/pub/v/flutter_sinusoidals.svg)](https://pub.dartlang.org/packages/flutter_sinusoidals)

A flutter package that helps you to visualize sine waves as you desire.
All basic waves are already supported, plus customized waves & some pre-defined waves.

![Overview](images/record_1.gif)

## Features

- Creating a sine wave.
- Creating a stack of sine waves.
- Combine multiple sine waves together.
- This package use clipping to achieve wave effect so theoretically you can apply it to any widget. For example, an AppBar with a wave on the bottom.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_sinusoidals:
```

In your code add the following import:

```dart
import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';
```

## Built-in waves

This package comes with 4 kinds of sine waves:

### Sinusoidal

A widget which helps visualize a sinusoidal.

![Overview](images/sinusoidal.gif)

Example of a sinusoidal:

```dart
Sinusoidal(
  model: const SinusoidalModel(
    formular: WaveFormular.standing,
    amplitude: 25,
    waves: 2.5,
    frequency: 1.5,
  ),
  child: Container(
    height: 100,
    color: Colors.blue,
  ),
),
```

### Sinusoidals

A widget which helps visualize a stack of sinusoidals.

![Overview](images/sinusoidals.gif)

Example of a sinusoidals:

```dart
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
      ),
      child: Container(
        height: _height,
        color: _colors[index],
      ),
    );
  },
);
```

### CombinedWave

A widget which helps visualize a combined wave.

A combined wave is a wave that is formed by adding multiple sinusoidals together.

![Overview](images/combined_wave.gif)

Example of a combined wave:

```dart
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
```

### MagmaWave

A pre-defined wave that mimicking magma motion.

This is included in the package just to demonstrate that you can create an awesome wave by combining multiple waves together.

![Overview](images/magma_wave.gif)

### References

To know how sinusoidal works: [sinusoidal](https://en.wikipedia.org/wiki/Sine_wave)

Try [demos](https://www.desmos.com/calculator/3renylhzcu) to observe how sinusoidal visually works, and create your version by forming formulas.

## Changelog

See the [Changelog](CHANGELOG.md) to know what was changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fire an [issue](https://github.com/dungnv2602/flutter_sinusoidals/issues).

If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/dungnv2602/flutter_sinusoidals/pulls).

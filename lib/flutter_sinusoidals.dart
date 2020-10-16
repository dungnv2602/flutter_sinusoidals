// Copyright 2020 Nguyen Viet Dung. All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE file.

// @dart = 2.9

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:equatable/equatable.dart';

enum WaveFormular {
  normal,
  standing,
  travelling,
}

const _tau = 2 * math.pi;

/// Signature for [Sinusoidals.builder] that creates a [SinusoidalItem] for a given index.
typedef SinusoidalItemBuilder = SinusoidalItem Function(
  BuildContext context,
  int index,
);

/// An utility class which holds [SinusoidalModel] for each child in [Sinusoidals].
class SinusoidalItem {
  const SinusoidalItem({
    this.model = const SinusoidalModel(),
    @required this.child,
  }) : assert(child != null);

  /// A given child at which will be clipped from to create a sinusoidal.
  final Widget child;

  /// Model given to visualize a sinuisodal.
  final SinusoidalModel model;
}

/// A class which holds params to form sinusoidal formulars.
///
/// For more information about sinusoidal: https://en.wikipedia.org/wiki/Sine_wave
///
/// Try demos to create your sinusoidal: https://www.desmos.com/calculator/ks3f232ook
///
class SinusoidalModel extends Equatable {
  const SinusoidalModel({
    this.formular = WaveFormular.normal,
    this.center = 0,
    this.translate = 0,
    this.amplitude = 10,
    this.frequency = 1,
    this.waves = 1,
  });

  /// Defines what wave formular to use.
  ///
  /// Defaults to [WaveFormular.normal] that uses general form sine wave.
  final WaveFormular formular;

  /// The peak deviation of the function from zero.
  ///
  /// Represent how much space will be clipped to form a wave
  /// from top to bottom, or bottom to top if `reverse = true`.
  final double amplitude;

  /// a non-zero center amplitude, specifies the origin the the wave.
  final double center; // midline

  /// The rate of change of the function argument.
  ///
  /// To make the repeat animation effect seamlessly, `frequency` must be divided by 0.5
  ///
  /// To change the direction of the wave, simply change the sign of `frequency`.
  /// * positive: LTR
  /// * negative: RTL
  final double frequency;

  /// Phase, where in its cycle the oscillation is at t = 0
  ///
  /// When `translate` is non-zero, the entire waveform appears to be shifted in time.
  ///
  /// A negative value represents a delay, and a positive value represents an advance.
  final double translate;

  /// Wave number (or angular wave number).
  final double waves;

  @protected
  double getY(double dx, double time) {
    assert(
      frequency % 0.5 == 0,
      'To get seamlessly animation effect , "frequency" must be divided by 0.5',
    );
    switch (formular) {
      case WaveFormular.travelling:
        return _getTravellingY(dx, time);
      case WaveFormular.standing:
        return _getStandingY(dx, time);
      case WaveFormular.normal:
      default:
        return _getNormalY(dx, time);
    }
  }

  double _getNormalY(double dx, double time) =>
      amplitude * math.sin(waves / 100 * dx - frequency * time + translate) +
      center;

  double _getStandingY(double dx, double time) =>
      amplitude *
          math.sin(waves / 100 * dx + translate) *
          math.sin(frequency * time) +
      center;

  double _getTravellingY(double dx, double time) =>
      amplitude *
          math.sin(waves / 100 * dx - frequency * time + translate) *
          math.sin(frequency * time) +
      center;

  @override
  List<Object> get props => [
        formular,
        amplitude,
        center,
        frequency,
        translate,
        waves,
      ];
}

/// A widget which helps visualize a stack of sinusoidals.
///
/// {@tool snippet}
///
/// Example of a stack of sinusoidals:
///
/// ```
/// Sinusoidals(
///   itemCount: 3,
///   builder: (context, index) {
///     return SinusoidalItem(
///       model: SinusoidalModel(
///         formular: WaveFormular.travelling,
///         amplitude: _amplitude,
///         waves: _waves,
///         translate: 5.0 * (index + 1),
///         center: 5.0 * (index + 1),
///       ),
///       child: Container(
///         height: _height,
///         color: _colors[index],
///       ),
///     );
///   },
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Sinusoidal], which is a widget specialized for visualizing a sinusoidal.
///  * [CombinedWave], which is a widget specialized for visualizing a combined wave.
///
class Sinusoidals extends _BaseWaveWidget {
  const Sinusoidals({
    Key key,
    @required this.itemCount,
    @required this.builder,
    int period,
    bool reverse,
    this.alignment = AlignmentDirectional.topStart,
  })  : assert(itemCount != null),
        assert(builder != null),
        super(
          key: key,
          period: period,
          reverse: reverse ?? false,
        );

  /// Called to build children for this widget.
  final SinusoidalItemBuilder builder;

  /// The total number of children this widget can provide.
  final int itemCount;

  /// [Stack]'s alignment.
  final AlignmentGeometry alignment;

  @override
  _SinusoidalsState createState() => _SinusoidalsState();
}

class _SinusoidalsState extends _BaseWaveWidgetState<Sinusoidals> {
  @override
  Widget build(BuildContext context) {
    final children = List.generate(
      widget.itemCount,
      (index) {
        final item = widget.builder(context, index);
        return ClipPath(
          clipper: _SinusoidalClipper(
            time: _timeController,
            model: item.model,
            reverse: widget.reverse,
          ),
          child: item.child,
        );
      },
    );

    return Stack(
      alignment: widget.alignment,
      children: children,
    );
  }
}

/// A widget which helps visualize a sinusoidal.
///
/// {@tool snippet}
///
/// Example of a sinusoidal:
///
/// ```
/// Sinusoidal(
///   model: const SinusoidalModel(
///     formular: WaveFormular.travelling,
///     amplitude: 25,
///     waves: 2.5,
///     frequency: 1.5,
///   ),
///   child: Container(
///     height: 100,
///     color: Colors.blue,
///   ),
/// ),
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Sinusoidals], which is a widget specialized for visualizing a stack of sinusoidals.
///  * [CombinedWave], which is a widget specialized for visualizing a combined wave.
///
class Sinusoidal extends _BaseWaveWidget {
  const Sinusoidal({
    Key key,
    this.model = const SinusoidalModel(),
    int period,
    bool reverse,
    @required this.child,
  })  : assert(child != null),
        super(
          key: key,
          period: period,
          reverse: reverse ?? false,
        );

  /// A given child at which will be  from to create a sinusoidal.
  final Widget child;

  /// Model given to visualize a sinuisodal.
  final SinusoidalModel model;

  @override
  _SinusoidalState createState() => _SinusoidalState();
}

class _SinusoidalState extends _BaseWaveWidgetState<Sinusoidal> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SinusoidalClipper(
        time: _timeController,
        model: widget.model,
        reverse: widget.reverse,
      ),
      child: widget.child,
    );
  }
}

/// A widget which helps visualize a combined wave.
///
/// A combined wave is a wave that is formed by adding multiple sinusoidals together.
///
/// {@tool snippet}
///
/// Example of a combined wave:
///
/// ```
/// CombinedWave(
///   reverse: true,
///   models: const [
///     SinusoidalModel(
///       amplitude: 25,
///       waves: 20,
///       translate: 2.5,
///       frequency: 0.5,
///     ),
///     SinusoidalModel(
///       amplitude: 25,
///       waves: 15,
///       translate: 7.5,
///       frequency: 1.5,
///     ),
///   ],
///   child: Container(
///     height: 200,
///     color: Colors.blue,
///   ),
/// ),
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Sinusoidals], which is a widget specialized for visualizing a stack of sinusoidals.
///  * [Sinusoidal], which is a widget specialized for visualizing a sinusoidal.
///
class CombinedWave extends _BaseWaveWidget {
  const CombinedWave({
    Key key,
    @required this.models,
    int period,
    bool reverse,
    @required this.child,
  })  : assert(child != null),
        super(
          key: key,
          period: period,
          reverse: reverse ?? false,
        );

  /// A given child at which will be  from to create a wave.
  final Widget child;

  /// Models given to visualize a combined wave.
  final List<SinusoidalModel> models;

  @override
  _CombinedWaveState createState() => _CombinedWaveState();
}

class _CombinedWaveState extends _BaseWaveWidgetState<CombinedWave> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CombinedWaveClipper(
        time: _timeController,
        models: widget.models,
        reverse: widget.reverse,
      ),
      child: widget.child,
    );
  }
}

/// A pre-defined wave that mimicking magma motion.
///
/// [child]'s height need to be at least 100 to work.
class MagmaWave extends _BaseWaveWidget {
  const MagmaWave({
    Key key,
    int period,
    bool reverse,
    @required this.child,
  })  : assert(child != null),
        super(
          key: key,
          period: period,
          reverse: reverse ?? false,
        );

  /// A given child at which will be  from to create a wave.
  final Widget child;

  @override
  _MagmaWaveState createState() => _MagmaWaveState();
}

class _MagmaWaveState extends _BaseWaveWidgetState<MagmaWave> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _MagmaWaveClipper(
        time: _timeController,
        reverse: widget.reverse,
      ),
      child: widget.child,
    );
  }
}

abstract class _BaseWaveWidget extends StatefulWidget {
  const _BaseWaveWidget({
    Key key,
    this.period,
    this.reverse,
  }) : super(key: key);

  /// The period (measured in milliseconds) to complete a full revolution.
  final int period;

  /// If `reverse = true`, then clipping from bottom to top.
  ///
  /// Default is clipping from top to bottom.
  final bool reverse;
}

abstract class _BaseWaveWidgetState<T extends _BaseWaveWidget> extends State<T>
    with SingleTickerProviderStateMixin<T> {
  AnimationController _timeController;

  @override
  void initState() {
    super.initState();
    _timeController = AnimationController(
      vsync: this,
      upperBound: 2 * _tau,
      animationBehavior: AnimationBehavior.preserve,
      duration: Duration(milliseconds: widget.period ?? 5000),
    );
    _timeController.repeat();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}

class _SinusoidalClipper extends CustomClipper<Path> {
  _SinusoidalClipper({
    this.time,
    this.model,
    this.reverse,
  }) : super(reclip: time);

  static final List<Offset> offsets = <Offset>[];

  final Animation<double> time;
  final SinusoidalModel model;
  final bool reverse;

  @override
  Path getClip(Size size) {
    offsets.clear();

    for (double dx = 0.0; dx <= size.width; dx++) {
      offsets.add(Offset(dx, _getY(size, dx)));
    }

    return _getPath(reverse, offsets, size);
  }

  double _getY(Size size, double dx) {
    final y = model.getY(dx, time.value);
    final amplitude = model.amplitude;
    return reverse ? size.height - y - amplitude : y + amplitude;
  }

  @override
  bool shouldReclip(_SinusoidalClipper oldClipper) =>
      reverse != oldClipper.reverse ||
      time != oldClipper.time ||
      model != oldClipper.model;
}

class _CombinedWaveClipper extends CustomClipper<Path> {
  _CombinedWaveClipper({
    this.time,
    this.models,
    this.reverse,
  }) : super(reclip: time);

  static final List<Offset> offsets = <Offset>[];

  final Animation<double> time;
  final List<SinusoidalModel> models;
  final bool reverse;

  @override
  Path getClip(Size size) {
    offsets.clear();

    for (double dx = 0.0; dx <= size.width; dx++) {
      offsets.add(Offset(dx, _getY(size, dx)));
    }

    return _getPath(reverse, offsets, size);
  }

  double _getY(Size size, double dx) {
    final y = models
        .map((model) => model.getY(dx, time.value))
        .reduce((current, next) => current + next);
    final amplitude = models
        .map((model) => model.amplitude)
        .reduce((current, next) => current + next);
    return reverse ? size.height - y - amplitude : y + amplitude;
  }

  @override
  bool shouldReclip(_CombinedWaveClipper oldClipper) =>
      reverse != oldClipper.reverse ||
      time != oldClipper.time ||
      models != oldClipper.models;
}

class _MagmaWaveClipper extends CustomClipper<Path> {
  _MagmaWaveClipper({
    this.time,
    this.reverse,
  }) : super(reclip: time);

  static final List<Offset> offsets = <Offset>[];

  final Animation<double> time;
  final bool reverse;

  @override
  Path getClip(Size size) {
    offsets.clear();

    for (double dx = 0.0; dx <= size.width; dx++) {
      offsets.add(Offset(dx, _getY(size, dx)));
    }

    return _getPath(reverse, offsets, size);
  }

  double _getY(Size size, double dx) {
    final y = _getNormalY1(dx, time.value) +
        _getNormalY2(dx, time.value) +
        _getNormalY3(dx, time.value) +
        _getNormalY4(dx, time.value);

    const amplitude = 100;

    return reverse ? size.height - y - amplitude : y + amplitude;
  }

  double _getNormalY1(double dx, double time) =>
      25 * math.sin(math.cos(5 / 100 * dx) - time + 2.5);
  double _getNormalY2(double dx, double time) =>
      25 * math.cos(math.sin(25 / 100 * dx) - 2 * time + 2.5);
  double _getNormalY3(double dx, double time) =>
      25 * math.sin(math.sin(15 / 100 * dx) - math.sin(2 * time) + 2.5);
  double _getNormalY4(double dx, double time) =>
      25 * math.cos(math.cos(5 / 100 * dx) - math.cos(time) + 2.5);

  @override
  bool shouldReclip(_MagmaWaveClipper oldClipper) =>
      reverse != oldClipper.reverse || time != oldClipper.time;
}

Path _getPath(bool reverse, List<Offset> offsets, Size size) {
  if (reverse) {
    return Path()
      ..lineTo(0.0, size.height)
      ..addPolygon(offsets, false)
      ..lineTo(size.width, 0.0)
      ..lineTo(0.0, 0.0)
      ..close();
  } else {
    return Path()
      ..addPolygon(offsets, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math';

List<Widget> buildRotatingPhotos(BuildContext context) {
  var isTablet = MediaQuery.sizeOf(context).shortestSide < 800;
  var dimens = isTablet ? smallDeviceDimens : largeDeviceDimens;

  return <Widget>[
    Positioned(
      top: dimens[0].first.top,
      right: dimens[0].first.right,
      child: RotateScaleWidget(
        width: dimens[0].second,
        child: CachedNetworkImage(
            width: dimens[0].second,
            imageUrl: 'https://rstr.in/google/tripedia/x9b8ZmlQhod'),
      ),
    ),
    Positioned(
      top: dimens[1].first.top,
      left: dimens[1].first.left,
      child: RotateScaleWidget(
        width: dimens[1].second,
        child: CachedNetworkImage(
            width: dimens[1].second,
            imageUrl: 'https://rstr.in/google/tripedia/llRpA9RuvTy'),
      ),
    ),
    Positioned(
      bottom: dimens[2].first.bottom,
      right: dimens[2].first.right,
      child: RotateScaleWidget(
        width: dimens[2].second,
        child: CachedNetworkImage(
            width: dimens[2].second,
            imageUrl: 'https://rstr.in/google/tripedia/ANNOvZaekFJ'),
      ),
    ),
    Positioned(
      bottom: dimens[3].first.bottom,
      right: dimens[3].first.right,
      child: RotateScaleWidget(
        width: dimens[3].second,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: CachedNetworkImage(
              width: dimens[3].second,
              imageUrl: 'https://rstr.in/google/tripedia/Y292jg7Wr69'),
        ),
      ),
    ),
  ];
}

class RotateScaleWidget extends StatefulWidget {
  const RotateScaleWidget(
      {required this.width, required this.child, super.key});

  final double width;
  final Widget child;

  @override
  State<RotateScaleWidget> createState() => _RotateScaleWidgetState();
}

class _RotateScaleWidgetState extends State<RotateScaleWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 13),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: -pi / 24, end: pi / 24).animate(_controller),
      child: SizedBox(
        width: widget.width,
        child: widget.child,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 2.seconds)
        .then()
        .scale(
            begin: const Offset(.5, .5),
            end: const Offset(1, 1),
            duration: 10.seconds)
        .then()
        .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 1.seconds)
        .fadeOut(duration: 3.seconds);
  }
}

class Pair<S, T> {
  late S first;
  late T second;

  Pair(this.first, this.second);
}

final smallDeviceDimens = <Pair<EdgeInsets, double>>[
  Pair(const EdgeInsets.only(top: -100, right: -100), 400),
  Pair(const EdgeInsets.only(top: 300, left: -100), 200),
  Pair(const EdgeInsets.only(right: 40, bottom: 250), 100),
  Pair(const EdgeInsets.only(right: -100, bottom: -100), 400)
];
final largeDeviceDimens = <Pair<EdgeInsets, double>>[
  Pair(const EdgeInsets.only(top: -85, right: 100), 400),
  Pair(const EdgeInsets.only(top: 300, left: 150), 250),
  Pair(const EdgeInsets.only(right: 370, bottom: 370), 100),
  Pair(const EdgeInsets.only(right: 100, bottom: -50), 400)
];

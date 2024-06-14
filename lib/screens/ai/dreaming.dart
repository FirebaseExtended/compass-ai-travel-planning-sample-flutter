import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../branding.dart';
import '../components/app_bar.dart';
import 'dart:math';
import 'dart:ui';
import '../../view_models/intineraries_viewmodel.dart';

class DreamingScreen extends StatefulWidget {
  const DreamingScreen({super.key});

  @override
  State<DreamingScreen> createState() => _DreamingScreenState();
}

class _DreamingScreenState extends State<DreamingScreen> {
  late final itinerariesVM = context.read<ItinerariesViewModel>();

  @override
  void initState() {
    itinerariesVM.addListener(_showError);
    super.initState();
  }

  @override
  void dispose() {
    itinerariesVM.removeListener(_showError);
    super.dispose();
  }

  void _showError() async {
    var vm = context.read<ItinerariesViewModel>();
    var errorMessage = vm.errorMessage;

    if (errorMessage != null) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            errorMessage,
          ),
          content: const Text('Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                vm.clearError();
                Navigator.of(context).pop();
                context.go('/');
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff352F34),
      appBar: brandedAppBar,
      body: Stack(children: [
        Positioned(
          top: -100,
          right: -100,
          child: RotatingWidget(
            width: 400,
            child: Image.network(
                width: 400, 'https://rstr.in/google/tripedia/x9b8ZmlQhod'),
          ),
        ),
        Positioned(
          top: 300,
          left: -100,
          child: RotatingWidget(
            width: 200,
            child: Image.network(
                width: 200, 'https://rstr.in/google/tripedia/llRpA9RuvTy'),
          ),
        ),
        Positioned(
          bottom: 250,
          right: 40,
          child: RotatingWidget(
            width: 100,
            child: Image.network(
                width: 100, 'https://rstr.in/google/tripedia/ANNOvZaekFJ'),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: RotatingWidget(
            width: 400,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Image.network(
                  width: 400, 'https://rstr.in/google/tripedia/Y292jg7Wr69'),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppLogo(dimension: 38),
                Text(
                  'Dreaming',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox.square(
                  dimension: 8,
                ),
                const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}

class RotatingWidget extends StatefulWidget {
  const RotatingWidget({required this.width, required this.child, super.key});

  final double width;
  final Widget child;

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
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
        .fadeIn(duration: 1.seconds)
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
        .fadeOut(duration: 1.seconds);
  }
}
